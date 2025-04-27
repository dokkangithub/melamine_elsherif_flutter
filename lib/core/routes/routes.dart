import 'package:flutter/material.dart';
import 'package:melamine_elsherif/presentation/screens/products/all_products_screen.dart';
import 'package:melamine_elsherif/presentation/screens/checkout/checkout_screen.dart';
import 'package:melamine_elsherif/presentation/screens/product/product_details_screen.dart';
import 'package:melamine_elsherif/presentation/screens/checkout/order_success_screen.dart';
import 'package:melamine_elsherif/presentation/screens/home/home_screen.dart';
import 'package:melamine_elsherif/presentation/screens/search/search_screen.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';

class Routes {
  static const String home = '/';
  static const String allProducts = '/all-products';
  static const String checkout = '/checkout';
  static const String productDetails = '/product-details';
  static const String orderSuccess = '/order-success';
  static const String search = '/search';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case allProducts:
        return MaterialPageRoute(
          builder: (_) => const AllProductsScreen(),
        );
      case checkout:
        return MaterialPageRoute(
          builder: (_) => const CheckoutScreen(),
        );
      case productDetails:
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        );
      case orderSuccess:
        return MaterialPageRoute(
          builder: (_) => const OrderSuccessScreen(),
        );
      case search:
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
} 