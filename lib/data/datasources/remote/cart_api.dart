import 'package:dio/dio.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/core/network/api_constants.dart';

class CartApi {
  final Dio _dio;

  CartApi(this._dio);

  /// Get a cart by ID, or create a new one if ID is not provided
  Future<Map<String, dynamic>> getCart({String? cartId}) async {
    try {
      if (cartId != null) {
        final response = await _dio.get('${ApiConstants.carts}/$cartId');
        return {'cart': response.data['cart']};
      } else {
        // Create a new cart if ID is not provided
        return await createCart();
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final data = e.response!.data;
        if (data is Map) {
          final message = data['message']?.toString() ?? 'Failed to get cart';
          final code = data['code']?.toString();
          
          // Handle specific cart error codes
          switch (code) {
            case 'cart_not_found':
              throw CartException(
                message: 'Cart not found',
                code: code,
                statusCode: e.response?.statusCode,
              );
            case 'invalid_cart':
              throw CartException(
                message: 'Invalid cart',
                code: code,
                statusCode: e.response?.statusCode,
              );
            default:
              throw CartException(
                message: message,
                code: code,
                statusCode: e.response?.statusCode,
              );
          }
        }
      }
      throw CartException(message: 'Failed to get cart: ${e.toString()}');
    }
  }

  /// Create a new cart
  Future<Map<String, dynamic>> createCart() async {
    try {
      final response = await _dio.post(ApiConstants.carts);
      return {'cart': response.data['cart']};
    } catch (e) {
      if (e is DioException && e.response != null) {
        final data = e.response!.data;
        if (data is Map) {
          final message = data['message']?.toString() ?? 'Failed to create cart';
          final code = data['code']?.toString();
          
          throw CartException(
            message: message,
            code: code,
            statusCode: e.response?.statusCode,
          );
        }
      }
      throw CartException(message: 'Failed to create cart: ${e.toString()}');
    }
  }

  /// Add an item to the cart
  Future<Map<String, dynamic>> addItem({
    String? cartId,
    required String variantId,
    int quantity = 1,
  }) async {
    try {
      // Validate quantity
      if (quantity < 1) {
        throw CartException(message: 'Quantity must be at least 1');
      }

      String id = cartId ?? '';
      
      // If no cart ID provided, create a new cart
      if (id.isEmpty) {
        final cart = await createCart();
        id = cart['cart']['id'];
      }
      
      final response = await _dio.post(
        '${ApiConstants.carts}/$id/line-items',
        data: {
          'variant_id': variantId,
          'quantity': quantity,
        },
      );
      
      return {'cart': response.data['cart']};
    } catch (e) {
      if (e is DioException && e.response != null) {
        final data = e.response!.data;
        if (data is Map) {
          final message = data['message']?.toString() ?? 'Failed to add item to cart';
          final code = data['code']?.toString();
          
          // Handle specific cart error codes
          switch (code) {
            case 'invalid_variant':
              throw CartException(
                message: 'Invalid product variant',
                code: code,
                statusCode: e.response?.statusCode,
              );
            case 'insufficient_inventory':
              throw CartException(
                message: 'Insufficient inventory',
                code: code,
                statusCode: e.response?.statusCode,
              );
            default:
              throw CartException(
                message: message,
                code: code,
                statusCode: e.response?.statusCode,
              );
          }
        }
      }
      throw CartException(message: 'Failed to add item to cart: ${e.toString()}');
    }
  }

  /// Remove an item from the cart
  Future<Map<String, dynamic>> removeItem({
    required String cartId,
    required String lineItemId,
  }) async {
    try {
      final response = await _dio.delete(
        '${ApiConstants.carts}/$cartId/line-items/$lineItemId',
      );
      
      return {'cart': response.data['cart']};
    } catch (e) {
      if (e is DioException && e.response != null) {
        final data = e.response!.data;
        if (data is Map) {
          final message = data['message']?.toString() ?? 'Failed to remove item from cart';
          final code = data['code']?.toString();
          
          throw CartException(
            message: message,
            code: code,
            statusCode: e.response?.statusCode,
          );
        }
      }
      throw CartException(message: 'Failed to remove item from cart: ${e.toString()}');
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
      // Validate quantity if provided
      if (quantity != null && quantity < 1) {
        throw CartException(message: 'Quantity must be at least 1');
      }

      // Update line item quantity
      if (lineItemId != null && quantity != null) {
        final response = await _dio.post(
          '${ApiConstants.carts}/$cartId/line-items/$lineItemId',
          data: {
            'quantity': quantity,
          },
        );
        
        return {'cart': response.data['cart']};
      }
      
      // Apply discount code
      if (discountCode != null) {
        final response = await _dio.post(
          '${ApiConstants.carts}/$cartId/discounts',
          data: {
            'code': discountCode,
          },
        );
        
        return {'cart': response.data['cart']};
      }

      // Update cart info (region, email, addresses, metadata)
      Map<String, dynamic> updateData = {};
      if (regionId != null) updateData['region_id'] = regionId;
      if (email != null) updateData['email'] = email;
      if (billingAddressId != null) updateData['billing_address_id'] = billingAddressId;
      if (shippingAddressId != null) updateData['shipping_address_id'] = shippingAddressId;
      if (metadata != null) updateData['metadata'] = metadata;

      if (updateData.isNotEmpty) {
        final response = await _dio.post(
          '${ApiConstants.carts}/$cartId',
          data: updateData,
        );
        
        return {'cart': response.data['cart']};
      }
      
      // Just get the cart if no specific update
      return await getCart(cartId: cartId);
    } catch (e) {
      if (e is DioException && e.response != null) {
        final data = e.response!.data;
        if (data is Map) {
          final message = data['message']?.toString() ?? 'Failed to update cart';
          final code = data['code']?.toString();
          
          // Handle specific cart error codes
          switch (code) {
            case 'invalid_discount':
              throw CartException(
                message: 'Invalid discount code',
                code: code,
                statusCode: e.response?.statusCode,
              );
            case 'invalid_region':
              throw CartException(
                message: 'Invalid region',
                code: code,
                statusCode: e.response?.statusCode,
              );
            default:
              throw CartException(
                message: message,
                code: code,
                statusCode: e.response?.statusCode,
              );
          }
        }
      }
      throw CartException(message: 'Failed to update cart: ${e.toString()}');
    }
  }

  /// Complete the checkout process for a cart
  Future<Map<String, dynamic>> completeCart(String cartId) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.carts}/$cartId/complete',
      );
      
      return {'cart': response.data['cart']};
    } catch (e) {
      if (e is DioException && e.response != null) {
        final data = e.response!.data;
        if (data is Map) {
          final message = data['message']?.toString() ?? 'Failed to complete cart';
          final code = data['code']?.toString();
          
          // Handle specific cart error codes
          switch (code) {
            case 'missing_email':
              throw CartException(
                message: 'Email is required to complete checkout',
                code: code,
                statusCode: e.response?.statusCode,
              );
            case 'missing_shipping':
              throw CartException(
                message: 'Shipping method is required',
                code: code,
                statusCode: e.response?.statusCode,
              );
            case 'missing_payment':
              throw CartException(
                message: 'Payment method is required',
                code: code,
                statusCode: e.response?.statusCode,
              );
            default:
              throw CartException(
                message: message,
                code: code,
                statusCode: e.response?.statusCode,
              );
          }
        }
      }
      throw CartException(message: 'Failed to complete cart: ${e.toString()}');
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
      
      final response = await _dio.post(
        '${ApiConstants.carts}/$cartId/shipping-methods',
        data: requestData,
      );
      
      return {'cart': response.data['cart']};
    } catch (e) {
      if (e is DioException && e.response != null) {
        final data = e.response!.data;
        if (data is Map) {
          final message = data['message']?.toString() ?? 'Failed to add shipping method';
          final code = data['code']?.toString();
          
          throw CartException(
            message: message,
            code: code,
            statusCode: e.response?.statusCode,
          );
        }
      }
      throw CartException(message: 'Failed to add shipping method: ${e.toString()}');
    }
  }

  /// Create payment sessions for a cart
  Future<Map<String, dynamic>> createPaymentSessions(String cartId) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.carts}/$cartId/payment-sessions',
      );
      
      return {'cart': response.data['cart']};
    } catch (e) {
      if (e is DioException && e.response != null) {
        final data = e.response!.data;
        if (data is Map) {
          final message = data['message']?.toString() ?? 'Failed to create payment sessions';
          final code = data['code']?.toString();
          
          throw CartException(
            message: message,
            code: code,
            statusCode: e.response?.statusCode,
          );
        }
      }
      throw CartException(message: 'Failed to create payment sessions: ${e.toString()}');
    }
  }

  /// Set a payment session for checkout
  Future<Map<String, dynamic>> setPaymentSession({
    required String cartId,
    required String providerId,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.carts}/$cartId/payment-session',
        data: {
          'provider_id': providerId,
        },
      );
      
      return {'cart': response.data['cart']};
    } catch (e) {
      if (e is DioException && e.response != null) {
        final data = e.response!.data;
        if (data is Map) {
          final message = data['message']?.toString() ?? 'Failed to set payment session';
          final code = data['code']?.toString();
          
          throw CartException(
            message: message,
            code: code,
            statusCode: e.response?.statusCode,
          );
        }
      }
      throw CartException(message: 'Failed to set payment session: ${e.toString()}');
    }
  }

  /// Update a payment session
  Future<Map<String, dynamic>> updatePaymentSession({
    required String cartId,
    required String providerId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.carts}/$cartId/payment-sessions/$providerId',
        data: data,
      );
      
      return {'cart': response.data['cart']};
    } catch (e) {
      if (e is DioException && e.response != null) {
        final data = e.response!.data;
        if (data is Map) {
          final message = data['message']?.toString() ?? 'Failed to update payment session';
          final code = data['code']?.toString();
          
          throw CartException(
            message: message,
            code: code,
            statusCode: e.response?.statusCode,
          );
        }
      }
      throw CartException(message: 'Failed to update payment session: ${e.toString()}');
    }
  }

  /// Get shipping options for a cart
  Future<Map<String, dynamic>> getShippingOptionsForCart(String cartId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.carts}/$cartId/shipping-options',
      );
      
      return {'shipping_options': response.data['shipping_options']};
    } catch (e) {
      if (e is DioException && e.response != null) {
        final data = e.response!.data;
        if (data is Map) {
          final message = data['message']?.toString() ?? 'Failed to get shipping options';
          final code = data['code']?.toString();
          
          throw CartException(
            message: message,
            code: code,
            statusCode: e.response?.statusCode,
          );
        }
      }
      throw CartException(message: 'Failed to get shipping options: ${e.toString()}');
    }
  }
} 