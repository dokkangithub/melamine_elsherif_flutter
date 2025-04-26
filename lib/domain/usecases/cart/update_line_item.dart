import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

/// Updates a line item in a cart use case
class UpdateLineItem implements UseCase<Cart, UpdateLineItemParams> {
  final CartRepository repository;

  /// Creates an [UpdateLineItem] instance
  UpdateLineItem(this.repository);

  @override
  Future<Either<Failure, Cart>> call(UpdateLineItemParams params) async {
    return await repository.updateCart(
      cartId: params.cartId,
      lineItemId: params.lineItemId,
      quantity: params.quantity,
    );
  }
}

/// Parameters for [UpdateLineItem]
class UpdateLineItemParams extends Equatable {
  /// The ID of the cart containing the line item
  final String cartId;
  
  /// The ID of the line item to update
  final String lineItemId;
  
  /// The new quantity of the line item
  final int quantity;

  /// Creates an [UpdateLineItemParams] instance
  const UpdateLineItemParams({
    required this.cartId,
    required this.lineItemId,
    required this.quantity,
  });

  @override
  List<Object> get props => [cartId, lineItemId, quantity];
} 