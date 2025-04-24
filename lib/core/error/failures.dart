import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  
  const Failure({this.message = 'An unexpected error occurred'});
  
  @override
  List<Object> get props => [message];
}

/// Server related failures
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'A server error occurred'});
}

/// Network related failures
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'A network error occurred. Please check your connection'});
}

/// Failures related to cache operations
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'A cache error occurred'});
}

/// Authentication related failures
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'An authentication error occurred'});
}

/// Validation related failures
class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'A validation error occurred'});
}

/// Permissions related failures
class PermissionFailure extends Failure {
  const PermissionFailure({super.message = 'A permission error occurred'});
}

/// Not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'The requested resource was not found'});
} 