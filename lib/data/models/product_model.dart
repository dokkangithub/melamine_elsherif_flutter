import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/data/models/product_variant_model.dart';
import 'package:melamine_elsherif/data/models/product_collection_model.dart';
import 'package:melamine_elsherif/data/models/product_category_model.dart';
import 'package:melamine_elsherif/data/models/product_tag_model.dart';

/// Model class for product data from the API
class ProductModel extends Product {
  /// Creates a [ProductModel] instance
  ProductModel({
    required super.id,
    required super.title,
    super.handle,
    super.description,
    super.images,
    super.thumbnail,
    required super.isGiftCard,
    super.status,
    required super.variants,
    super.categories,
    super.tags,
    super.collection,
    super.createdAt,
    super.updatedAt,
    super.isInWishlist,
  });

  /// Creates a [ProductModel] instance from JSON data
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final List<ProductVariantModel> variants = [];
    if (json['variants'] != null) {
      for (final variant in json['variants']) {
        variants.add(ProductVariantModel.fromJson(variant));
      }
    }

    final List<ProductCategoryModel>? categories = json['categories'] != null
        ? (json['categories'] as List)
            .map((category) => ProductCategoryModel.fromJson(category))
            .toList()
        : null;

    final List<ProductTagModel>? tags = json['tags'] != null
        ? (json['tags'] as List)
            .map((tag) => ProductTagModel.fromJson(tag))
            .toList()
        : null;

    final ProductCollectionModel? collection = json['collection'] != null
        ? ProductCollectionModel.fromJson(json['collection'])
        : null;

    final List<String>? images = json['images'] != null
        ? (json['images'] as List).map((image) => image['url'] as String).toList()
        : null;

    return ProductModel(
      id: json['id'],
      title: json['title'],
      handle: json['handle'],
      description: json['description'],
      images: images,
      thumbnail: json['thumbnail'],
      isGiftCard: json['is_giftcard'] ?? false,
      status: json['status'],
      variants: variants,
      categories: categories,
      tags: tags,
      collection: collection,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      isInWishlist: json['is_in_wishlist'] ?? false,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'handle': handle,
      'description': description,
      'thumbnail': thumbnail,
      'is_giftcard': isGiftCard,
      'status': status,
      'variants': variants.map((variant) => 
          (variant as ProductVariantModel).toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_in_wishlist': isInWishlist,
    };
  }
} 