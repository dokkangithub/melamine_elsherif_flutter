import 'package:equatable/equatable.dart';

/// Represents a shipping method entity in the domain layer
class ShippingMethod extends Equatable {
  /// The unique identifier for this shipping method
  final String id;
  
  /// The name of this shipping method
  final String name;
  
  /// The data ID for this shipping method
  final String? dataId;
  
  /// The carrier ID for this shipping method
  final String? carrierId;
  
  /// The region ID this shipping method applies to
  final String? regionId;
  
  /// The description of this shipping method
  final String? description;
  
  /// The price of this shipping method
  final double price;
  
  /// Additional data for this shipping method
  final Map<String, dynamic>? data;
  
  /// Additional metadata for this shipping method
  final Map<String, dynamic>? metadata;
  
  /// Whether this shipping method is active
  final bool isActive;
  
  /// When this shipping method was created
  final DateTime? createdAt;
  
  /// When this shipping method was last updated
  final DateTime? updatedAt;

  /// Creates a [ShippingMethod] instance
  const ShippingMethod({
    required this.id,
    required this.name,
    this.dataId,
    this.carrierId,
    this.regionId,
    this.description,
    required this.price,
    this.data,
    this.metadata,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  /// Formats the price with a currency symbol
  String formatPrice({String currencySymbol = '\$'}) {
    if (price == price.toInt()) {
      return '$currencySymbol${price.toInt()}';
    }
    return '$currencySymbol${price.toStringAsFixed(2)}';
  }

  /// Returns a short description of the shipping method
  String get shortDescription {
    if (description != null && description!.isNotEmpty) {
      return description!;
    }
    return name;
  }
  
  @override
  List<Object?> get props => [
    id,
    name,
    dataId,
    carrierId,
    regionId,
    description,
    price,
    data,
    metadata,
    isActive,
    createdAt,
    updatedAt,
  ];
} 