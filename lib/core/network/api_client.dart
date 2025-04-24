import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:melamine_elsherif/core/network/api_constants.dart';
import 'package:melamine_elsherif/core/network/interceptors/auth_interceptor.dart';
import 'package:melamine_elsherif/core/network/interceptors/logging_interceptor.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';

/// API Client for handling network requests using Dio
class ApiClient {
  final Dio _dio;

  /// Creates an instance of [ApiClient] with the provided [Dio] instance
  ApiClient(this._dio) {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors
    _dio.interceptors.add(AuthInterceptor());
    
    // Only log in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LoggingInterceptor());
    }
  }

  /// Makes a GET request to the specified [endpoint]
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } on SocketException {
      throw NetworkException(message: 'No Internet connection');
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Makes a POST request to the specified [endpoint]
  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } on SocketException {
      throw NetworkException(message: 'No Internet connection');
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Makes a PUT request to the specified [endpoint]
  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } on SocketException {
      throw NetworkException(message: 'No Internet connection');
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Makes a DELETE request to the specified [endpoint]
  Future<dynamic> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } on SocketException {
      throw NetworkException(message: 'No Internet connection');
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Handles Dio errors and throws appropriate exceptions
  Never _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw ApiException(message: 'Connection timeout', statusCode: 408);
      case DioExceptionType.badResponse:
        final response = e.response;
        final statusCode = response?.statusCode;
        final data = response?.data;
        
        switch (statusCode) {
          case 400:
            throw ApiException(message: data?['message'] ?? 'Bad request', statusCode: 400);
          case 401:
            throw ApiException(message: data?['message'] ?? 'Unauthorized', statusCode: 401);
          case 403:
            throw ApiException(message: data?['message'] ?? 'Forbidden', statusCode: 403);
          case 404:
            throw ApiException(message: data?['message'] ?? 'Not found', statusCode: 404);
          case 409:
            throw ApiException(message: data?['message'] ?? 'Conflict', statusCode: 409);
          case 500:
            throw ServerException(message: data?['message'] ?? 'Server error');
          default:
            throw ApiException(
              message: data?['message'] ?? 'Something went wrong',
              statusCode: statusCode,
            );
        }
      case DioExceptionType.cancel:
        throw ApiException(message: 'Request cancelled');
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          throw NetworkException(message: 'No Internet connection');
        }
        throw ApiException(message: e.message ?? 'Unexpected error occurred');
      default:
        throw ApiException(message: e.message ?? 'Unexpected error occurred');
    }
  }
} 