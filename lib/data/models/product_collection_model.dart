import 'package:melamine_elsherif/domain/entities/product_collection.dart';

/// Model class for product collection data from the API
class ProductCollectionModel extends ProductCollection {
  /// Creates a [ProductCollectionModel] instance
  ProductCollectionModel({
    required super.id,
    required super.title,
    super.handle,
    super.description,
    super.createdAt,
    super.updatedAt,
  });

  /// Creates a [ProductCollectionModel] instance from JSON data
  factory ProductCollectionModel.fromJson(Map<String, dynamic> json) {
    return ProductCollectionModel(
      id: json['id'],
      title: json['title'],
      handle: json['handle'],
      description: json['description'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'handle': handle,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
} 