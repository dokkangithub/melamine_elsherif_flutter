import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/repositories/auth_repository.dart';

/// Logout use case that signs out the current user
class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  /// Execute the logout use case
  /// Returns Either a Failure or true if successful
  Future<Either<Failure, bool>> execute() async {
    return await repository.logout();
  }
} 