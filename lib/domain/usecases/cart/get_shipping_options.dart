import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/shipping_option.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

/// Gets shipping options for a cart use case
class GetShippingOptions implements UseCase<List<ShippingOption>, GetShippingOptionsParams> {
  final CartRepository repository;

  /// Creates a [GetShippingOptions] instance
  GetShippingOptions(this.repository);

  @override
  Future<Either<Failure, List<ShippingOption>>> call(GetShippingOptionsParams params) async {
    return await repository.getShippingOptions(params.cartId);
  }
}

/// Parameters for [GetShippingOptions]
class GetShippingOptionsParams extends Equatable {
  /// The ID of the cart to get shipping options for
  final String cartId;

  /// Creates a [GetShippingOptionsParams] instance
  const GetShippingOptionsParams({required this.cartId});

  @override
  List<Object> get props => [cartId];
} 