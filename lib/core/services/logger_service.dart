import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LoggerService {
  final Talker talker;
  
  LoggerService({required this.talker});
  
  void setupDioInterceptors(Dio dio) {
    // Add Pretty Dio Logger for detailed HTTP request/response logging
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
      ),
    );
    
    // Add Talker logger for app-wide logging
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          talker.debug('🌐 API Request: ${options.method} ${options.uri}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          talker.info('✅ API Response [${response.statusCode}]: ${response.requestOptions.uri}');
          
          // Log authentication responses with special formatting
          if (response.requestOptions.path.contains('auth') || 
              response.requestOptions.path.contains('login') ||
              response.requestOptions.path.contains('register')) {
            talker.info('👤 Authentication successful');
          }
          
          handler.next(response);
        },
        onError: (DioException error, handler) {
          // Extract error message for better logging
          String errorMsg = 'Unknown error';
          if (error.response?.data != null) {
            try {
              if (error.response!.data is Map) {
                final data = error.response!.data as Map;
                if (data.containsKey('message')) {
                  errorMsg = data['message'].toString();
                } else if (data.containsKey('error')) {
                  errorMsg = data['error'].toString();
                } else if (data.containsKey('errors') && data['errors'] is List && (data['errors'] as List).isNotEmpty) {
                  errorMsg = data['errors'][0]['message'] ?? 'Unknown error';
                }
              }
            } catch (e) {
              errorMsg = error.message ?? 'Error parsing error response';
            }
          }
          
          talker.error(
            '❌ API Error [${error.response?.statusCode}]: ${error.requestOptions.uri}',
            errorMsg
          );
          
          // Special handling for authentication errors
          if (error.requestOptions.path.contains('auth') || 
              error.requestOptions.path.contains('login') ||
              error.requestOptions.path.contains('register')) {
            talker.error('👤 Authentication failed: $errorMsg');
          }
          
          handler.next(error);
        },
      ),
    );
  }
  
  // Utility method to log authentication events
  void logAuth(String action, bool success, {String? message}) {
    if (success) {
      talker.info('👤 $action successful');
    } else {
      talker.error('👤 $action failed${message != null ? ': $message' : ''}');
    }
  }
} 