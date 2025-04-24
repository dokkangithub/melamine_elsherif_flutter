import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';

/// Repository interface for wishlist operations
abstract class WishlistRepository {
  /// Gets all products in the wishlist
  Future<Either<Failure, List<Product>>> getWishlist();

  /// Adds a product to the wishlist
  Future<Either<Failure, bool>> addToWishlist(String productId);

  /// Removes a product from the wishlist
  Future<Either<Failure, bool>> removeFromWishlist(String productId);

  /// Checks if a product is in the wishlist
  Future<Either<Failure, bool>> isInWishlist(String productId);

  /// Clears all products from the wishlist
  Future<Either<Failure, bool>> clearWishlist();
} 