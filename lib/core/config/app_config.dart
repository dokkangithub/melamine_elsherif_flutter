import 'package:flutter/foundation.dart';

class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();
  
  // API Base URL - uses Medusa Store API
  static const String baseUrl = 'http://192.168.1.38:9000';
  
  // Publishable API Key for Medusa Store API
  static const String publishableApiKey = 'pk_0dc294039a0473afc80df2a056f9435e525135f2074cb63ec024c559438867b8';
  
  // Debug mode flag
  static bool get isDebugMode => kDebugMode;
  
  // App name and version
  static const String appName = 'Melamine Elsherif';
  static const String appVersion = '1.0.0';
  
  // Timeout values
  static const int connectionTimeoutInSeconds = 30;
  static const int receiveTimeoutInSeconds = 30;
  
  // Cache Duration - 2 days in seconds (as per requirement)
  static const int cacheDurationInSeconds = 2 * 24 * 60 * 60;
  
  // API endpoints
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/collections';
  static const String cartEndpoint = '/carts';
  static const String customerEndpoint = '/customers';
  static const String ordersEndpoint = '/orders';
  static const String authEndpoint = '/auth';
  
  // Feature flags
  static const bool enableLocalCache = true;
  static const bool enablePushNotifications = false;
  static const bool enableAnalytics = false;
  
  // Pagination defaults
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;
} 