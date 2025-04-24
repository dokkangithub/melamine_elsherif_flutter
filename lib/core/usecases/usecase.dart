import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';

/// Abstract class for defining use cases in the domain layer.
/// [Type] the return type of the use case
/// [Params] the parameter type for the use case
abstract class UseCase<Type, Params> {
  /// Call method to execute the use case
  Future<Either<Failure, Type>> call(Params params);
}

/// Class representing no parameters for use cases that don't need parameters
class NoParams {
  const NoParams();
} 