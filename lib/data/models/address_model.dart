import 'package:melamine_elsherif/domain/entities/address.dart';

/// Model class for address data from the API
class AddressModel extends Address {
  /// Creates an [AddressModel] instance
  const AddressModel({
    required String id,
    String? customerId,
    String? firstName,
    String? lastName,
    String? company,
    String? address1,
    String? address2,
    String? city,
    String? countryCode,
    String? province,
    String? postalCode,
    String? phone,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) : super(
          id: id,
          customerId: customerId,
          firstName: firstName,
          lastName: lastName,
          company: company,
          address1: address1,
          address2: address2,
          city: city,
          countryCode: countryCode,
          province: province,
          postalCode: postalCode,
          phone: phone,
          metadata: metadata,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
        );

  /// Creates an [AddressModel] instance from JSON data
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      customerId: json['customer_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      company: json['company'],
      address1: json['address_1'],
      address2: json['address_2'],
      city: json['city'],
      countryCode: json['country_code'],
      province: json['province'],
      postalCode: json['postal_code'],
      phone: json['phone'],
      metadata: json['metadata'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      deletedAt:
          json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'first_name': firstName,
      'last_name': lastName,
      'company': company,
      'address_1': address1,
      'address_2': address2,
      'city': city,
      'country_code': countryCode,
      'province': province,
      'postal_code': postalCode,
      'phone': phone,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
} 