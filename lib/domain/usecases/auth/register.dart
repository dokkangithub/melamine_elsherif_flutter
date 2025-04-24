import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/user.dart';
import 'package:melamine_elsherif/domain/repositories/auth_repository.dart';

class RegisterParams {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phone;

  RegisterParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phone,
  });
}

/// Register use case that creates a new user account
class Register implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  Register(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) {
    return repository.register(
      email: params.email,
      password: params.password,
      firstName: params.firstName,
      lastName: params.lastName,
      phone: params.phone,
    );
  }
} 