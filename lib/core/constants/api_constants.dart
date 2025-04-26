class ApiConstants {
  static const String baseUrl = 'http://192.168.1.38:9000';
  
  // Authentication endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  
  // Product endpoints
  static const String products = '/products';
  static const String categories = '/categories';
  static const String collections = '/collections';
  
  // Customer endpoints
  static const String customers = '/customers';
  static const String addresses = '/addresses';
  
  // Cart endpoints
  static const String carts = '/carts';
  
  // Order endpoints
  static const String orders = '/orders';
} 