import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

class RemoveFromCart implements UseCase<Cart, RemoveFromCartParams> {
  final CartRepository repository;
  
  RemoveFromCart(this.repository);
  
  @override
  Future<Either<Failure, Cart>> call(RemoveFromCartParams params) async {
    return await repository.removeItem(
      cartId: params.cartId,
      lineItemId: params.lineItemId,
    );
  }
}

class RemoveFromCartParams extends Equatable {
  final String cartId;
  final String lineItemId;
  
  const RemoveFromCartParams({
    required this.cartId,
    required this.lineItemId,
  });
  
  @override
  List<Object> get props => [cartId, lineItemId];
} 