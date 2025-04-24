/// Constants for the API
class ApiConstants {
  // Base URL for the Medusa Store API
  static const String baseUrl = 'https://api.medusajs.com/store';

  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // API Endpoints
  static const String products = '/products';
  static const String cart = '/carts';
  static const String customers = '/customers';
  static const String auth = '/auth';
  static const String orders = '/orders';
  static const String regions = '/regions';
  static const String shipping = '/shipping-options';
  static const String returns = '/returns';
  static const String swaps = '/swaps';
  static const String collections = '/collections';
  
  // Authentication
  static const String login = '$auth/token';
  static const String register = '$customers';
  static const String resetPassword = '$customers/password-reset';
  static const String requestPasswordReset = '$customers/password-token';
  static const String me = '$customers/me';
  
  // Products
  static const String productCategories = '/product-categories';
  static const String productTags = '/product-tags';
  static const String productTypes = '/product-types';
  
  // Cart
  static const String addToCart = '$cart/:id/line-items';
  static const String updateCart = '$cart/:id';
  static const String completeCart = '$cart/:id/complete';
  
  // Orders
  static const String customerOrders = '$customers/me/orders';
} 