import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/entities/line_item.dart';
import 'package:melamine_elsherif/domain/entities/shipping_option.dart';

/// Repository interface for cart-related operations
abstract class CartRepository {
  /// Creates a new cart
  Future<Either<Failure, Cart>> createCart();

  /// Gets an existing cart by ID
  Future<Either<Failure, Cart>> getCart(String id);

  /// Updates a cart
  Future<Either<Failure, Cart>> updateCart(String id, {
    String? regionId,
    String? email,
    String? billingAddressId,
    String? shippingAddressId,
    Map<String, dynamic>? metadata,
  });

  /// Adds a line item to a cart
  Future<Either<Failure, Cart>> addLineItem(
    String cartId, 
    String variantId, 
    int quantity,
  );

  /// Updates a line item in a cart
  Future<Either<Failure, Cart>> updateLineItem(
    String cartId,
    String lineItemId,
    int quantity,
  );

  /// Removes a line item from a cart
  Future<Either<Failure, Cart>> removeLineItem(
    String cartId,
    String lineItemId,
  );

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

  /// Completes a cart and converts it to an order
  Future<Either<Failure, Map<String, dynamic>>> completeCart(String cartId);
  
  /// Retrieves the shipping options for a cart
  Future<Either<Failure, List<ShippingOption>>> getShippingOptions(String cartId);
} 