import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

/// Completes a cart checkout use case
class CompleteCart implements UseCase<Map<String, dynamic>, CompleteCartParams> {
  final CartRepository repository;

  /// Creates a [CompleteCart] instance
  CompleteCart(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(CompleteCartParams params) async {
    return await repository.completeCart(params.cartId);
  }
}

/// Parameters for [CompleteCart]
class CompleteCartParams extends Equatable {
  /// The ID of the cart to complete
  final String cartId;

  /// Creates a [CompleteCartParams] instance
  const CompleteCartParams({required this.cartId});

  @override
  List<Object> get props => [cartId];
} 