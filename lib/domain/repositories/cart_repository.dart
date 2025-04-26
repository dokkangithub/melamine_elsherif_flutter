import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/entities/shipping_option.dart';

/// Repository interface for cart-related operations
abstract class CartRepository {
  /// Get the current cart or find by ID
  Future<Either<Failure, Cart>> getCart({String? cartId});
  
  /// Creates a new cart
  Future<Either<Failure, Cart>> createCart();
  
  /// Add an item to the cart
  Future<Either<Failure, Cart>> addItem({
    String? cartId,
    required String variantId,
    int quantity = 1,
  });
  
  /// Remove an item from the cart
  Future<Either<Failure, Cart>> removeItem({
    required String cartId,
    required String lineItemId,
  });
  
  /// Update cart (item quantity, apply discount, etc)
  Future<Either<Failure, Cart>> updateCart({
    required String cartId,
    String? lineItemId,
    int? quantity,
    String? discountCode,
    String? regionId,
    String? email,
    String? billingAddressId,
    String? shippingAddressId,
    Map<String, dynamic>? metadata,
  });
  
  /// Complete the checkout process for a cart
  Future<Either<Failure, Cart>> completeCart(String cartId);

  /// Adds a shipping method to a cart
  Future<Either<Failure, Cart>> addShippingMethod(
    String cartId,
    String optionId,
    Map<String, dynamic>? data,
  );

  /// Creates payment sessions for a cart
  Future<Either<Failure, Cart>> createPaymentSessions(String cartId);
  
  /// Sets the payment session for checkout
  Future<Either<Failure, Cart>> setPaymentSession(
    String cartId,
    String providerId,
  );

  /// Updates the payment session data
  Future<Either<Failure, Cart>> updatePaymentSession(
    String cartId,
    String providerId,
    Map<String, dynamic> data,
  );

  /// Retrieves the shipping options for a cart
  Future<Either<Failure, List<ShippingOption>>> getShippingOptions(String cartId);
} 