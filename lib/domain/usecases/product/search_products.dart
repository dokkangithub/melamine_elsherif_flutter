import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/domain/repositories/product_repository.dart';

/// Searches for products by query
class SearchProducts implements UseCase<List<Product>, SearchProductsParams> {
  final ProductRepository repository;

  /// Creates a [SearchProducts] instance
  SearchProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(SearchProductsParams params) async {
    return await repository.searchProducts(params.query);
  }
}

/// Parameters for [SearchProducts]
class SearchProductsParams extends Equatable {
  /// The search query
  final String query;

  /// Creates a [SearchProductsParams] instance
  const SearchProductsParams({required this.query});

  @override
  List<Object> get props => [query];
} 