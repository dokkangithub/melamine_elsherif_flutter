import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/entities/user.dart';
import 'package:melamine_elsherif/domain/repositories/auth_repository.dart';

class UpdateProfile {
  final AuthRepository repository;

  UpdateProfile(this.repository);

  Future<Either<Failure, User>> execute({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? password,
  }) async {
    return await repository.updateProfile(
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      password: password,
    );
  }
} 