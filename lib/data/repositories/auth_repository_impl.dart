import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/network/network_info.dart';
import 'package:melamine_elsherif/data/api/api_client.dart';
import 'package:melamine_elsherif/domain/entities/login_response.dart';
import 'package:melamine_elsherif/domain/entities/user.dart';
import 'package:melamine_elsherif/domain/repositories/auth_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Implementation of the AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final ApiClient apiClient;
  final Talker talker;

  /// Creates an [AuthRepositoryImpl] instance
  AuthRepositoryImpl({
    required this.networkInfo,
    required this.apiClient,
    required this.talker,
  });

  @override
  Future<Either<Failure, LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        talker.debug('👤 Attempting login: $email');
        
        final response = await apiClient.login(email, password);
        
        // First check if we have a token
        final token = response['token'];
        if (token == null) {
          return Left(AuthFailure(message: 'Authentication failed: No token received'));
        }
        
        // If we have a response with customer data
        Map<String, dynamic>? customerData;
        if (response.containsKey('customer') && response['customer'] != null) {
          customerData = response['customer'] as Map<String, dynamic>;
        }
        
        // Create user object - even if customer data is missing, we still have a token
        final user = User(
          id: customerData != null ? (customerData['id'] ?? 'unknown') : 'unknown',
          email: customerData != null ? (customerData['email'] ?? email) : email,
          firstName: customerData != null ? (customerData['first_name'] ?? 'User') : 'User',
          lastName: customerData != null ? (customerData['last_name'] ?? '') : '',
          isActive: customerData != null ? (customerData['has_account'] ?? true) : true,
          isVerified: true,
        );
        
        final loginResponse = LoginResponse(
          user: user,
          token: token,
        );
        
        talker.info('👤 Login successful: ${user.email}');
        return Right(loginResponse);
      } on Exception catch (e) {
        talker.error('👤 Login failed', e);
        
        if (e is ApiException) {
          return Left(AuthFailure(message: e.message));
        } else if (e is ServerException) {
          return Left(ServerFailure(message: e.message));
        }
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      talker.warning('⚠️ No internet connection');
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        talker.debug('👤 Attempting registration: $email');
        
        final response = await apiClient.register(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
        );
        
        final user = User(
          id: response['customer']['id'] ?? '1',
          email: response['customer']['email'] ?? email,
          firstName: response['customer']['first_name'] ?? firstName,
          lastName: response['customer']['last_name'] ?? lastName,
          phone: response['customer']['phone'] ?? phone,
          isActive: response['customer']['has_account'] ?? true,
          isVerified: false,
        );
        
        talker.info('👤 Registration successful: ${user.email}');
        return Right(user);
      } on Exception catch (e) {
        talker.error('👤 Registration failed', e);
        
        if (e is ApiException) {
          if (e.message.toLowerCase().contains('email') && 
              (e.message.toLowerCase().contains('exist') || e.message.toLowerCase().contains('already'))) {
            return Left(AuthFailure(message: e.message));
          }
          return Left(AuthFailure(message: e.message));
        } else if (e is ServerException) {
          return Left(ServerFailure(message: e.message));
        }
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      talker.warning('⚠️ No internet connection');
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        talker.debug('👤 Attempting logout');
        
        await apiClient.logout();
        
        talker.info('👤 Logout successful');
        return const Right(true);
      } on Exception catch (e) {
        talker.error('👤 Logout failed', e);
        
        if (e is ApiException) {
          return Left(AuthFailure(message: e.message));
        } else if (e is ServerException) {
          return Left(ServerFailure(message: e.message));
        }
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      talker.warning('⚠️ No internet connection');
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        talker.debug('👤 Fetching current user');
        
        final response = await apiClient.getCurrentUser();
        
        final user = User(
          id: response['customer']['id'] ?? '1',
          email: response['customer']['email'] ?? 'user@example.com',
          firstName: response['customer']['first_name'] ?? 'User',
          lastName: response['customer']['last_name'] ?? '',
          phone: response['customer']['phone'],
          isActive: response['customer']['has_account'] ?? true,
          isVerified: true,
        );
        
        talker.info('👤 Current user fetched: ${user.email}');
        return Right(user);
      } on Exception catch (e) {
        talker.error('👤 Failed to get current user', e);
        
        if (e is ApiException) {
          return Left(AuthFailure(message: e.message));
        } else if (e is ServerException) {
          return Left(ServerFailure(message: e.message));
        }
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      talker.warning('⚠️ No internet connection');
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await apiClient.getAuthToken();
      return Right(token != null);
    } catch (e) {
      talker.error('❌ Error checking login state', e);
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> requestPasswordReset({
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        talker.debug('👤 Requesting password reset: $email');
        
        await apiClient.requestPasswordReset(email);
        
        talker.info('👤 Password reset email sent');
        return const Right(true);
      } on Exception catch (e) {
        talker.error('👤 Password reset request failed', e);
        
        if (e is ApiException) {
          return Left(AuthFailure(message: e.message));
        } else if (e is ServerException) {
          return Left(ServerFailure(message: e.message));
        }
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      talker.warning('⚠️ No internet connection');
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        talker.debug('👤 Resetting password with token');
        
        await apiClient.resetPassword(token, newPassword);
        
        talker.info('👤 Password reset successful');
        return const Right(true);
      } on Exception catch (e) {
        talker.error('👤 Password reset failed', e);
        
        if (e is ApiException) {
          return Left(AuthFailure(message: e.message));
        } else if (e is ServerException) {
          return Left(ServerFailure(message: e.message));
        }
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      talker.warning('⚠️ No internet connection');
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    // Implement according to Medusa API
    // This would typically call apiClient.updatePassword
    return const Right(true);
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        talker.debug('👤 Updating profile');
        
        final response = await apiClient.updateProfile(
          email: email,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          password: password,
        );
        
        final user = User(
          id: response['customer']['id'] ?? '1',
          email: response['customer']['email'] ?? email ?? 'user@example.com',
          firstName: response['customer']['first_name'] ?? firstName ?? 'User',
          lastName: response['customer']['last_name'] ?? lastName ?? '',
          phone: response['customer']['phone'] ?? phone,
          isActive: response['customer']['has_account'] ?? true,
          isVerified: true,
        );
        
        talker.info('👤 Profile updated successfully: ${user.email}');
        return Right(user);
      } on Exception catch (e) {
        talker.error('👤 Failed to update profile', e);
        
        if (e is ApiException) {
          return Left(AuthFailure(message: e.message));
        } else if (e is ServerException) {
          return Left(ServerFailure(message: e.message));
        }
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      talker.warning('⚠️ No internet connection');
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
} 