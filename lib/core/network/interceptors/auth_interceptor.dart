import 'package:dio/dio.dart';
import 'package:melamine_elsherif/core/services/secure_storage_service.dart';

/// Interceptor that adds authentication token to requests
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorageService = SecureStorageService();
  
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token from secure storage
    final token = await _secureStorageService.getToken();
    
    // Add token to request header if available
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    // Continue with the request
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      // Clear token if unauthorized
      await _secureStorageService.deleteToken();
      
      // You could implement token refresh logic here if needed
      // For now, just forward the error
    }
    
    // Continue with the error
    handler.next(err);
  }
} 