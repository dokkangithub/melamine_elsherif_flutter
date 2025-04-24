/// Represents a payment method entity in the domain layer
class PaymentMethod {
  final String id;
  final String providerId;
  final String? cartId;
  final String? customerId;
  final Map<String, dynamic>? data;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Creates a [PaymentMethod] instance
  PaymentMethod({
    required this.id,
    required this.providerId,
    this.cartId,
    this.customerId,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  /// Gets the payment method name from the data
  String get name {
    if (data == null) return providerId;
    
    if (data!.containsKey('card')) {
      final card = data!['card'] as Map<String, dynamic>;
      final brand = card['brand'] ?? '';
      final last4 = card['last4'] ?? '';
      return '$brand •••• $last4';
    }
    
    return data!['type'] ?? providerId;
  }

  /// Gets the payment method icon based on the provider
  String get icon {
    if (providerId.toLowerCase().contains('stripe')) {
      return 'stripe';
    } else if (providerId.toLowerCase().contains('paypal')) {
      return 'paypal';
    } else if (providerId.toLowerCase().contains('apple')) {
      return 'apple';
    } else if (providerId.toLowerCase().contains('google')) {
      return 'google';
    }
    return 'generic';
  }

  /// Checks if this is a card payment method
  bool get isCard {
    return data != null && data!.containsKey('card');
  }
} 