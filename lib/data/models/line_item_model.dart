import 'package:melamine_elsherif/data/models/price_model.dart';
import 'package:melamine_elsherif/data/models/product_variant_model.dart';
import 'package:melamine_elsherif/domain/entities/line_item.dart';

/// Model class for line item data from the API
class LineItemModel extends LineItem {
  /// Creates a [LineItemModel] instance
  const LineItemModel({
    required String id,
    String? cartId,
    String? orderId,
    required String title,
    String? description,
    String? thumbnail,
    bool isGiftCard = false,
    bool? shouldMerge,
    bool? allowDiscounts,
    bool? hasShipping,
    ProductVariantModel? variant,
    String? variantId,
    required int quantity,
    PriceModel? unitPrice,
    double? subtotal,
    double? taxTotal,
    double? total,
    double? originalTotal,
    double? discountTotal,
    double? giftCardTotal,
    double? refundableAmount,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          cartId: cartId,
          orderId: orderId,
          title: title,
          description: description,
          thumbnail: thumbnail,
          isGiftCard: isGiftCard,
          shouldMerge: shouldMerge,
          allowDiscounts: allowDiscounts,
          hasShipping: hasShipping,
          variant: variant,
          variantId: variantId,
          quantity: quantity,
          unitPrice: unitPrice,
          subtotal: subtotal,
          taxTotal: taxTotal,
          total: total,
          originalTotal: originalTotal,
          discountTotal: discountTotal,
          giftCardTotal: giftCardTotal,
          refundableAmount: refundableAmount,
          metadata: metadata,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Creates a [LineItemModel] instance from JSON data
  factory LineItemModel.fromJson(Map<String, dynamic> json) {
    return LineItemModel(
      id: json['id'],
      cartId: json['cart_id'],
      orderId: json['order_id'],
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      isGiftCard: json['is_giftcard'] ?? false,
      shouldMerge: json['should_merge'],
      allowDiscounts: json['allow_discounts'],
      hasShipping: json['has_shipping'],
      variant: json['variant'] != null
          ? ProductVariantModel.fromJson(json['variant'])
          : null,
      variantId: json['variant_id'],
      quantity: json['quantity'] ?? 1,
      unitPrice: json['unit_price'] != null
          ? PriceModel.fromJson({
              'amount': json['unit_price'],
              'currency_code': json['currency_code'] ?? '',
            })
          : null,
      subtotal: _parseDouble(json['subtotal']),
      taxTotal: _parseDouble(json['tax_total']),
      total: _parseDouble(json['total']),
      originalTotal: _parseDouble(json['original_total']),
      discountTotal: _parseDouble(json['discount_total']),
      giftCardTotal: _parseDouble(json['gift_card_total']),
      refundableAmount: _parseDouble(json['refundable_amount']),
      metadata: json['metadata'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'order_id': orderId,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'is_giftcard': isGiftCard,
      'should_merge': shouldMerge,
      'allow_discounts': allowDiscounts,
      'has_shipping': hasShipping,
      'variant_id': variantId,
      'variant': variant != null ? (variant as ProductVariantModel).toJson() : null,
      'quantity': quantity,
      'unit_price': unitPrice != null ? (unitPrice as PriceModel).amount : null,
      'subtotal': subtotal,
      'tax_total': taxTotal,
      'total': total,
      'original_total': originalTotal,
      'discount_total': discountTotal,
      'gift_card_total': giftCardTotal,
      'refundable_amount': refundableAmount,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Helper method to parse double values from JSON
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value);
    return null;
  }
} 