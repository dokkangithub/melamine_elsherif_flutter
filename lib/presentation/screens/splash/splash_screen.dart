import 'dart:async';
import 'package:flutter/material.dart';
import 'package:melamine_elsherif/core/constants/app_assets.dart';
import 'package:melamine_elsherif/data/datasources/local/app_preferences.dart';
import 'package:melamine_elsherif/di/service_locator.dart';
import 'package:melamine_elsherif/presentation/screens/auth/login_screen.dart';
import 'package:melamine_elsherif/presentation/screens/home/home_screen.dart';
import 'package:melamine_elsherif/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:melamine_elsherif/presentation/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    if (!mounted) return;

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final appPreferences = serviceLocator<AppPreferences>();
    
    try {
      // Initialize auth state
      await authViewModel.init();
      
      if (!mounted) return;

      // Check if this is first launch
      final bool isFirstLaunch = await appPreferences.isFirstLaunch();
      
      if (isFirstLaunch) {
        // Navigate to onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      } else if (authViewModel.isAuthenticated) {
        // User is authenticated, go to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // User is not authenticated, go to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _errorMessage = 'Error initializing app: ${e.toString()}';
      });
      
      // Wait a bit to show the error message
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      // Navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your app logo
            Image.asset(
              AppAssets.logoWithText,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 24),
            if (!_isInitialized)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
} 