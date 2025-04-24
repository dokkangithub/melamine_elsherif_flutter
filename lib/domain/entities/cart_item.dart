import 'package:melamine_elsherif/domain/entities/product_variant.dart';

/// Represents a cart item entity in the domain layer
class CartItem {
  final String id;
  final String cartId;
  final ProductVariant variant;
  final int quantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Creates a [CartItem] instance
  CartItem({
    required this.id,
    required this.cartId,
    required this.variant,
    required this.quantity,
    this.createdAt,
    this.updatedAt,
  });

  /// Gets the total price of this item
  double get totalPrice {
    if (variant.prices.isEmpty) return 0;
    return (variant.prices.first.amount * quantity).toDouble();
  }

  /// Checks if this item has a discount
  bool get hasDiscount => variant.hasDiscount;

  /// Gets the total savings amount for this item
  double get totalSavings {
    if (!hasDiscount) return 0;
    return (variant.discountAmount * quantity).toDouble();
  }
} 