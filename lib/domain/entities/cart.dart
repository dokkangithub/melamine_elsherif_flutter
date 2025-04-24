import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/domain/entities/address.dart';
import 'package:melamine_elsherif/domain/entities/customer.dart';
import 'package:melamine_elsherif/domain/entities/discount.dart';
import 'package:melamine_elsherif/domain/entities/line_item.dart';
import 'package:melamine_elsherif/domain/entities/region.dart';
import 'package:melamine_elsherif/domain/entities/shipping_method.dart';

/// Represents a shopping cart entity in the domain layer
class Cart extends Equatable {
  /// The unique identifier for this cart
  final String id;

  /// The email associated with the cart
  final String? email;

  /// The billing address for this cart
  final Address? billingAddress;

  /// The shipping address for this cart
  final Address? shippingAddress;

  /// The items in the cart
  final List<LineItem> items;

  /// The region for this cart
  final Region? region;

  /// The ID of the region for this cart
  final String? regionId;

  /// The discounts applied to the cart
  final List<Discount>? discounts;

  /// The gift cards applied to the cart
  final List<String>? giftCardIds;

  /// The customer for this cart
  final Customer? customer;

  /// The ID of the customer for this cart
  final String? customerId;

  /// The payment provider IDs for this cart
  final List<String>? paymentProviders;

  /// The shipping methods for this cart
  final List<ShippingMethod>? shippingMethods;

  /// The payment method chosen for checkout
  final String? paymentSession;

  /// The available payment sessions for this cart
  final Map<String, dynamic>? paymentSessions;

  /// The cart type (default, swap, etc.)
  final String? type;

  /// The ID of an associated order (if any)
  final String? orderId;

  /// The subtotal for this cart (excluding taxes, shipping, etc.)
  final double? subtotal;

  /// The tax total for this cart
  final double? taxTotal;

  /// The shipping total for this cart
  final double? shippingTotal;

  /// The discount total for this cart
  final double? discountTotal;

  /// The gift card total for this cart
  final double? giftCardTotal;

  /// The total for this cart (subtotal + tax_total + shipping_total - discount_total - gift_card_total)
  final double? total;

  /// Additional custom data for this cart
  final Map<String, dynamic>? metadata;

  /// The ID of the sales channel
  final String? salesChannelId;

  /// The creation date for this cart
  final DateTime createdAt;

  /// The last updated date for this cart
  final DateTime updatedAt;

  /// The date this cart was last completed
  final DateTime? completedAt;

  /// The date this cart was deleted (if applicable)
  final DateTime? deletedAt;

  /// Creates a [Cart] instance
  const Cart({
    required this.id,
    this.email,
    this.billingAddress,
    this.shippingAddress,
    required this.items,
    this.region,
    this.regionId,
    this.discounts,
    this.giftCardIds,
    this.customer,
    this.customerId,
    this.paymentProviders,
    this.shippingMethods,
    this.paymentSession,
    this.paymentSessions,
    this.type,
    this.orderId,
    this.subtotal,
    this.taxTotal,
    this.shippingTotal,
    this.discountTotal,
    this.giftCardTotal,
    this.total,
    this.metadata,
    this.salesChannelId,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
    id, email, billingAddress, shippingAddress, items, region, regionId,
    discounts, giftCardIds, customer, customerId, paymentProviders, shippingMethods,
    paymentSession, paymentSessions, type, orderId, subtotal, taxTotal,
    shippingTotal, discountTotal, giftCardTotal, total, metadata,
    salesChannelId, createdAt, updatedAt, completedAt, deletedAt,
  ];

  /// Gets the total number of items in the cart
  int get totalItems {
    return items.fold(0, (total, item) => total + item.quantity);
  }

  /// Gets the total weight of the cart
  double get totalWeight {
    return items.fold(0.0, (total, item) => total + ((item.variant?.weight ?? 0) * item.quantity));
  }

  /// Checks if the cart is empty
  bool get isEmpty => items.isEmpty;

  /// Checks if shipping information is complete
  bool get isShippingComplete => shippingAddress != null && shippingMethods?.isNotEmpty == true;

  /// Checks if billing information is complete
  bool get isBillingComplete => billingAddress != null && paymentProviders?.isNotEmpty == true;

  /// Checks if the cart is ready for checkout
  bool get isReadyForCheckout => isShippingComplete && isBillingComplete;
} 