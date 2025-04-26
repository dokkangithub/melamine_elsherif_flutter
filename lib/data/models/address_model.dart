import '../../domain/entities/address.dart';

/// Model class for address data from the API
class AddressModel extends Address {
  /// Creates an [AddressModel] instance
  const AddressModel({
    required String id,
    required String customerId,
    required String firstName,
    required String lastName,
    String? company,
    required String address1,
    String? address2,
    required String city,
    String? province,
    String? postalCode,
    required String country,
    required String phone,
    String? addressType,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool isDefault = false,
  }) : super(
          id: id,
          customerId: customerId,
          firstName: firstName,
          lastName: lastName,
          company: company,
          address1: address1,
          address2: address2,
          city: city,
          province: province,
          postalCode: postalCode,
          country: country,
          phone: phone,
          addressType: addressType,
          metadata: metadata,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
          isDefault: isDefault,
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
      province: json['province'],
      postalCode: json['postal_code'],
      country: json['country'],
      phone: json['phone'],
      addressType: json['address_type'],
      metadata: json['metadata'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      isDefault: json['is_default'] ?? false,
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
      'province': province,
      'postal_code': postalCode,
      'country': country,
      'phone': phone,
      'address_type': addressType,
      'metadata': metadata,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'is_default': isDefault,
    };
  }

  factory AddressModel.fromAddress(Address address) {
    return AddressModel(
      id: address.id,
      customerId: address.customerId,
      firstName: address.firstName,
      lastName: address.lastName,
      company: address.company,
      address1: address.address1,
      address2: address.address2,
      city: address.city,
      province: address.province,
      postalCode: address.postalCode,
      country: address.country,
      phone: address.phone,
      addressType: address.addressType,
      metadata: address.metadata,
      createdAt: address.createdAt,
      updatedAt: address.updatedAt,
      deletedAt: address.deletedAt,
      isDefault: address.isDefault,
    );
  }
} 