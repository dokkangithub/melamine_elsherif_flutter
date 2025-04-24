import 'package:flutter/material.dart';
import 'package:melamine_elsherif/presentation/screens/splash/splash_screen.dart';
import 'package:melamine_elsherif/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:melamine_elsherif/presentation/screens/auth/login_screen.dart';
import 'package:melamine_elsherif/core/utils/logger.dart';

/// Router for app navigation
class AppRouter {
  /// Route names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String productDetails = '/product-details';
  static const String cart = '/cart';
  static const String wishlist = '/wishlist';
  static const String categories = '/categories';
  static const String categoryProducts = '/category-products';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';
  static const String orders = '/orders';
  static const String orderDetails = '/order-details';
  static const String addresses = '/addresses';
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address';
  
  /// Generate the appropriate route based on settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    AppLogger.i('Navigating to: ${settings.name}');
    
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return _errorRoute();
    }
  }
  
  /// Fallback for undefined routes
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Route not found!'),
        ),
      ),
    );
  }
} 