import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

/// Creates a new cart use case
class CreateCart implements UseCase<Cart, NoParams> {
  final CartRepository repository;

  /// Creates a [CreateCart] instance
  CreateCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call(NoParams params) async {
    return await repository.createCart();
  }
} 