import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:melamine_elsherif/core/config/app_config.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/core/utils/logger.dart';
import 'package:melamine_elsherif/core/network/api_constants.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  
  ApiClient(this._dio, this._secureStorage) {
    _dio.options.baseUrl = AppConfig.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.contentType = 'application/json';
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token = await _secureStorage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          // Log request in dev mode
          if (AppConfig.isDebugMode) {
            AppLogger.d('Request: ${options.method} ${options.uri}');
            AppLogger.d('Headers: ${options.headers}');
            AppLogger.d('Data: ${options.data}');
          }
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response in dev mode
          if (AppConfig.isDebugMode) {
            AppLogger.d('Response: [${response.statusCode}] ${response.requestOptions.uri}');
            AppLogger.d('Response Data: ${response.data}');
          }
          
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          // Log error in dev mode
          if (AppConfig.isDebugMode) {
            AppLogger.e('API Error: ${error.message}', error, error.stackTrace);
          }
          
          // Handle 401 Unauthorized error
          if (error.response?.statusCode == 401) {
            // Clear token and notify user to login again
            await _secureStorage.delete(key: 'auth_token');
            // Continue with error
          }
          
          // Handle network errors
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.error is SocketException) {
            return handler.next(
              DioException(
                requestOptions: error.requestOptions,
                error: 'No internet connection. Please check your network settings.',
                type: error.type,
              ),
            );
          }
          
          // Pass the error to the next handler
          return handler.next(error);
        },
      ),
    );
  }
  
  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      AppLogger.d('GET $path | Status: ${response.statusCode}');
      return response;
    } catch (e) {
      _handleError(e, 'GET', path);
      // This line won't be reached, but it's needed to satisfy the non-nullable return type
      throw Exception('Unreachable code');
    }
  }
  
  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      AppLogger.d('POST $path | Status: ${response.statusCode}');
      return response;
    } catch (e) {
      _handleError(e, 'POST', path);
      // This line won't be reached, but it's needed to satisfy the non-nullable return type
      throw Exception('Unreachable code');
    }
  }
  
  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      AppLogger.d('PUT $path | Status: ${response.statusCode}');
      return response;
    } catch (e) {
      _handleError(e, 'PUT', path);
      // This line won't be reached, but it's needed to satisfy the non-nullable return type
      throw Exception('Unreachable code');
    }
  }
  
  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      AppLogger.d('DELETE $path | Status: ${response.statusCode}');
      return response;
    } catch (e) {
      _handleError(e, 'DELETE', path);
      // This line won't be reached, but it's needed to satisfy the non-nullable return type
      throw Exception('Unreachable code');
    }
  }

  /// Handles API error
  void _handleError(dynamic e, String method, String endpoint) {
    AppLogger.e('$method $endpoint | Error: ${e.message}', e, e.stackTrace);
    
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw ApiException(message: 'Connection timed out', statusCode: 408);
        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode;
          final message = e.response?.data?['message'] ?? 'Unknown error';
          
          if (statusCode == 401) {
            throw ApiException(message: message, statusCode: 401);
          } else if (statusCode == 403) {
            throw ApiException(message: message, statusCode: 403);
          } else if (statusCode == 404) {
            throw ApiException(message: message, statusCode: 404);
          } else if (statusCode! >= 500) {
            throw ServerException(message: message);
          } else {
            throw ApiException(message: message, statusCode: statusCode);
          }
        case DioExceptionType.cancel:
          throw ApiException(message: 'Request was cancelled');
        case DioExceptionType.connectionError:
          throw NetworkException(message: 'No internet connection');
        default:
          throw ApiException(message: e.message ?? 'Unknown error occurred');
      }
    } else {
      throw ApiException(message: 'Unknown error: ${e.toString()}');
    }
  }
} 