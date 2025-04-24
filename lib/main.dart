import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:melamine_elsherif/core/theme/app_theme.dart';
import 'package:melamine_elsherif/core/utils/app_router.dart';
import 'package:melamine_elsherif/core/utils/app_constants.dart';
import 'package:melamine_elsherif/core/utils/logger.dart';
import 'package:melamine_elsherif/di/service_locator.dart';
import 'package:melamine_elsherif/presentation/viewmodels/cart_viewmodel.dart';
import 'package:melamine_elsherif/presentation/viewmodels/home_viewmodel.dart';
import 'package:melamine_elsherif/presentation/viewmodels/product_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize logger
  AppLogger.init();

  // Initialize service locator
  await initServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => serviceLocator<HomeViewModel>(),
        ),
        ChangeNotifierProvider<ProductViewModel>(
          create: (_) => serviceLocator<ProductViewModel>(),
        ),
        ChangeNotifierProvider<CartViewModel>(
          create: (_) => serviceLocator<CartViewModel>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRouter.generateRoute,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('ar', ''), // Arabic
        ],
      ),
    );
  }
}
