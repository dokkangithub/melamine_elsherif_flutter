import 'package:melamine_elsherif/domain/entities/shipping_profile.dart';

/// Model class for shipping profile data from the API
class ShippingProfileModel extends ShippingProfile {
  /// Creates a [ShippingProfileModel] instance
  const ShippingProfileModel({
    required String id,
    required String name,
    required String type,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    Map<String, dynamic>? metadata,
  }) : super(
          id: id,
          name: name,
          type: type,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
          metadata: metadata,
        );

  /// Creates a [ShippingProfileModel] instance from JSON data
  factory ShippingProfileModel.fromJson(Map<String, dynamic> json) {
    return ShippingProfileModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      deletedAt:
          json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      metadata: json['metadata'],
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }
} 