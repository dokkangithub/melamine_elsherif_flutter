import 'package:melamine_elsherif/domain/entities/address.dart';
import 'package:melamine_elsherif/domain/entities/customer.dart';
import 'package:melamine_elsherif/domain/entities/shipping_method.dart';
import 'package:melamine_elsherif/domain/entities/payment_method.dart';
import 'package:melamine_elsherif/domain/entities/cart_item.dart';
import 'package:melamine_elsherif/domain/entities/discount.dart';

/// Represents an order entity in the domain layer
class Order {
  final String id;
  final String status;
  final List<CartItem> items;
  final Customer? customer;
  final Address? shippingAddress;
  final Address? billingAddress;
  final ShippingMethod? shippingMethod;
  final PaymentMethod? paymentMethod;
  final String? fulfillmentStatus;
  final String? paymentStatus;
  final List<Discount>? discounts;
  final String currency;
  final double subtotal;
  final double tax;
  final double shippingTotal;
  final double discountTotal;
  final double total;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Creates an [Order] instance
  Order({
    required this.id,
    required this.status,
    required this.items,
    this.customer,
    this.shippingAddress,
    this.billingAddress,
    this.shippingMethod,
    this.paymentMethod,
    this.fulfillmentStatus,
    this.paymentStatus,
    this.discounts,
    required this.currency,
    required this.subtotal,
    required this.tax,
    required this.shippingTotal,
    required this.discountTotal,
    required this.total,
    this.createdAt,
    this.updatedAt,
  });

  /// Gets the total number of items in the order
  int get totalItems {
    return items.fold(0, (total, item) => total + item.quantity);
  }

  /// Gets the formatted total price
  String formatTotal({String? currencySymbol}) {
    final symbol = currencySymbol ?? _getCurrencySymbol(currency);
    
    if (total == total.toInt()) {
      return '$symbol${total.toInt()}';
    }
    return '$symbol${total.toStringAsFixed(2)}';
  }

  /// Checks if the order is cancelled
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  /// Checks if the order is completed
  bool get isCompleted => status.toLowerCase() == 'completed';

  /// Checks if the order is in progress
  bool get isInProgress => !isCancelled && !isCompleted;

  /// Gets the order status display text
  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  /// Helper method to get currency symbol
  String _getCurrencySymbol(String code) {
    switch (code.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'CNY':
        return '¥';
      case 'KRW':
        return '₩';
      case 'INR':
        return '₹';
      case 'RUB':
        return '₽';
      case 'EGP':
        return 'E£';
      default:
        return code;
    }
  }
} 