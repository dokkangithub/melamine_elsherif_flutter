import 'package:melamine_elsherif/domain/entities/customer.dart';

/// Model class for customer data from the API
class CustomerModel extends Customer {
  /// Creates a [CustomerModel] instance
  const CustomerModel({
    required String id,
    required String email,
    String? firstName,
    String? lastName,
    String? billingAddressId,
    String? phone,
    bool hasAccount = false,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) : super(
          id: id,
          email: email,
          firstName: firstName,
          lastName: lastName,
          billingAddressId: billingAddressId,
          phone: phone,
          hasAccount: hasAccount,
          metadata: metadata,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
        );

  /// Creates a [CustomerModel] instance from JSON data
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      billingAddressId: json['billing_address_id'],
      phone: json['phone'],
      hasAccount: json['has_account'] ?? false,
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
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'billing_address_id': billingAddressId,
      'phone': phone,
      'has_account': hasAccount,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
} 