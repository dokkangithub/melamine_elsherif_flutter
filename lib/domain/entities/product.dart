import 'package:melamine_elsherif/domain/entities/product_variant.dart';
import 'package:melamine_elsherif/domain/entities/product_collection.dart';
import 'package:melamine_elsherif/domain/entities/product_category.dart';
import 'package:melamine_elsherif/domain/entities/product_tag.dart';

/// Represents a product entity in the domain layer
class Product {
  final String id;
  final String title;
  final String? handle;
  final String? description;
  final List<String>? images;
  final String? thumbnail;
  final bool isGiftCard;
  final String? status;
  final List<ProductVariant> variants;
  final List<ProductCategory>? categories;
  final List<ProductTag>? tags;
  final ProductCollection? collection;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isInWishlist;

  Product({
    required this.id,
    required this.title,
    this.handle,
    this.description,
    this.images,
    this.thumbnail,
    required this.isGiftCard,
    this.status,
    required this.variants,
    this.categories,
    this.tags,
    this.collection,
    this.createdAt,
    this.updatedAt,
    this.isInWishlist = false,
  });

  /// Returns the lowest price from all variants
  num get lowestPrice {
    if (variants.isEmpty) return 0;
    return variants
        .map((variant) => variant.prices.isNotEmpty ? variant.prices.first.amount : 0)
        .reduce((curr, next) => curr < next ? curr : next);
  }

  /// Returns the highest price from all variants
  num get highestPrice {
    if (variants.isEmpty) return 0;
    return variants
        .map((variant) => variant.prices.isNotEmpty ? variant.prices.first.amount : 0)
        .reduce((curr, next) => curr > next ? curr : next);
  }

  /// Checks if the product has a discount
  bool get hasDiscount {
    return variants.any((variant) => 
        variant.prices.any((price) => price.compareAtAmount != null));
  }

  /// Returns the discount percentage
  double get discountPercentage {
    if (!hasDiscount) return 0;
    
    final variantWithDiscount = variants.firstWhere(
      (variant) => variant.prices.any((price) => price.compareAtAmount != null),
      orElse: () => variants.first,
    );
    
    final price = variantWithDiscount.prices.firstWhere(
      (price) => price.compareAtAmount != null,
      orElse: () => variantWithDiscount.prices.first,
    );
    
    if (price.compareAtAmount == null || price.amount == 0) return 0;
    
    return ((price.compareAtAmount! - price.amount) / price.compareAtAmount!) * 100;
  }
} 