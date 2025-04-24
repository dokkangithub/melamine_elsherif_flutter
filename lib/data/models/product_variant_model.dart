import 'package:melamine_elsherif/domain/entities/product_variant.dart';
import 'package:melamine_elsherif/data/models/money_amount_model.dart';
import 'package:melamine_elsherif/domain/entities/price.dart';

/// Model class for product variant data from the API
class ProductVariantModel extends ProductVariant {
  /// Creates a [ProductVariantModel] instance
  ProductVariantModel({
    required super.id,
    super.productId,
    required super.title,
    super.sku,
    super.barcode,
    super.ean,
    super.upc,
    super.inventoryQuantity,
    required super.manageInventory,
    required super.allowBackorder,
    super.weight,
    super.length,
    super.height,
    super.width,
    super.hsCode,
    super.originCountry,
    super.midCode,
    super.material,
    required super.prices,
    super.options,
    super.metadata,
    super.createdAt,
    super.updatedAt,
    required super.price,
  });

  /// Creates a [ProductVariantModel] instance from JSON data
  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    final List<MoneyAmountModel> prices = [];
    if (json['prices'] != null) {
      for (final price in json['prices']) {
        prices.add(MoneyAmountModel.fromJson(price));
      }
    }

    final List<String>? options = json['options'] != null
        ? (json['options'] as List).map((option) => option['value'] as String).toList()
        : null;
    
    // Create a default price from the first price in the list
    final Price defaultPrice = prices.isNotEmpty
        ? Price(
            amount: prices.first.amount.toDouble(),
            currencyCode: prices.first.currencyCode,
          )
        : Price(amount: 0.0, currencyCode: 'USD');

    return ProductVariantModel(
      id: json['id'],
      productId: json['product_id'],
      title: json['title'],
      sku: json['sku'],
      barcode: json['barcode'],
      ean: json['ean'],
      upc: json['upc'],
      inventoryQuantity: json['inventory_quantity'],
      manageInventory: json['manage_inventory'] ?? false,
      allowBackorder: json['allow_backorder'] ?? false,
      weight: json['weight'],
      length: json['length'],
      height: json['height'],
      width: json['width'],
      hsCode: json['hs_code'],
      originCountry: json['origin_country'],
      midCode: json['mid_code'],
      material: json['material'],
      prices: prices,
      options: options,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      price: defaultPrice,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'title': title,
      'sku': sku,
      'barcode': barcode,
      'ean': ean,
      'upc': upc,
      'inventory_quantity': inventoryQuantity,
      'manage_inventory': manageInventory,
      'allow_backorder': allowBackorder,
      'weight': weight,
      'length': length,
      'height': height,
      'width': width,
      'hs_code': hsCode,
      'origin_country': originCountry,
      'mid_code': midCode,
      'material': material,
      'prices': prices.map((price) => 
          (price as MoneyAmountModel).toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
} 