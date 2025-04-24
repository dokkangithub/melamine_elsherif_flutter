import 'package:melamine_elsherif/domain/entities/shipping_method.dart';

/// Model class for shipping method data from the API
class ShippingMethodModel extends ShippingMethod {
  /// Creates a [ShippingMethodModel] instance
  const ShippingMethodModel({
    required String id,
    required String name,
    String? dataId,
    String? carrierId,
    String? regionId,
    String? description,
    required double price,
    Map<String, dynamic>? data,
    Map<String, dynamic>? metadata,
    required bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          name: name,
          dataId: dataId,
          carrierId: carrierId,
          regionId: regionId,
          description: description,
          price: price,
          data: data,
          metadata: metadata,
          isActive: isActive,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Creates a [ShippingMethodModel] instance from JSON data
  factory ShippingMethodModel.fromJson(Map<String, dynamic> json) {
    return ShippingMethodModel(
      id: json['id'],
      name: json['name'],
      dataId: json['data_id'],
      carrierId: json['carrier_id'],
      regionId: json['region_id'],
      description: json['description'],
      price: json['price'] is int
          ? (json['price'] as int).toDouble()
          : (json['price'] is String
              ? double.parse(json['price'])
              : json['price']),
      data: json['data'],
      metadata: json['metadata'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'data_id': dataId,
      'carrier_id': carrierId,
      'region_id': regionId,
      'description': description,
      'price': price,
      'data': data,
      'metadata': metadata,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
} 