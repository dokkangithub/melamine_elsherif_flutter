import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

/// Creates payment sessions for a cart use case
class CreatePaymentSessions implements UseCase<Cart, CreatePaymentSessionsParams> {
  final CartRepository repository;

  /// Creates a [CreatePaymentSessions] instance
  CreatePaymentSessions(this.repository);

  @override
  Future<Either<Failure, Cart>> call(CreatePaymentSessionsParams params) async {
    return await repository.createPaymentSessions(params.cartId);
  }
}

/// Parameters for [CreatePaymentSessions]
class CreatePaymentSessionsParams extends Equatable {
  /// The ID of the cart to create payment sessions for
  final String cartId;

  /// Creates a [CreatePaymentSessionsParams] instance
  const CreatePaymentSessionsParams({required this.cartId});

  @override
  List<Object> get props => [cartId];
} 