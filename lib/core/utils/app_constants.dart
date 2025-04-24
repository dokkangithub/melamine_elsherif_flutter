/// Constants used throughout the app
class AppConstants {
  /// App name displayed in the title bar
  static const String appName = 'Melamine Elsherif';
  
  /// API base URL
  static const String apiBaseUrl = 'https://api.example.com';
  
  /// API version
  static const String apiVersion = 'v1';
  
  /// Token key for secure storage
  static const String tokenKey = 'auth_token';
  
  /// Refresh token key for secure storage
  static const String refreshTokenKey = 'refresh_token';
  
  /// User data key for secure storage
  static const String userDataKey = 'user_data';
  
  /// Cart ID key for local storage
  static const String cartIdKey = 'cart_id';
  
  /// Cache duration in days for local product data
  static const int productCacheDuration = 2;
  
  /// Default language code
  static const String defaultLanguage = 'en';
  
  /// Default country code
  static const String defaultCountry = 'US';
  
  /// Default currency code
  static const String defaultCurrency = 'USD';
  
  /// Default currency symbol
  static const String defaultCurrencySymbol = '\$';
  
  /// Minimum password length for registration
  static const int minPasswordLength = 8;
  
  /// Maximum number of products to show in search results
  static const int maxSearchResults = 20;
  
  /// Maximum number of products to show in related products
  static const int maxRelatedProducts = 10;
  
  /// Maximum number of recently viewed products to track
  static const int maxRecentlyViewedProducts = 20;
  
  /// Product image aspect ratio
  static const double productImageAspectRatio = 3/4;
  
  /// Default padding value
  static const double defaultPadding = 16.0;
  
  /// Small padding value
  static const double smallPadding = 8.0;
  
  /// Large padding value
  static const double largePadding = 24.0;
  
  /// Default border radius value
  static const double defaultBorderRadius = 8.0;
  
  /// Small border radius value
  static const double smallBorderRadius = 4.0;
  
  /// Large border radius value
  static const double largeBorderRadius = 16.0;
  
  /// Default animation duration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  /// App icon path
  static const String appIcon = 'assets/images/app_icon.png';
  
  /// App logo path
  static const String appLogo = 'assets/images/logo.png';
  
  /// Empty cart image path
  static const String emptyCartImage = 'assets/images/empty_cart.png';
  
  /// Empty wishlist image path
  static const String emptyWishlistImage = 'assets/images/empty_wishlist.png';
  
  /// Empty search image path
  static const String emptySearchImage = 'assets/images/empty_search.png';
  
  /// Error image path
  static const String errorImage = 'assets/images/error.png';
  
  /// No internet image path
  static const String noInternetImage = 'assets/images/no_internet.png';
} 