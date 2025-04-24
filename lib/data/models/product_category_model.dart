import 'package:melamine_elsherif/domain/entities/product_category.dart';

/// Model class for product category data from the API
class ProductCategoryModel extends ProductCategory {
  /// Creates a [ProductCategoryModel] instance
  ProductCategoryModel({
    required super.id,
    required super.name,
    super.handle,
    super.description,
    super.parentCategoryId,
    super.parent,
    super.children,
    required super.isActive,
    super.rank,
    super.createdAt,
    super.updatedAt,
  });

  /// Creates a [ProductCategoryModel] instance from JSON data
  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    final ProductCategoryModel? parent = json['parent_category'] != null
        ? ProductCategoryModel.fromJson(json['parent_category'])
        : null;

    final List<ProductCategoryModel>? children = json['category_children'] != null
        ? (json['category_children'] as List)
            .map((child) => ProductCategoryModel.fromJson(child))
            .toList()
        : null;

    return ProductCategoryModel(
      id: json['id'],
      name: json['name'],
      handle: json['handle'],
      description: json['description'],
      parentCategoryId: json['parent_category_id'],
      parent: parent,
      children: children,
      isActive: json['is_active'] ?? true,
      rank: json['rank'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'handle': handle,
      'description': description,
      'parent_category_id': parentCategoryId,
      'is_active': isActive,
      'rank': rank,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
} 