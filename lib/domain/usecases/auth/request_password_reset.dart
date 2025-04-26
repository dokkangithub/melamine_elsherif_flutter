import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/repositories/auth_repository.dart';

/// RequestPasswordReset use case that sends a password reset link to the user's email
class RequestPasswordReset {
  final AuthRepository repository;

  RequestPasswordReset(this.repository);

  /// Execute the request password reset use case
  /// [email] - User's email address
  /// Returns Either a Failure or a bool indicating success
  Future<Either<Failure, bool>> execute({required String email}) async {
    return await repository.requestPasswordReset(email: email);
  }
} 