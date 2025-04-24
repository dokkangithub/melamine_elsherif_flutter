import 'package:melamine_elsherif/domain/entities/product_tag.dart';

/// Model class for product tag data from the API
class ProductTagModel extends ProductTag {
  /// Creates a [ProductTagModel] instance
  ProductTagModel({
    required super.id,
    required super.value,
    super.createdAt,
    super.updatedAt,
  });

  /// Creates a [ProductTagModel] instance from JSON data
  factory ProductTagModel.fromJson(Map<String, dynamic> json) {
    return ProductTagModel(
      id: json['id'],
      value: json['value'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
} 