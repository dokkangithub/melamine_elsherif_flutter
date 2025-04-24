import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/domain/repositories/product_repository.dart';

/// Gets a product by handle (slug)
class GetProductByHandle implements UseCase<Product, GetProductByHandleParams> {
  final ProductRepository repository;

  /// Creates a [GetProductByHandle] instance
  GetProductByHandle(this.repository);

  @override
  Future<Either<Failure, Product>> call(GetProductByHandleParams params) async {
    return await repository.getProductByHandle(params.handle);
  }
}

/// Parameters for [GetProductByHandle]
class GetProductByHandleParams extends Equatable {
  /// The handle (slug) of the product to get
  final String handle;

  /// Creates a [GetProductByHandleParams] instance
  const GetProductByHandleParams({required this.handle});

  @override
  List<Object> get props => [handle];
} 