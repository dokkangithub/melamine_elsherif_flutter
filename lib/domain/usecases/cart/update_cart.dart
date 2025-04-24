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
      params.id,
      regionId: params.regionId,
      email: params.email,
      billingAddressId: params.billingAddressId,
      shippingAddressId: params.shippingAddressId,
      metadata: params.metadata,
    );
  }
}

/// Parameters for [UpdateCart]
class UpdateCartParams extends Equatable {
  /// The ID of the cart to update
  final String id;
  
  /// The region ID to set
  final String? regionId;
  
  /// The email to set
  final String? email;
  
  /// The billing address ID to set
  final String? billingAddressId;
  
  /// The shipping address ID to set
  final String? shippingAddressId;
  
  /// The metadata to set
  final Map<String, dynamic>? metadata;

  /// Creates an [UpdateCartParams] instance
  const UpdateCartParams({
    required this.id,
    this.regionId,
    this.email,
    this.billingAddressId,
    this.shippingAddressId,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    regionId,
    email,
    billingAddressId,
    shippingAddressId,
    metadata,
  ];
} 