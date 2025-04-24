import 'package:equatable/equatable.dart';

/// Represents a region entity in the domain layer
class Region extends Equatable {
  /// The unique identifier for this region
  final String id;
  
  /// The name of this region
  final String name;
  
  /// The currency code for this region
  final String currencyCode;
  
  /// The tax rate for this region
  final double? taxRate;
  
  /// The tax code for this region
  final String? taxCode;
  
  /// The payment provider IDs for this region
  final List<String>? paymentProviderIds;
  
  /// The fulfillment provider IDs for this region
  final List<String>? fulfillmentProviderIds;
  
  /// The countries in this region
  final List<dynamic>? countries;
  
  /// Additional custom data for this region
  final Map<String, dynamic>? metadata;
  
  /// The creation date for this region
  final DateTime createdAt;
  
  /// The last updated date for this region
  final DateTime updatedAt;
  
  /// The date this region was deleted (if applicable)
  final DateTime? deletedAt;

  /// Creates a [Region] instance
  const Region({
    required this.id,
    required this.name,
    required this.currencyCode,
    this.taxRate,
    this.taxCode,
    this.paymentProviderIds,
    this.fulfillmentProviderIds,
    this.countries,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  
  @override
  List<Object?> get props => [
    id, name, currencyCode, taxRate, taxCode, paymentProviderIds,
    fulfillmentProviderIds, countries, metadata, createdAt, updatedAt,
    deletedAt,
  ];
}