import 'package:dio/dio.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';

/// API class for interacting with the Medusa Store API
class StoreApi {
  final Dio _dio;
  final String _baseUrl;

  /// Creates a [StoreApi] instance
  StoreApi(this._dio, this._baseUrl);

  /// Handles API exceptions
  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else {
        throw ApiException(
            message: 'Invalid response format: ${response.data}');
      }
    } else {
      final message = response.data is Map
          ? response.data['message'] ?? 'Server error'
          : 'Server error';
      throw ServerException(message: message);
    }
  }

  /// Gets all regions
  Future<Map<String, dynamic>> getRegions() async {
    try {
      final response = await _dio.get('$_baseUrl/regions');
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }

  /// Gets a region by ID
  Future<Map<String, dynamic>> getRegionById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/regions/$id');
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }

  /// Gets all currencies
  Future<Map<String, dynamic>> getCurrencies() async {
    try {
      final response = await _dio.get('$_baseUrl/currencies');
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }

  /// Gets all shipping options
  Future<Map<String, dynamic>> getShippingOptions({
    String? regionId,
    bool? isReturn,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (regionId != null) {
        queryParams['region_id'] = regionId;
      }
      if (isReturn != null) {
        queryParams['is_return'] = isReturn.toString();
      }

      final response = await _dio.get(
        '$_baseUrl/shipping-options',
        queryParameters: queryParams,
      );
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }

  /// Gets a shipping option by ID
  Future<Map<String, dynamic>> getShippingOptionById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/shipping-options/$id');
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }

  /// Gets shipping options for a cart
  Future<Map<String, dynamic>> getShippingOptionsForCart(String cartId) async {
    try {
      final response = await _dio.get('$_baseUrl/carts/$cartId/shipping-options');
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }

  /// Creates a new cart
  Future<Map<String, dynamic>> createCart({
    String? regionId,
    String? countryCode,
    List<Map<String, dynamic>>? items,
    Map<String, dynamic>? context,
    String? salesChannelId,
  }) async {
    try {
      final payload = <String, dynamic>{};
      
      if (regionId != null) {
        payload['region_id'] = regionId;
      }
      
      if (countryCode != null) {
        payload['country_code'] = countryCode;
      }
      
      if (items != null) {
        payload['items'] = items;
      }
      
      if (context != null) {
        payload['context'] = context;
      }
      
      if (salesChannelId != null) {
        payload['sales_channel_id'] = salesChannelId;
      }
      
      final response = await _dio.post(
        '$_baseUrl/carts',
        data: payload,
      );
      
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }
  
  /// Gets a cart by its ID
  Future<Map<String, dynamic>> getCart(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/carts/$id');
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }
  
  /// Updates a cart
  Future<Map<String, dynamic>> updateCart(
    String id, {
    String? regionId,
    String? email,
    String? billingAddressId,
    String? shippingAddressId,
    Map<String, dynamic>? metadata,
    String? customerId,
    String? paymentProvider,
    String? shippingProfileId,
  }) async {
    try {
      final payload = <String, dynamic>{};
      
      if (regionId != null) {
        payload['region_id'] = regionId;
      }
      
      if (email != null) {
        payload['email'] = email;
      }
      
      if (billingAddressId != null) {
        payload['billing_address_id'] = billingAddressId;
      }
      
      if (shippingAddressId != null) {
        payload['shipping_address_id'] = shippingAddressId;
      }
      
      if (metadata != null) {
        payload['metadata'] = metadata;
      }
      
      if (customerId != null) {
        payload['customer_id'] = customerId;
      }
      
      if (paymentProvider != null) {
        payload['payment_provider'] = paymentProvider;
      }
      
      if (shippingProfileId != null) {
        payload['shipping_profile_id'] = shippingProfileId;
      }
      
      final response = await _dio.post(
        '$_baseUrl/carts/$id',
        data: payload,
      );
      
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }
  
  /// Adds a line item to a cart
  Future<Map<String, dynamic>> addLineItem(
    String cartId,
    String variantId,
    int quantity,
  ) async {
    try {
      final payload = <String, dynamic>{
        'variant_id': variantId,
        'quantity': quantity,
      };
      
      final response = await _dio.post(
        '$_baseUrl/carts/$cartId/line-items',
        data: payload,
      );
      
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }
  
  /// Updates a line item in a cart
  Future<Map<String, dynamic>> updateLineItem(
    String cartId,
    String lineItemId,
    int quantity,
  ) async {
    try {
      final payload = <String, dynamic>{
        'quantity': quantity,
      };
      
      final response = await _dio.post(
        '$_baseUrl/carts/$cartId/line-items/$lineItemId',
        data: payload,
      );
      
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }
  
  /// Removes a line item from a cart
  Future<Map<String, dynamic>> removeLineItem(
    String cartId,
    String lineItemId,
  ) async {
    try {
      final response = await _dio.delete(
        '$_baseUrl/carts/$cartId/line-items/$lineItemId',
      );
      
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }
  
  /// Adds a shipping method to a cart
  Future<Map<String, dynamic>> addShippingMethod(
    String cartId,
    String optionId,
    Map<String, dynamic>? data,
  ) async {
    try {
      final payload = <String, dynamic>{
        'option_id': optionId,
      };
      
      if (data != null) {
        payload['data'] = data;
      }
      
      final response = await _dio.post(
        '$_baseUrl/carts/$cartId/shipping-methods',
        data: payload,
      );
      
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }
  
  /// Creates payment sessions for a cart
  Future<Map<String, dynamic>> createPaymentSessions(String cartId) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/carts/$cartId/payment-sessions',
      );
      
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }
  
  /// Sets the payment session for checkout
  Future<Map<String, dynamic>> setPaymentSession(
    String cartId,
    String providerId,
  ) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/carts/$cartId/payment-session',
        data: {
          'provider_id': providerId,
        },
      );
      
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }
  
  /// Updates the payment session data
  Future<Map<String, dynamic>> updatePaymentSession(
    String cartId,
    String providerId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/carts/$cartId/payment-sessions/$providerId',
        data: data,
      );
      
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }
  
  /// Completes a cart and creates an order
  Future<Map<String, dynamic>> completeCart(String cartId) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/carts/$cartId/complete',
      );
      
      return _handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException(message: 'Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.response != null) {
          final message = e.response!.data is Map
              ? e.response!.data['message'] ?? 'Server error'
              : 'Server error';
          throw ServerException(message: message);
        }
      }
      throw ApiException(message: e.toString());
    }
  }
} 