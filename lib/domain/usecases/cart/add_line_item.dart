import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

/// Adds a line item to a cart use case
class AddLineItem implements UseCase<Cart, AddLineItemParams> {
  final CartRepository repository;

  /// Creates an [AddLineItem] instance
  AddLineItem(this.repository);

  @override
  Future<Either<Failure, Cart>> call(AddLineItemParams params) async {
    return await repository.addLineItem(
      params.cartId,
      params.variantId,
      params.quantity,
    );
  }
}

/// Parameters for [AddLineItem]
class AddLineItemParams extends Equatable {
  /// The ID of the cart to add the line item to
  final String cartId;
  
  /// The ID of the product variant to add
  final String variantId;
  
  /// The quantity of the product variant to add
  final int quantity;

  /// Creates an [AddLineItemParams] instance
  const AddLineItemParams({
    required this.cartId,
    required this.variantId,
    required this.quantity,
  });

  @override
  List<Object> get props => [cartId, variantId, quantity];
} 