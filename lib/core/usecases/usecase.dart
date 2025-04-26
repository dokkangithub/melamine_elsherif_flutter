import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';

/// Abstract class for use cases that follow clean architecture principles
abstract class UseCase<Type, Params> {
  /// Execute the use case
  Future<Either<Failure, Type>> call(Params params);
}

/// A no-parameter class for use cases that don't need any parameters
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
} 