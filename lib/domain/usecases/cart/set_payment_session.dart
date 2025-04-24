import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

/// Sets the payment session for a cart use case
class SetPaymentSession implements UseCase<Cart, SetPaymentSessionParams> {
  final CartRepository repository;

  /// Creates a [SetPaymentSession] instance
  SetPaymentSession(this.repository);

  @override
  Future<Either<Failure, Cart>> call(SetPaymentSessionParams params) async {
    return await repository.setPaymentSession(
      params.cartId,
      params.providerId,
    );
  }
}

/// Parameters for [SetPaymentSession]
class SetPaymentSessionParams extends Equatable {
  /// The ID of the cart to set the payment session for
  final String cartId;
  
  /// The ID of the payment provider to use
  final String providerId;

  /// Creates a [SetPaymentSessionParams] instance
  const SetPaymentSessionParams({
    required this.cartId,
    required this.providerId,
  });

  @override
  List<Object> get props => [cartId, providerId];
} 