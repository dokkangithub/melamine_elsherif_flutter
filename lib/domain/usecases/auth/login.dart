import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/entities/user.dart';
import 'package:melamine_elsherif/domain/repositories/auth_repository.dart';

/// Login use case that authenticates a user with email and password
class Login {
  final AuthRepository repository;

  Login(this.repository);

  /// Execute the login use case
  /// [email] - User's email address
  /// [password] - User's password
  /// Returns an Either with a Failure or User if successful
  Future<Either<Failure, User>> execute({
    required String email,
    required String password,
  }) async {
    return await repository.login(email: email, password: password);
  }
} 