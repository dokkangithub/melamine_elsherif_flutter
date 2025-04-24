import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/domain/repositories/product_repository.dart';

/// Gets a list of products with optional filters
class GetProducts implements UseCase<List<Product>, GetProductsParams> {
  final ProductRepository repository;

  /// Creates a [GetProducts] instance
  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    return await repository.getProducts(
      offset: params.offset,
      limit: params.limit,
      search: params.search,
      categoryIds: params.categoryIds,
      collectionIds: params.collectionIds,
      tagIds: params.tagIds,
      sortBy: params.sortBy,
      sortDesc: params.sortDesc,
    );
  }
}

/// Parameters for [GetProducts]
class GetProductsParams extends Equatable {
  /// The number of products to skip (for pagination)
  final int? offset;
  
  /// The maximum number of products to return
  final int? limit;
  
  /// The search query
  final String? search;
  
  /// The category IDs to filter by
  final List<String>? categoryIds;
  
  /// The collection IDs to filter by
  final List<String>? collectionIds;
  
  /// The tag IDs to filter by
  final List<String>? tagIds;
  
  /// The field to sort by
  final String? sortBy;
  
  /// Whether to sort in descending order
  final bool? sortDesc;

  /// Creates a [GetProductsParams] instance
  const GetProductsParams({
    this.offset,
    this.limit,
    this.search,
    this.categoryIds,
    this.collectionIds,
    this.tagIds,
    this.sortBy,
    this.sortDesc,
  });

  @override
  List<Object?> get props => [
    offset,
    limit,
    search,
    categoryIds,
    collectionIds,
    tagIds,
    sortBy,
    sortDesc,
  ];
} 