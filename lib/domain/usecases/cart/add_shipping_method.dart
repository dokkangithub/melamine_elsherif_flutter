import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

/// Adds a shipping method to a cart use case
class AddShippingMethod implements UseCase<Cart, AddShippingMethodParams> {
  final CartRepository repository;

  /// Creates an [AddShippingMethod] instance
  AddShippingMethod(this.repository);

  @override
  Future<Either<Failure, Cart>> call(AddShippingMethodParams params) async {
    return await repository.addShippingMethod(
      params.cartId,
      params.optionId,
      params.data,
    );
  }
}

/// Parameters for [AddShippingMethod]
class AddShippingMethodParams extends Equatable {
  /// The ID of the cart to add the shipping method to
  final String cartId;
  
  /// The ID of the shipping option to add
  final String optionId;
  
  /// Additional data for the shipping method
  final Map<String, dynamic>? data;

  /// Creates an [AddShippingMethodParams] instance
  const AddShippingMethodParams({
    required this.cartId,
    required this.optionId,
    this.data,
  });

  @override
  List<Object?> get props => [cartId, optionId, data];
} 