import 'package:melamine_elsherif/core/network/api_client.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/core/network/api_constants.dart';

class CartApi {
  final ApiClient _apiClient;

  CartApi(this._apiClient);

  /// Get a cart by ID, or create a new one if ID is not provided
  Future<Map<String, dynamic>> getCart({String? cartId}) async {
    try {
      if (cartId != null) {
        final response = await _apiClient.get('${ApiConstants.carts}/$cartId');
        return {'cart': response['cart']};
      } else {
        // Create a new cart if ID is not provided
        return await createCart();
      }
    } catch (e) {
      throw ApiException(message: 'Failed to get cart: ${e.toString()}');
    }
  }

  /// Create a new cart
  Future<Map<String, dynamic>> createCart() async {
    try {
      final response = await _apiClient.post(ApiConstants.carts);
      return {'cart': response['cart']};
    } catch (e) {
      throw ApiException(message: 'Failed to create cart: ${e.toString()}');
    }
  }

  /// Add an item to the cart
  Future<Map<String, dynamic>> addItem({
    String? cartId,
    required String variantId,
    int quantity = 1,
  }) async {
    try {
      String id = cartId ?? '';
      
      // If no cart ID provided, create a new cart
      if (id.isEmpty) {
        final cart = await createCart();
        id = cart['cart']['id'];
      }
      
      final response = await _apiClient.post(
        '${ApiConstants.carts}/$id/line-items',
        data: {
          'variant_id': variantId,
          'quantity': quantity,
        },
      );
      
      return {'cart': response['cart']};
    } catch (e) {
      throw ApiException(message: 'Failed to add item to cart: ${e.toString()}');
    }
  }

  /// Remove an item from the cart
  Future<Map<String, dynamic>> removeItem({
    required String cartId,
    required String lineItemId,
  }) async {
    try {
      final response = await _apiClient.delete(
        '${ApiConstants.carts}/$cartId/line-items/$lineItemId',
      );
      
      return {'cart': response['cart']};
    } catch (e) {
      throw ApiException(message: 'Failed to remove item from cart: ${e.toString()}');
    }
  }

  /// Update the cart (item quantity, apply discount, etc)
  Future<Map<String, dynamic>> updateCart({
    required String cartId,
    String? lineItemId,
    int? quantity,
    String? discountCode,
    String? regionId,
    String? email,
    String? billingAddressId,
    String? shippingAddressId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Update line item quantity
      if (lineItemId != null && quantity != null) {
        final response = await _apiClient.post(
          '${ApiConstants.carts}/$cartId/line-items/$lineItemId',
          data: {
            'quantity': quantity,
          },
        );
        
        return {'cart': response['cart']};
      }
      
      // Apply discount code
      if (discountCode != null) {
        final response = await _apiClient.post(
          '${ApiConstants.carts}/$cartId/discounts',
          data: {
            'code': discountCode,
          },
        );
        
        return {'cart': response['cart']};
      }

      // Update cart info (region, email, addresses, metadata)
      Map<String, dynamic> updateData = {};
      if (regionId != null) updateData['region_id'] = regionId;
      if (email != null) updateData['email'] = email;
      if (billingAddressId != null) updateData['billing_address_id'] = billingAddressId;
      if (shippingAddressId != null) updateData['shipping_address_id'] = shippingAddressId;
      if (metadata != null) updateData['metadata'] = metadata;

      if (updateData.isNotEmpty) {
        final response = await _apiClient.post(
          '${ApiConstants.carts}/$cartId',
          data: updateData,
        );
        
        return {'cart': response['cart']};
      }
      
      // Just get the cart if no specific update
      return await getCart(cartId: cartId);
    } catch (e) {
      throw ApiException(message: 'Failed to update cart: ${e.toString()}');
    }
  }

  /// Complete the checkout process for a cart
  Future<Map<String, dynamic>> completeCart(String cartId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.carts}/$cartId/complete',
      );
      
      return {'cart': response['cart']};
    } catch (e) {
      throw ApiException(message: 'Failed to complete cart: ${e.toString()}');
    }
  }

  /// Add a shipping method to a cart
  Future<Map<String, dynamic>> addShippingMethod({
    required String cartId,
    required String optionId,
    Map<String, dynamic>? data,
  }) async {
    try {
      Map<String, dynamic> requestData = {
        'option_id': optionId,
      };
      
      if (data != null) {
        requestData.addAll(data);
      }
      
      final response = await _apiClient.post(
        '${ApiConstants.carts}/$cartId/shipping-methods',
        data: requestData,
      );
      
      return {'cart': response['cart']};
    } catch (e) {
      throw ApiException(message: 'Failed to add shipping method: ${e.toString()}');
    }
  }

  /// Create payment sessions for a cart
  Future<Map<String, dynamic>> createPaymentSessions(String cartId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.carts}/$cartId/payment-sessions',
      );
      
      return {'cart': response['cart']};
    } catch (e) {
      throw ApiException(message: 'Failed to create payment sessions: ${e.toString()}');
    }
  }

  /// Set a payment session for checkout
  Future<Map<String, dynamic>> setPaymentSession({
    required String cartId,
    required String providerId,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.carts}/$cartId/payment-session',
        data: {
          'provider_id': providerId,
        },
      );
      
      return {'cart': response['cart']};
    } catch (e) {
      throw ApiException(message: 'Failed to set payment session: ${e.toString()}');
    }
  }

  /// Update a payment session
  Future<Map<String, dynamic>> updatePaymentSession({
    required String cartId,
    required String providerId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.carts}/$cartId/payment-sessions/$providerId',
        data: data,
      );
      
      return {'cart': response['cart']};
    } catch (e) {
      throw ApiException(message: 'Failed to update payment session: ${e.toString()}');
    }
  }

  /// Get shipping options for a cart
  Future<Map<String, dynamic>> getShippingOptionsForCart(String cartId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.carts}/$cartId/shipping-options',
      );
      
      return {'shipping_options': response['shipping_options']};
    } catch (e) {
      throw ApiException(message: 'Failed to get shipping options: ${e.toString()}');
    }
  }
} 