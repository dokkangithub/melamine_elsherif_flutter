import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:melamine_elsherif/core/services/logger_service.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage secureStorage;
  final LoggerService logger;
  
  static const String baseUrl = 'http://192.168.1.38:9000'; // Replace with your Medusa API URL
  static const String publishableApiKey = 'pk_0dc294039a0473afc80df2a056f9435e525135f2074cb63ec024c559438867b8'; // Replace with your key
  
  ApiClient({
    required this.dio,
    required Talker talker,
    FlutterSecureStorage? secureStorage,
  }) : 
    this.secureStorage = secureStorage ?? const FlutterSecureStorage(),
    this.logger = LoggerService(talker: talker) {
    _init();
  }
  
  void _init() {
    // Configure Dio
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    
    // Add default headers
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-publishable-api-key': publishableApiKey,
    };
    
    // Add auth token interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await secureStorage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
    
    // Set up logging
    logger.setupDioInterceptors(dio);
  }
  
  /// Initialize without an existing token - useful for fixing auth issues
  Future<void> clearTokenOnStartup() async {
    try {
      await secureStorage.delete(key: 'auth_token');
    } catch (e) {
      // Just log, don't throw - we want this to be non-disruptive
      print('Failed to clear token on startup: ${e.toString()}');
    }
  }
  
  // Authentication methods
  
  /// Login a user with email and password
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Create a clean Dio instance without the auth interceptor to ensure no token is sent
      final loginDio = Dio();
      loginDio.options.baseUrl = baseUrl;
      loginDio.options.connectTimeout = const Duration(seconds: 10);
      loginDio.options.receiveTimeout = const Duration(seconds: 10);
      
      // Setup basic logging for this instance too
      logger.setupDioInterceptors(loginDio);
      
      final response = await loginDio.post(
        '/auth/customer/emailpass',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'x-publishable-api-key': publishableApiKey,
          },
        ),
      );
      
      // Store the JWT token
      if (response.data['token'] != null) {
        await secureStorage.write(key: 'auth_token', value: response.data['token']);
      }
      
      return response.data;
    } catch (e) {
      // Extract detailed error message from response if possible
      if (e is DioException && e.response != null) {
        String errorMessage = 'Login failed';
        
        if (e.response!.data is Map) {
          final errorData = e.response!.data as Map;
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'].toString();
          }
        }
        
        // Improve error message for common authentication errors
        if (e.response?.statusCode == 401) {
          errorMessage = 'Invalid email or password. Please try again.';
        }
        
        throw ApiException(
          message: errorMessage,
          statusCode: e.response?.statusCode
        );
      }
      
      // For other types of errors
      rethrow;
    }
  }
  
  /// Register a new user
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      final response = await dio.post(
        '/auth/customer/emailpass/register',
        data: {
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
        },
      );
      
      return response.data;
    } catch (e) {
      // Check if it's a DioException and handle it specifically
      if (e is DioException && e.response != null) {
        // Extract detailed error message from response if possible
        String errorMessage = 'Registration failed';
        
        if (e.response!.data is Map) {
          final errorData = e.response!.data as Map;
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'].toString();
          }
          
          // Check for email already exists error
          if (errorMessage.toLowerCase().contains('email') && 
              errorMessage.toLowerCase().contains('exists') ||
              (errorData.containsKey('type') && 
               errorData['type'] == 'unauthorized' && 
               errorMessage.contains('Identity with email already exists'))) {
            throw ApiException(
              message: 'An account with this email already exists. Please try logging in instead.',
              statusCode: e.response?.statusCode
            );
          }
        }
        
        // If not caught by the specific checks above, throw with the general message
        throw ApiException(
          message: errorMessage,
          statusCode: e.response?.statusCode
        );
      }
      
      // For other types of errors
      rethrow;
    }
  }
  
  /// Reset password request
  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      final response = await dio.post(
        '/auth/customer/password-token',
        data: {
          'email': email,
        },
      );
      
      return response.data;
    } catch (e) {
      // Check if it's a DioException and handle it specifically
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
      final response = await dio.post(
        '/auth/customer/password-reset',
        data: {
          'token': token,
          'password': password,
        },
      );
      
      return response.data;
    } catch (e) {
      // Check if it's a DioException and handle it specifically
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
  
  /// Get current user profile
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await dio.get('/auth/customer/me');
      return response.data;
    } catch (e) {
      // Check if it's a DioException and handle it specifically
      if (e is DioException && e.response != null) {
        String errorMessage = 'Failed to get user profile';
        
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
  
  /// Logout user
  Future<void> logout() async {
    try {
      // Try server-side logout first (if it fails, we'll still clear the local token)
      try {
        await dio.post(
          '/auth/customer/logout',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'x-publishable-api-key': publishableApiKey,
            },
          ),
        );
      } catch (e) {
        // Log but continue - we still want to clear the token locally
        print('Server logout failed: ${e.toString()}');
      }
      
      // Always clear local token, even if server logout fails
      await secureStorage.delete(key: 'auth_token');
    } catch (e) {
      // Ensure token is deleted even if an error occurs
      await secureStorage.delete(key: 'auth_token');
      
      // Check if it's a DioException and handle it specifically
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
} 