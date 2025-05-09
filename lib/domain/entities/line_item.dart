import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/domain/entities/product_variant.dart';
import 'package:melamine_elsherif/domain/entities/price.dart';

/// Represents a line item entity in the domain layer
class LineItem extends Equatable {
  /// The unique identifier for this line item
  final String id;
  
  /// The ID of the cart this line item belongs to
  final String? cartId;
  
  /// The ID of the order this line item belongs to (if any)
  final String? orderId;
  
  /// The title of the item
  final String title;
  
  /// The description of the item
  final String? description;
  
  /// The thumbnail image URL
  final String? thumbnail;
  
  /// Whether the item is a gift card
  final bool isGiftCard;
  
  /// Whether the item should be included in shipping calculations
  final bool? shouldMerge;
  
  /// Whether the item requires shipping
  final bool? allowDiscounts;
  
  /// Whether the item has been generated by a custom process
  final bool? hasShipping;
  
  /// The product variant associated with this line item
  final ProductVariant? variant;
  
  /// The ID of the associated product variant
  final String? variantId;
  
  /// The quantity of this item in the cart
  final int quantity;
  
  /// The unit price of the item
  final Price? unitPrice;
  
  /// The subtotal for this line item (quantity * unit_price)
  final double? subtotal;
  
  /// The tax amount for this line item
  final double? taxTotal;
  
  /// The total for this line item (subtotal + tax_total)
  final double? total;
  
  /// The original total for this line item (before discounts)
  final double? originalTotal;
  
  /// The discount total for this line item
  final double? discountTotal;
  
  /// The gift card total for this line item
  final double? giftCardTotal;
  
  /// The refundable amount for this line item
  final double? refundableAmount;
  
  /// Additional custom data for this line item
  final Map<String, dynamic>? metadata;
  
  /// The creation date for this line item
  final DateTime createdAt;
  
  /// The last updated date for this line item
  final DateTime updatedAt;

  /// Creates a [LineItem] instance
  const LineItem({
    required this.id,
    this.cartId,
    this.orderId,
    required this.title,
    this.description,
    this.thumbnail,
    this.isGiftCard = false,
    this.shouldMerge,
    this.allowDiscounts,
    this.hasShipping,
    this.variant,
    this.variantId,
    required this.quantity,
    this.unitPrice,
    this.subtotal,
    this.taxTotal,
    this.total,
    this.originalTotal,
    this.discountTotal,
    this.giftCardTotal,
    this.refundableAmount,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });
  
  @override
  List<Object?> get props => [
    id, cartId, orderId, title, description, thumbnail, isGiftCard,
    shouldMerge, allowDiscounts, hasShipping, variant, variantId,
    quantity, unitPrice, subtotal, taxTotal, total, originalTotal, 
    discountTotal, giftCardTotal, refundableAmount, metadata, 
    createdAt, updatedAt,
  ];
} 