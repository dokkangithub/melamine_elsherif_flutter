abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure({String message = 'Server Error'}) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure({String message = 'Cache Error'}) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure({String message = 'Network Error'}) : super(message);
}

class ValidationFailure extends Failure {
  ValidationFailure({String message = 'Validation Error'}) : super(message);
}

class AuthFailure extends Failure {
  AuthFailure({String message = 'Authentication Error'}) : super(message);
} 