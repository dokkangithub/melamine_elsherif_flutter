import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

/// Removes a line item from a cart use case
class RemoveLineItem implements UseCase<Cart, RemoveLineItemParams> {
  final CartRepository repository;

  /// Creates a [RemoveLineItem] instance
  RemoveLineItem(this.repository);

  @override
  Future<Either<Failure, Cart>> call(RemoveLineItemParams params) async {
    return await repository.removeItem(
      cartId: params.cartId,
      lineItemId: params.lineItemId,
    );
  }
}

/// Parameters for [RemoveLineItem]
class RemoveLineItemParams extends Equatable {
  /// The ID of the cart to remove the line item from
  final String cartId;
  
  /// The ID of the line item to remove
  final String lineItemId;

  /// Creates a [RemoveLineItemParams] instance
  const RemoveLineItemParams({
    required this.cartId,
    required this.lineItemId,
  });

  @override
  List<Object> get props => [cartId, lineItemId];
} 