import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/domain/entities/price.dart';
import 'package:melamine_elsherif/domain/entities/shipping_profile.dart';

/// Entity representing a shipping option in the Medusa commerce system
class ShippingOption extends Equatable {
  /// Unique identifier for the shipping option
  final String id;
  
  /// Name of the shipping option
  final String name;
  
  /// The region this shipping option is available in
  final String regionId;
  
  /// The profile this shipping option belongs to
  final ShippingProfile? profile;
  
  /// The ID of the shipping profile this option belongs to
  final String profileId;
  
  /// The provider handling the fulfillment of the shipping option
  final String provider;
  
  /// The ID of the provider
  final String providerId;
  
  /// The price of the shipping option
  final Price? price;
  
  /// The price including taxes
  final Price? priceIncludingTax;
  
  /// Indicates if this is a return shipping option
  final bool isReturn;
  
  /// Indicates if this shipping option requires additional data
  final bool requiresShippingData;
  
  /// Admin-set data for the option
  final Map<String, dynamic>? data;
  
  /// When the shipping option was created
  final DateTime createdAt;
  
  /// When the shipping option was last updated
  final DateTime updatedAt;
  
  /// When the shipping option was deleted
  final DateTime? deletedAt;
  
  /// Additional metadata
  final Map<String, dynamic>? metadata;

  /// Constructs a shipping option entity
  const ShippingOption({
    required this.id,
    required this.name,
    required this.regionId,
    this.profile,
    required this.profileId,
    required this.provider,
    required this.providerId,
    this.price,
    this.priceIncludingTax,
    this.isReturn = false,
    this.requiresShippingData = false,
    this.data,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    regionId,
    profileId,
    provider,
    providerId,
    price,
    priceIncludingTax,
    isReturn,
    requiresShippingData,
    data,
    createdAt,
    updatedAt,
    deletedAt,
    metadata,
  ];
} 