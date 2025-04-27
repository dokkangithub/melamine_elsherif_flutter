import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:melamine_elsherif/core/config/app_config.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/core/network/api_constants.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'dart:async';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final Talker _talker;
  final _authErrorController = StreamController<String>.broadcast();
  bool _isSessionAuth = false;
  
  Stream<String> get authErrorStream => _authErrorController.stream;
  
  ApiClient({
    required Dio dio,
    required FlutterSecureStorage secureStorage,
    required Talker talker,
  }) : 
    _dio = dio,
    _secureStorage = secureStorage,
    _talker = talker {
    _init();
  }
  
  void _init() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: ApiConstants.connectTimeout);
    _dio.options.receiveTimeout = const Duration(milliseconds: ApiConstants.receiveTimeout);
    _dio.options.contentType = 'application/json';
    
    // Add default headers
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-publishable-api-key': ApiConstants.publishableApiKey,
    };
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          if (_isSessionAuth) {
            // For session auth, we rely on cookies
            final sessionId = await _secureStorage.read(key: 'session_id');
            if (sessionId != null) {
              options.headers['Cookie'] = sessionId;
            }
          } else {
            // For JWT auth
            final token = await _secureStorage.read(key: 'auth_token');
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          
          // Log request in dev mode
          if (AppConfig.isDebugMode) {
            _talker.debug('Request: ${options.method} ${options.uri}');
            _talker.debug('Headers: ${options.headers}');
            _talker.debug('Data: ${options.data}');
          }
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Handle session cookie if present
          if (response.headers['set-cookie'] != null) {
            final cookies = response.headers['set-cookie']!;
            for (final cookie in cookies) {
              if (cookie.startsWith('connect.sid=')) {
                _secureStorage.write(key: 'session_id', value: cookie);
                _isSessionAuth = true;
                break;
              }
            }
          }
          
          // Log response in dev mode
          if (AppConfig.isDebugMode) {
            _talker.debug('Response: [${response.statusCode}] ${response.requestOptions.uri}');
            _talker.debug('Response Data: ${response.data}');
          }
          
          return handler.next(response);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          if (e.response?.statusCode == 401) {
            // Clear tokens and user data
            await _clearAuthTokens();
            
            // Notify listeners about authentication error
            _authErrorController.add('Authentication failed. Please login again.');
            
            // Reject the error to prevent further processing
            return handler.reject(e);
          }
          return handler.next(e);
        },
      ),
    );
  }
  
  /// Initialize without an existing token - useful for fixing auth issues
  Future<void> clearTokenOnStartup() async {
    try {
      await _secureStorage.delete(key: 'auth_token');
      await _secureStorage.delete(key: 'session_id');
      _isSessionAuth = false;
    } catch (e) {
      // Just log, don't throw - we want this to be non-disruptive
      _talker.error('Failed to clear auth tokens', e);
    }
  }
  
  /// Register a new customer
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          if (phone != null) 'phone': phone,
        },
      );
      
      return response.data;
    } catch (e) {
      if (e is DioException && e.response != null) {
        String errorMessage = 'Failed to register';
        
        if (e.response!.data is Map) {
          final errorData = e.response!.data as Map;
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'].toString();
          }
        }
        
        throw ApiException(
          message: errorMessage,
          statusCode: e.response?.statusCode
        );
      }
      
      rethrow;
    }
  }
  
  /// Login customer with email and password
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      
      // Store the JWT token or session cookie
      if (response.data['token'] != null) {
        await _secureStorage.write(key: 'auth_token', value: response.data['token']);
        _isSessionAuth = false;
      } else if (response.headers['set-cookie'] != null) {
        final cookies = response.headers['set-cookie']!;
        for (final cookie in cookies) {
          if (cookie.startsWith('connect.sid=')) {
            await _secureStorage.write(key: 'session_id', value: cookie);
            _isSessionAuth = true;
            break;
          }
        }
      }
      
      return response.data;
    } catch (e) {
      if (e is DioException && e.response != null) {
        String errorMessage = 'Failed to login';
        
        if (e.response!.data is Map) {
          final errorData = e.response!.data as Map;
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'].toString();
          }
        }
        
        throw ApiException(
          message: errorMessage,
          statusCode: e.response?.statusCode
        );
      }
      
      rethrow;
    }
  }
  
  /// Get current customer profile
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get(
        ApiConstants.me,
      );
      
      return response.data;
    } catch (e) {
      if (e is DioException && e.response != null) {
        String errorMessage = 'Failed to get user profile';
        
        if (e.response!.data is Map) {
          final errorData = e.response!.data as Map;
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'].toString();
          }
        }
        
        // If we get an auth error, clear the tokens
        if (e.response?.statusCode == 401) {
          await _clearAuthTokens();
          throw AuthException(message: 'Authentication failed. Please login again.');
        }
        
        throw ApiException(
          message: errorMessage,
          statusCode: e.response?.statusCode
        );
      }
      
      rethrow;
    }
  }
  
  /// Update customer profile
  Future<Map<String, dynamic>> updateProfile({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.me,
        data: {
          if (email != null) 'email': email,
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          if (phone != null) 'phone': phone,
          if (password != null) 'password': password,
        },
      );
      
      return response.data;
    } catch (e) {
      if (e is DioException && e.response != null) {
        String errorMessage = 'Failed to update profile';
        
        if (e.response!.data is Map) {
          final errorData = e.response!.data as Map;
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'].toString();
          }
        }
        
        throw ApiException(
          message: errorMessage,
          statusCode: e.response?.statusCode
        );
      }
      
      rethrow;
    }
  }
  
  /// Request password reset token
  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      final response = await _dio.post(
        ApiConstants.requestPasswordReset,
        data: {
          'email': email,
        },
      );
      
      return response.data;
    } catch (e) {
      if (e is DioException && e.response != null) {
        String errorMessage = 'Failed to request password reset';
        
        if (e.response!.data is Map) {
          final errorData = e.response!.data as Map;
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'].toString();
          }
        }
        
        throw ApiException(
          message: errorMessage,
          statusCode: e.response?.statusCode
        );
      }
      
      rethrow;
    }
  }
  
  /// Reset password with token
  Future<Map<String, dynamic>> resetPassword(String token, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.resetPassword,
        data: {
          'token': token,
          'password': password,
        },
      );
      
      return response.data;
    } catch (e) {
      if (e is DioException && e.response != null) {
        String errorMessage = 'Failed to reset password';
        
        if (e.response!.data is Map) {
          final errorData = e.response!.data as Map;
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'].toString();
          }
        }
        
        throw ApiException(
          message: errorMessage,
          statusCode: e.response?.statusCode
        );
      }
      
      rethrow;
    }
  }
  
  /// Logout customer
  Future<void> logout() async {
    try {
      if (_isSessionAuth) {
        // For session-based auth, invalidate the session
        await _dio.delete('${ApiConstants.auth}/session');
      }
      
      // Clear all auth tokens
      await _clearAuthTokens();
    } catch (e) {
      // Ensure tokens are deleted even if an error occurs
      await _clearAuthTokens();
      
      if (e is DioException && e.response != null) {
        String errorMessage = 'Failed to logout';
        
        if (e.response!.data is Map) {
          final errorData = e.response!.data as Map;
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'].toString();
          }
        }
        
        throw ApiException(
          message: errorMessage,
          statusCode: e.response?.statusCode
        );
      }
      
      rethrow;
    }
  }
  
  /// Get the stored auth token
  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }
  
  /// Clear all auth tokens
  Future<void> _clearAuthTokens() async {
    try {
      await _secureStorage.delete(key: 'auth_token');
      await _secureStorage.delete(key: 'session_id');
      _isSessionAuth = false;
    } catch (e) {
      // Just log, don't throw - we want to continue
      _talker.error('Failed to clear auth tokens', e);
    }
  }

  Future<void> dispose() async {
    await _authErrorController.close();
  }
} 