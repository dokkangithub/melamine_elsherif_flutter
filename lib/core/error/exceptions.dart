/// Exception for server errors
class ServerException implements Exception {
  final String message;

  /// Creates a [ServerException] instance
  ServerException({this.message = 'Server Error'});
}

/// Exception for cache errors
class CacheException implements Exception {
  final String message;
  
  /// Creates a [CacheException] instance
  CacheException({this.message = 'Cache Error'});
}

/// Exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  /// Creates a [ApiException] instance
  ApiException({required this.message, this.statusCode});
}

/// Exception for network errors
class NetworkException implements Exception {
  final String message;
  
  /// Creates a [NetworkException] instance
  NetworkException({this.message = 'Network Error'});
}

/// Exception for validation errors
class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>>? errors;
  
  /// Creates a [ValidationException] instance
  ValidationException({required this.message, this.errors});
}

/// Exception for authentication errors
class AuthException implements Exception {
  final String message;
  
  /// Creates an [AuthException] instance
  AuthException({this.message = 'Authentication Error'});
} 