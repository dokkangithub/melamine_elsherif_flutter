import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

class AddToCart implements UseCase<Cart, AddToCartParams> {
  final CartRepository repository;
  
  AddToCart(this.repository);
  
  @override
  Future<Either<Failure, Cart>> call(AddToCartParams params) async {
    return await repository.addItem(
      cartId: params.cartId,
      variantId: params.variantId,
      quantity: params.quantity,
    );
  }
}

class AddToCartParams extends Equatable {
  final String? cartId;
  final String variantId;
  final int quantity;
  
  const AddToCartParams({
    this.cartId,
    required this.variantId,
    this.quantity = 1,
  });
  
  @override
  List<Object?> get props => [cartId, variantId, quantity];
} 