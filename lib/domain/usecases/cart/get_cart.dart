import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

/// Gets a cart by ID use case
class GetCart implements UseCase<Cart, GetCartParams> {
  final CartRepository repository;

  /// Creates a [GetCart] instance
  GetCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call([GetCartParams? params]) async {
    return await repository.getCart(cartId: params?.cartId);
  }
}

/// Parameters for [GetCart]
class GetCartParams extends Equatable {
  /// The ID of the cart to get
  final String? cartId;

  /// Creates a [GetCartParams] instance
  const GetCartParams({this.cartId});

  @override
  List<Object?> get props => [cartId];
} 