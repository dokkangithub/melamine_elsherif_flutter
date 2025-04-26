import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

/// Updates cart information use case
class UpdateCart implements UseCase<Cart, UpdateCartParams> {
  final CartRepository repository;

  /// Creates an [UpdateCart] instance
  UpdateCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call(UpdateCartParams params) async {
    return await repository.updateCart(
      cartId: params.cartId,
      lineItemId: params.lineItemId,
      quantity: params.quantity,
      discountCode: params.discountCode,
    );
  }
}

/// Parameters for [UpdateCart]
class UpdateCartParams extends Equatable {
  /// The ID of the cart to update
  final String cartId;
  
  /// The line item ID to update
  final String? lineItemId;
  
  /// The quantity to set
  final int? quantity;
  
  /// The discount code to apply
  final String? discountCode;

  /// Creates an [UpdateCartParams] instance
  const UpdateCartParams({
    required this.cartId,
    this.lineItemId,
    this.quantity,
    this.discountCode,
  });

  @override
  List<Object?> get props => [
    cartId,
    lineItemId,
    quantity,
    discountCode,
  ];
} 