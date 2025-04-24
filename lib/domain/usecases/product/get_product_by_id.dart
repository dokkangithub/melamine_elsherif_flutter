import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/domain/repositories/product_repository.dart';

/// Gets a product by ID
class GetProductById implements UseCase<Product, GetProductByIdParams> {
  final ProductRepository repository;

  /// Creates a [GetProductById] instance
  GetProductById(this.repository);

  @override
  Future<Either<Failure, Product>> call(GetProductByIdParams params) async {
    return await repository.getProductById(params.id);
  }
}

/// Parameters for [GetProductById]
class GetProductByIdParams extends Equatable {
  /// The ID of the product to get
  final String id;

  /// Creates a [GetProductByIdParams] instance
  const GetProductByIdParams({required this.id});

  @override
  List<Object> get props => [id];
} 