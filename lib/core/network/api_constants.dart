import 'package:melamine_elsherif/core/config/app_config.dart';

/// Constants for the API
class ApiConstants {
  // Base URL for the Medusa Store API
  static String get baseUrl => AppConfig.baseUrl;

  // Store API prefix
  static const String storePrefix = '/store';

  // API Keys
  static const String publishableApiKey = 'pk_0dc294039a0473afc80df2a056f9435e525135f2074cb63ec024c559438867b8';

  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // API Endpoints
  static const String products = '$storePrefix/products';
  static const String carts = '$storePrefix/carts';
  static const String customers = '$storePrefix/customers';
  static const String auth = '$storePrefix/auth';
  static const String orders = '$storePrefix/orders';
  static const String regions = '$storePrefix/regions';
  static const String shipping = '$storePrefix/shipping-options';
  static const String returns = '$storePrefix/returns';
  static const String swaps = '$storePrefix/swaps';
  static const String collections = '$storePrefix/collections';
  
  // Authentication
  static const String login = '$auth/token';
  static const String register = '$customers';
  static const String resetPassword = '$customers/password-reset';
  static const String requestPasswordReset = '$customers/password-token';
  static const String me = '$customers/me';
  
  // Products
  static const String productCategories = '$storePrefix/product-categories';
  static const String productTags = '$storePrefix/product-tags';
  static const String productTypes = '$storePrefix/product-types';
  
  // Cart
  static const String addToCart = '$carts/:id/line-items';
  static const String updateCart = '$carts/:id';
  static const String completeCart = '$carts/:id/complete';
  
  // Orders
  static const String customerOrders = '$customers/me/orders';
} 