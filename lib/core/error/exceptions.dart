/// Base class for all exceptions in the application
class AppException implements Exception {
  final String message;
  
  AppException({required this.message});
  
  @override
  String toString() => message;
}

/// Exception thrown when there is a problem with the server
class ServerException extends AppException {
  ServerException({required String message}) : super(message: message);
}

/// Exception thrown when there is a problem with the cache
class CacheException extends AppException {
  CacheException({required String message}) : super(message: message);
}

/// Exception thrown when there is a problem with the network
class NetworkException extends AppException {
  NetworkException({required String message}) : super(message: message);
}

/// Exception thrown when there is a problem with the authentication
class AuthException extends AppException {
  AuthException({required String message}) : super(message: message);
}

/// Exception thrown when there is a validation error
class ValidationException extends AppException {
  ValidationException({required String message}) : super(message: message);
}

/// Exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  /// Creates a [ApiException] instance
  ApiException({required this.message, this.statusCode});
}

/// Exception thrown when there's an error with cart operations
class CartException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  CartException({
    required this.message,
    this.code,
    this.statusCode,
  });

  @override
  String toString() => 'CartException: $message${code != null ? ' (Code: $code)' : ''}';
} 