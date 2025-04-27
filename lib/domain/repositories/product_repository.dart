import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/domain/entities/product_category.dart';
import 'package:melamine_elsherif/domain/entities/product_collection.dart';
import 'package:melamine_elsherif/domain/entities/product_tag.dart';

/// Repository interface for product operations
abstract class ProductRepository {
  /// Gets products with pagination
  Future<Either<Failure, List<Product>>> getProducts({
    int? offset,
    int? limit,
    String? search,
    List<String>? categoryIds,
    List<String>? collectionIds,
    List<String>? tagIds,
    String? sortBy,
    bool? sortDesc,
  });

  /// Gets a product by ID
  Future<Either<Failure, Product>> getProductById(String id);

  /// Gets a product by handle (slug)
  Future<Either<Failure, Product>> getProductByHandle(String handle);

  /// Gets related products for a product
  Future<Either<Failure, List<Product>>> getRelatedProducts(String productId);

  /// Gets featured products
  Future<Either<Failure, List<Product>>> getFeaturedProducts();

  /// Gets new arrival products
  Future<Either<Failure, List<Product>>> getNewArrivals();

  /// Gets popular products
  Future<Either<Failure, List<Product>>> getPopularProducts();

  /// Gets all product categories
  Future<Either<Failure, List<ProductCategory>>> getCategories();

  /// Gets a category by ID
  Future<Either<Failure, ProductCategory>> getCategoryById(String id);

  /// Gets products in a category
  Future<Either<Failure, List<Product>>> getProductsByCategory(String categoryId);

  /// Gets all product collections
  Future<Either<Failure, List<ProductCollection>>> getCollections();

  /// Gets a collection by ID
  Future<Either<Failure, ProductCollection>> getCollectionById(String id);

  /// Gets products in a collection
  Future<Either<Failure, List<Product>>> getProductsByCollection(String collectionId);

  /// Gets all product tags
  Future<Either<Failure, List<ProductTag>>> getTags();

  /// Gets products by tag
  Future<Either<Failure, List<Product>>> getProductsByTag(String tagId);

  /// Searches for products
  Future<Either<Failure, List<Product>>> searchProducts(String query);

  /// Get bestseller products
  Future<Either<Failure, List<Product>>> getBestsellers();

  /// Get today's best deals
  Future<Either<Failure, List<Product>>> getTodaysBestDeals();
} 