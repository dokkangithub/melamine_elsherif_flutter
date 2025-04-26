import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/shipping_option.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

class GetShippingOptions implements UseCase<List<ShippingOption>, GetShippingOptionsParams> {
  final CartRepository repository;

  GetShippingOptions(this.repository);

  @override
  Future<Either<Failure, List<ShippingOption>>> call(GetShippingOptionsParams params) async {
    return await repository.getShippingOptions(params.cartId);
  }
}

class GetShippingOptionsParams extends Equatable {
  final String cartId;

  const GetShippingOptionsParams({required this.cartId});

  @override
  List<Object> get props => [cartId];
} 