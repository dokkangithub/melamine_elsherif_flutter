import 'package:equatable/equatable.dart';

/// Represents an address entity in the domain layer
class Address extends Equatable {
  /// Unique identifier for this address
  final String id;
  
  /// Associated customer ID
  final String customerId;
  
  /// First name of the person at this address
  final String firstName;
  
  /// Last name of the person at this address
  final String lastName;
  
  /// Company name, if applicable
  final String? company;
  
  /// Primary address line
  final String address1;
  
  /// Secondary address line
  final String? address2;
  
  /// City name
  final String city;
  
  /// Country name
  final String country;
  
  /// Province or state
  final String? province;
  
  /// State (alias for province)
  String? get state => province;
  
  /// Postal or zip code
  final String? postalCode;
  
  /// Contact phone number
  final String phone;
  
  /// Type of address (e.g., 'Home', 'Work', 'Shipping', etc.)
  final String? addressType;
  
  /// Additional metadata
  final Map<String, dynamic>? metadata;
  
  /// When this address was created
  final DateTime? createdAt;
  
  /// When this address was last updated
  final DateTime? updatedAt;
  
  /// When this address was deleted, if applicable
  final DateTime? deletedAt;
  
  /// Whether this address is the default address
  final bool isDefault;

  /// Creates an [Address] instance
  const Address({
    required this.id,
    required this.customerId,
    required this.firstName,
    required this.lastName,
    this.company,
    required this.address1,
    this.address2,
    required this.city,
    required this.country,
    this.province,
    this.postalCode,
    required this.phone,
    this.addressType,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDefault = false,
  });

  /// Returns the full name (first name + last name)
  String get fullName => '$firstName $lastName';

  /// Returns the full address as a single formatted string
  String get formattedAddress {
    final buffer = StringBuffer();
    buffer.write(address1);
    if (address2 != null && address2!.isNotEmpty) {
      buffer.write(', $address2');
    }
    buffer.write(', $city');
    if (province != null && province!.isNotEmpty) {
      buffer.write(', $province');
    }
    if (postalCode != null && postalCode!.isNotEmpty) {
      buffer.write(', $postalCode');
    }
    buffer.write(', $country');
    return buffer.toString();
  }
  
  /// Creates a copy of this address with the given fields replaced with the new values
  Address copyWith({
    String? id,
    String? customerId,
    String? firstName,
    String? lastName,
    String? company,
    String? address1,
    String? address2,
    String? city,
    String? country,
    String? province,
    String? postalCode,
    String? phone,
    String? addressType,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      company: company ?? this.company,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      country: country ?? this.country,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      phone: phone ?? this.phone,
      addressType: addressType ?? this.addressType,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDefault: isDefault ?? this.isDefault,
    );
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
    country,
    province,
    postalCode,
    phone,
    addressType,
    metadata,
    createdAt,
    updatedAt,
    deletedAt,
    isDefault,
  ];
} 