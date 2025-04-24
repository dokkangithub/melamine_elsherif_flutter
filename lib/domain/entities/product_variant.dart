import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/domain/entities/money_amount.dart';
import 'package:melamine_elsherif/domain/entities/price.dart';

/// Represents a product variant entity in the domain layer
class ProductVariant extends Equatable {
  /// The unique identifier for this variant
  final String id;
  
  /// The ID of the product this variant belongs to
  final String? productId;
  
  /// The title of this variant
  final String title;
  
  /// The SKU (Stock Keeping Unit) for this variant
  final String? sku;
  
  /// The barcode for this variant
  final String? barcode;
  
  /// European Article Number if applicable
  final bool? ean;
  
  /// Universal Product Code if applicable
  final bool? upc;
  
  /// The quantity available in inventory
  final int? inventoryQuantity;
  
  /// Whether inventory is managed for this variant
  final bool manageInventory;
  
  /// Whether backorders are allowed for this variant
  final bool allowBackorder;
  
  /// The weight of this variant
  final int? weight;
  
  /// The length of this variant
  final int? length;
  
  /// The height of this variant
  final int? height;
  
  /// The width of this variant
  final int? width;
  
  /// Harmonized System Code for international shipping
  final String? hsCode;
  
  /// The country of origin for this variant
  final String? originCountry;
  
  /// The Manufacturer ID code
  final String? midCode;
  
  /// The material of this variant
  final String? material;
  
  /// The list of prices for this variant in different regions/currencies
  final List<MoneyAmount> prices;
  
  /// The list of option values for this variant
  final List<String>? options;
  
  /// Additional metadata for this variant
  final Map<String, dynamic>? metadata;
  
  /// When this variant was created
  final DateTime? createdAt;
  
  /// When this variant was last updated
  final DateTime? updatedAt;
  
  /// The current price of this variant
  final Price price;

  /// Creates a [ProductVariant] instance
  const ProductVariant({
    required this.id,
    this.productId,
    required this.title,
    this.sku,
    this.barcode,
    this.ean,
    this.upc,
    this.inventoryQuantity,
    required this.manageInventory,
    required this.allowBackorder,
    this.weight,
    this.length,
    this.height,
    this.width,
    this.hsCode,
    this.originCountry,
    this.midCode,
    this.material,
    required this.prices,
    this.options,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    required this.price,
  });

  /// Checks if the variant is in stock
  bool get inStock {
    if (inventoryQuantity == null) return true;
    return inventoryQuantity! > 0;
  }

  /// Gets the original price
  num get originalPrice {
    if (prices.isEmpty) return 0;
    final price = prices.first;
    return price.compareAtAmount ?? price.amount;
  }

  /// Gets the current price
  num get currentPrice {
    if (prices.isEmpty) return 0;
    return prices.first.amount;
  }

  /// Checks if this variant has a discount
  bool get hasDiscount {
    if (prices.isEmpty) return false;
    return prices.first.compareAtAmount != null;
  }

  /// Gets the discount amount
  num get discountAmount {
    if (!hasDiscount) return 0;
    final price = prices.first;
    return (price.compareAtAmount ?? 0) - price.amount;
  }

  /// Gets the discount percentage
  double get discountPercentage {
    if (!hasDiscount) return 0;
    final price = prices.first;
    if (price.compareAtAmount == null || price.compareAtAmount == 0) return 0;
    return (discountAmount / price.compareAtAmount!) * 100;
  }
  
  @override
  List<Object?> get props => [
    id,
    productId,
    title,
    sku,
    barcode,
    ean,
    upc,
    inventoryQuantity,
    manageInventory,
    allowBackorder,
    weight,
    length,
    height,
    width,
    hsCode,
    originCountry,
    midCode,
    material,
    prices,
    options,
    metadata,
    createdAt,
    updatedAt,
    price,
  ];
} 