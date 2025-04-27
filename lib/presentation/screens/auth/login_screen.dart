import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:melamine_elsherif/core/constants/app_assets.dart';
import 'package:melamine_elsherif/presentation/screens/auth/signup_screen.dart';
import 'package:melamine_elsherif/presentation/screens/auth/forgot_password_screen.dart';
import 'package:melamine_elsherif/presentation/screens/home/home_screen.dart';
import 'package:melamine_elsherif/presentation/viewmodels/auth_viewmodel.dart';
import 'package:melamine_elsherif/presentation/viewmodels/product/product_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _clearingToken = true;
  String? _errorMessage;
  String? _jwtToken;

  @override
  void initState() {
    super.initState();
    _clearTokenIfNeeded();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Clear token on startup to fix any potential authentication issues
  Future<void> _clearTokenIfNeeded() async {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.clearTokenOnStartup();
      setState(() {
        _clearingToken = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error clearing token: ${e.toString()}';
        _clearingToken = false;
      });
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Get the AuthViewModel
        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
        
        // Login with email and password
        final success = await authViewModel.loginWithEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        
        if (!mounted) return;
        
        if (success) {
          try {
            // Get the ProductViewModel to load initial data
            final productViewModel = Provider.of<ProductViewModel>(context, listen: false);
            
            // Load initial data for home screen with error handling for each call
            final futures = <Future>[];
            
            // Add each data loading operation with its own error handling
            futures.add(
              productViewModel.getProducts().catchError((e) {
                debugPrint('Error loading products: $e');
                return null;
              })
            );
            
            futures.add(
              productViewModel.getFeaturedProducts().catchError((e) {
                debugPrint('Error loading featured products: $e');
                return null;
              })
            );
            
            futures.add(
              productViewModel.getNewArrivals().catchError((e) {
                debugPrint('Error loading new arrivals: $e');
                return null;
              })
            );
            
            futures.add(
              productViewModel.getCategories().catchError((e) {
                debugPrint('Error loading categories: $e');
                return null;
              })
            );
            
            futures.add(
              productViewModel.getCollections().catchError((e) {
                debugPrint('Error loading collections: $e');
                return null;
              })
            );
            
            // Wait for all futures to complete, even if some fail
            await Future.wait(futures);
            
            if (!mounted) return;
            
            // Navigate to home screen and remove all previous routes
            Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          } catch (e) {
            if (!mounted) return;
            
            // Show error loading initial data
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Some data could not be loaded. You can still browse the app.',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
            
            // Still navigate to home screen even if data loading fails
            Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          }
        } else {
          // Show error in custom snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                authViewModel.error ?? 'Login failed',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        
        // Catch any unexpected errors and display them
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login error: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  // Logo
                  Center(
                    child: Image.asset(
                      AppAssets.logoWithText,
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Welcome back text
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to continue shopping',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Email field
                  _buildEmailField(),
                  const SizedBox(height: 16),
                  // Password field
                  _buildPasswordField(),
                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFBD5D5D),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Sign in button
                  _buildLoginButton(),
                  const SizedBox(height: 24),
                  // Or continue with
                  const Center(
                    child: Text(
                      'Or continue with',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Social login buttons
                  _buildSocialLogin(),
                  const SizedBox(height: 40),
                  // Don't have an account? Sign Up
                  _buildSignupLink(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFBD5D5D)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFBD5D5D)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        return Column(
          children: [
            if (authViewModel.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  authViewModel.error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ElevatedButton(
              onPressed: authViewModel.isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBD5D5D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: authViewModel.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        );
      }
    );
  }

  Widget _buildSocialLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIconButton(
          onPressed: () {
            // TODO: Implement Google login
          },
          icon: SvgPicture.asset(
            AppAssets.googleLogo,
            height: 24,
          ),
        ),
        const SizedBox(width: 24),
        _buildSocialIconButton(
          onPressed: () {
            // TODO: Implement Facebook login
          },
          icon: SvgPicture.asset(
            AppAssets.facebookLogo,
            height: 24,
          ),
        ),
        const SizedBox(width: 24),
        _buildSocialIconButton(
          onPressed: () {
            // TODO: Implement Apple login
          },
          icon: SvgPicture.asset(
            AppAssets.appleLogo,
            height: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIconButton({
    required VoidCallback onPressed,
    required Widget icon,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(child: icon),
      ),
    );
  }

  Widget _buildSignupLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Don\'t have an account? ',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: 'Sign Up',
              style: const TextStyle(
                color: Color(0xFFBD5D5D),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
} 