import 'package:equatable/equatable.dart';

/// Represents an address entity in the domain layer
class Address extends Equatable {
  /// Unique identifier for this address
  final String id;
  
  /// Associated customer ID
  final String? customerId;
  
  /// First name of the person at this address
  final String? firstName;
  
  /// Last name of the person at this address
  final String? lastName;
  
  /// Company name, if applicable
  final String? company;
  
  /// Primary address line
  final String? address1;
  
  /// Secondary address line
  final String? address2;
  
  /// City name
  final String? city;
  
  /// Country code
  final String? countryCode;
  
  /// Province or state
  final String? province;
  
  /// Postal or zip code
  final String? postalCode;
  
  /// Contact phone number
  final String? phone;
  
  /// Additional metadata
  final Map<String, dynamic>? metadata;
  
  /// When this address was created
  final DateTime createdAt;
  
  /// When this address was last updated
  final DateTime updatedAt;
  
  /// When this address was deleted, if applicable
  final DateTime? deletedAt;

  /// Creates an [Address] instance
  const Address({
    required this.id,
    this.customerId,
    this.firstName,
    this.lastName,
    this.company,
    this.address1,
    this.address2,
    this.city,
    this.countryCode,
    this.province,
    this.postalCode,
    this.phone,
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

  /// Returns the full address as a single formatted string
  String? get fullAddress {
    final parts = [
      if (address1 != null) address1,
      if (address2 != null) address2,
      if (city != null) city,
      if (province != null) province,
      if (postalCode != null) postalCode,
      if (countryCode != null) countryCode,
    ];
    return parts.isEmpty ? null : parts.join(', ');
  }
  
  @override
  List<Object?> get props => [
    id,
    customerId,
    firstName,
    lastName,
    company,
    address1,
    address2,
    city,
    countryCode,
    province,
    postalCode,
    phone,
    metadata,
    createdAt,
    updatedAt,
    deletedAt,
  ];
} 