import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor that logs API requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String headers = options.headers.toString();
    final String queryParameters = options.queryParameters.toString();
    
    debugPrint('┌------------------------------------------------------------------------------');
    debugPrint('| REQUEST: ${options.method} ${options.uri}');
    debugPrint('| HEADERS: $headers');
    
    if (options.queryParameters.isNotEmpty) {
      debugPrint('| QUERY: $queryParameters');
    }
    
    if (options.data != null) {
      debugPrint('| BODY: ${options.data}');
    }
    
    debugPrint('└------------------------------------------------------------------------------');
    
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('┌------------------------------------------------------------------------------');
    debugPrint('| RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    debugPrint('| HEADERS: ${response.headers}');
    debugPrint('| BODY: ${response.data}');
    debugPrint('└------------------------------------------------------------------------------');
    
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('┌------------------------------------------------------------------------------');
    debugPrint('| ERROR: ${err.type} ${err.message}');
    debugPrint('| URL: ${err.requestOptions.uri}');
    
    if (err.response != null) {
      debugPrint('| STATUS: ${err.response!.statusCode}');
      debugPrint('| BODY: ${err.response!.data}');
    }
    
    debugPrint('└------------------------------------------------------------------------------');
    
    handler.next(err);
  }
} 