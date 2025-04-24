import 'package:equatable/equatable.dart';

/// Represents a customer entity in the domain layer
class Customer extends Equatable {
  /// The unique identifier for this customer
  final String id;
  
  /// The email address of the customer
  final String email;
  
  /// The first name of the customer
  final String? firstName;
  
  /// The last name of the customer
  final String? lastName;
  
  /// The billing address ID for this customer
  final String? billingAddressId;
  
  /// The phone number of the customer
  final String? phone;
  
  /// Whether the customer has an account
  final bool hasAccount;
  
  /// Additional metadata for this customer
  final Map<String, dynamic>? metadata;
  
  /// When this customer was created
  final DateTime createdAt;
  
  /// When this customer was last updated
  final DateTime updatedAt;
  
  /// When this customer was deleted, if applicable
  final DateTime? deletedAt;

  /// Creates a [Customer] instance
  const Customer({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.billingAddressId,
    this.phone,
    this.hasAccount = false,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  /// Returns the full name (first name + last name)
  String? get fullName {
    if (firstName == null && lastName == null) return null;
    return [
      if (firstName != null) firstName,
      if (lastName != null) lastName,
    ].join(' ');
  }
  
  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    billingAddressId,
    phone,
    hasAccount,
    metadata,
    createdAt,
    updatedAt,
    deletedAt,
  ];
} 