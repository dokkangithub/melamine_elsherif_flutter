import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/entities/user.dart';
import 'package:melamine_elsherif/domain/repositories/auth_repository.dart';

/// GetCurrentUser use case that returns the currently authenticated user
class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  /// Execute the get current user use case
  /// Returns Either a Failure or the current authenticated [User]
  Future<Either<Failure, User>> execute() async {
    return await repository.getCurrentUser();
  }
} 