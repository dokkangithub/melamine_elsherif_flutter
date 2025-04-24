import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/entities/user.dart';

/// Repository interface for authentication related operations
abstract class AuthRepository {
  /// Logs in a user with email and password
  Future<Either<Failure, User>> login({
    required String email, 
    required String password,
  });

  /// Registers a new user
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  });

  /// Logs out the current user
  Future<Either<Failure, bool>> logout();

  /// Gets the current authenticated user
  Future<Either<Failure, User>> getCurrentUser();

  /// Checks if user is logged in
  Future<Either<Failure, bool>> isLoggedIn();

  /// Requests a password reset email
  Future<Either<Failure, bool>> requestPasswordReset({
    required String email,
  });

  /// Resets password with token
  Future<Either<Failure, bool>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Updates the user's password
  Future<Either<Failure, bool>> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Updates the user's profile information
  Future<Either<Failure, User>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
  });
} 