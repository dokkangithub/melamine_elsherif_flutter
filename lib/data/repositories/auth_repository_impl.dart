import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/network/network_info.dart';
import 'package:melamine_elsherif/domain/entities/user.dart';
import 'package:melamine_elsherif/domain/repositories/auth_repository.dart';

/// Implementation of the AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;

  /// Creates an [AuthRepositoryImpl] instance
  AuthRepositoryImpl({
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        // Mock implementation for now
        final user = User(
          id: '1',
          email: email,
          firstName: 'John',
          lastName: 'Doe',
          isActive: true,
          isVerified: true,
        );
        return Right(user);
      } on ApiException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
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
        // Mock implementation for now
        final user = User(
          id: '1',
          email: email,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          isActive: true,
          isVerified: false,
        );
        return Right(user);
      } on ApiException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        // Mock implementation for now
        return const Right(true);
      } on ApiException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        // Mock implementation for now
        final user = User(
          id: '1',
          email: 'johndoe@example.com',
          firstName: 'John',
          lastName: 'Doe',
          isActive: true,
          isVerified: true,
        );
        return Right(user);
      } on ApiException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      // Mock implementation for now
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> requestPasswordReset({
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        // Mock implementation for now
        return const Right(true);
      } on ApiException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
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
        // Mock implementation for now
        return const Right(true);
      } on ApiException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        // Mock implementation for now
        return const Right(true);
      } on ApiException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        // Mock implementation for now
        final user = User(
          id: '1',
          email: 'johndoe@example.com',
          firstName: firstName ?? 'John',
          lastName: lastName ?? 'Doe',
          phone: phone,
          isActive: true,
          isVerified: true,
        );
        return Right(user);
      } on ApiException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
} 