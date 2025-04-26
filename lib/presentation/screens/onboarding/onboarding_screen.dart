import 'package:flutter/material.dart';
import 'package:melamine_elsherif/core/constants/app_assets.dart';
import 'package:melamine_elsherif/data/datasources/local/app_preferences.dart';
import 'package:melamine_elsherif/di/service_locator.dart';
import 'package:melamine_elsherif/presentation/screens/auth/login_screen.dart';
import 'package:melamine_elsherif/presentation/screens/auth/signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 3;

  // Get app preferences to store onboarding completion status
  final AppPreferences _appPreferences = serviceLocator<AppPreferences>();

  // Onboarding data
  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Shop Smarter, Live Better',
      'description': 'Discover millions of products from trusted sellers worldwide',
      'image': AppAssets.onboarding1,
      'showImage': true,
      'features': <Map<String, String>>[],
      'showFeatures': false,
    },
    {
      'title': 'Easy Shopping Experience',
      'description': 'Everything you need in one place',
      'image': '',
      'showImage': false,
      'features': [
        {
          'icon': 'delivery',
          'title': 'Fast Delivery',
          'description': 'Get your orders delivered within 24 hours',
        },
        {
          'icon': 'payment',
          'title': 'Secure Payments',
          'description': 'Shop safely with multiple payment options',
        },
        {
          'icon': 'support',
          'title': '24/7 Support',
          'description': 'Our team is here to help you anytime',
        },
      ],
      'showFeatures': true,
    },
    {
      'title': 'Ready to Start Shopping?',
      'description': 'Join millions of happy shoppers today',
      'image': AppAssets.onboarding3,
      'showImage': true,
      'features': <Map<String, String>>[],
      'showFeatures': false,
      'showAuth': true,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() async {
    // Mark onboarding as completed
    await _appPreferences.setIsFirstLaunch(false);
    
    // Navigate to login screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  void _navigateToSignup() async {
    // Mark onboarding as completed
    await _appPreferences.setIsFirstLaunch(false);
    
    // Navigate to signup screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SignupScreen(),
        ),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _numPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Page view of onboarding slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _numPages,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  if (index == 0) {
                    // First screen with image
                    return _buildFirstPage(
                      title: data['title'],
                      description: data['description'],
                      image: data['image'],
                    );
                  } else if (index == 1) {
                    // Second screen with features
                    return _buildFeaturePage(
                      title: data['title'],
                      description: data['description'],
                      features: data['features'],
                    );
                  } else {
                    // Third screen with auth buttons
                    return _buildFinalPage(
                      title: data['title'],
                      description: data['description'],
                      image: data['image'],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the first onboarding page with image
  Widget _buildFirstPage({
    required String title,
    required String description,
    required String image,
  }) {
    return Column(
      children: [
        // Image section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.asset(
              image,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        // Title and description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        const Spacer(),
        
        // Next button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBD5D5D),
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Next',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        // Page indicator dots
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _numPages,
              (index) => _buildDot(index),
            ),
          ),
        ),
      ],
    );
  }

  // Build the feature page (second screen)
  Widget _buildFeaturePage({
    required String title,
    required String description,
    required List<Map<String, String>> features,
  }) {
    return Column(
      children: [
        const SizedBox(height: 30),
        
        // Features section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: features.map((feature) {
              return _buildFeatureItem(
                icon: feature['icon'] ?? 'delivery',
                title: feature['title'] ?? '',
                description: feature['description'] ?? '',
              );
            }).toList(),
          ),
        ),
        
        const Spacer(),
        
        // Title and description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        // Next button
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBD5D5D),
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Next',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        // Page indicator dots
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _numPages,
              (index) => _buildDot(index),
            ),
          ),
        ),
      ],
    );
  }

  // Build the final page with auth buttons
  Widget _buildFinalPage({
    required String title,
    required String description,
    required String image,
  }) {
    return Column(
      children: [
        // Image section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.asset(
              image,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        // Title and description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        const Spacer(),
        
        // Auth buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _navigateToSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBD5D5D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _completeOnboarding,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Color(0xFFBD5D5D)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFBD5D5D),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Page indicator dots
        Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _numPages,
              (index) => _buildDot(index),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required String icon,
    required String title,
    required String description,
  }) {
    IconData iconData;
    switch (icon) {
      case 'delivery':
        iconData = Icons.local_shipping_outlined;
        break;
      case 'payment':
        iconData = Icons.security_outlined;
        break;
      case 'support':
        iconData = Icons.headset_mic_outlined;
        break;
      default:
        iconData = Icons.check_circle_outline;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              iconData,
              color: const Color(0xFFBD5D5D),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build a page indicator dot
  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? const Color(0xFFBD5D5D)
            : const Color(0xFFBD5D5D).withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
} 