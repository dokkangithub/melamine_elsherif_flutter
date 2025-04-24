import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/entities/product_collection.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';

/// Repository interface for product collection operations
abstract class CollectionRepository {
  /// Gets all product collections
  Future<Either<Failure, List<ProductCollection>>> getCollections({
    int? limit,
    int? offset,
    String? sortBy,
    bool? sortDesc,
  });

  /// Gets a product collection by ID
  Future<Either<Failure, ProductCollection>> getCollectionById(String id);

  /// Gets a product collection by handle
  Future<Either<Failure, ProductCollection>> getCollectionByHandle(String handle);

  /// Gets products in a collection
  Future<Either<Failure, List<Product>>> getProductsByCollection(String collectionId, {
    int? limit,
    int? offset,
    String? sortBy,
    bool? sortDesc,
  });
} 