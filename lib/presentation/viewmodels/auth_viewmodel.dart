import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/domain/entities/user.dart';
import 'package:melamine_elsherif/domain/usecases/auth/get_current_user.dart';
import 'package:melamine_elsherif/domain/usecases/auth/login.dart';
import 'package:melamine_elsherif/domain/usecases/auth/logout.dart';
import 'package:melamine_elsherif/domain/usecases/auth/register.dart';
import 'package:melamine_elsherif/domain/usecases/auth/request_password_reset.dart';
import 'package:melamine_elsherif/domain/usecases/auth/update_profile.dart';
import 'package:melamine_elsherif/presentation/viewmodels/base_viewmodel.dart';

class AuthViewModel extends BaseViewModel {
  final Login login;
  final Register register;
  final Logout logout;
  final GetCurrentUser getCurrentUser;
  final RequestPasswordReset requestPasswordResetUseCase;
  final UpdateProfile updateProfileUseCase;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isSessionAuth = false;

  AuthViewModel({
    required this.login,
    required this.register,
    required this.logout,
    required this.getCurrentUser,
    required this.requestPasswordResetUseCase,
    required this.updateProfileUseCase,
  });

  User? _currentUser;
  User? get currentUser => _currentUser;

  String? _jwtToken;
  String? get jwtToken => _jwtToken;

  bool get isAuthenticated => _currentUser != null && (_jwtToken != null || _isSessionAuth);

  // Initialize the view model by checking if user is logged in
  Future<void> init() async {
    try {
      setLoading(true);
      setError(null);
      
      // First check if we have a token or session
      final token = await _secureStorage.read(key: 'auth_token');
      final sessionId = await _secureStorage.read(key: 'session_id');
      
      if (token == null && sessionId == null) {
        _currentUser = null;
        _jwtToken = null;
        _isSessionAuth = false;
        setLoading(false);
        return;
      }

      try {
        // Try to get the current user to validate the token/session
        final result = await getCurrentUser.execute();
        
        result.fold(
          (failure) {
            // If we get an auth error, clear the tokens
            if (failure is AuthFailure) {
              _clearAuthTokens();
              _currentUser = null;
              _jwtToken = null;
              _isSessionAuth = false;
              setError('Session expired. Please login again.');
            } else {
              setError(failure.message);
            }
          },
          (user) {
            _currentUser = user;
            _jwtToken = token;
            _isSessionAuth = sessionId != null;
            setError(null);
          },
        );
      } catch (e) {
        // If we get a 401 or any other auth error, clear the tokens
        await _clearAuthTokens();
        _currentUser = null;
        _jwtToken = null;
        _isSessionAuth = false;
        setError('Session expired. Please login again.');
      }
    } catch (e) {
      // Clear tokens on any error during initialization
      await _clearAuthTokens();
      _currentUser = null;
      _jwtToken = null;
      _isSessionAuth = false;
      setError('Failed to initialize authentication');
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  // Login with email and password
  Future<bool> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      setLoading(true);
      setError(null);
      
      final result = await login.execute(email: email, password: password);
      
      return result.fold(
        (failure) {
          setError(failure.message);
          return false;
        },
        (loginResponse) async {
          try {
            // Store the token securely
            await _secureStorage.write(key: 'auth_token', value: loginResponse.token);
            
            _currentUser = loginResponse.user;
            _jwtToken = loginResponse.token;
            _isSessionAuth = false; // Reset session auth on new login
            setError(null);
            return true;
          } catch (e) {
            setError('Failed to store authentication token');
            return false;
          }
        },
      );
    } catch (e) {
      if (e is AuthException) {
        setError(e.message);
      } else {
        setError('Login failed: ${e.toString()}');
      }
      return false;
    } finally {
      setLoading(false);
      notifyListeners(); // Ensure UI updates
    }
  }

  // Register a new user
  Future<bool> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    bool success = false;
    await runBusyFuture(
      () => register.call(RegisterParams(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      )),
      onSuccess: (result) {
        result.fold(
          (failure) {
            setError(failure.message);
            success = false;
          },
          (user) {
            _currentUser = user;
            success = true;
          },
        );
      },
    );
    return success;
  }

  // Logout the current user
  Future<bool> logoutUser() async {
    bool success = false;
    await runBusyFuture(
      () => logout.execute(),
      onSuccess: (result) {
        result.fold(
          (failure) {
            setError(failure.message);
            success = false;
          },
          (_) {
            _clearAuthTokens();
            _currentUser = null;
            _jwtToken = null;
            success = true;
          },
        );
      },
    );
    return success;
  }

  // Request password reset
  Future<bool> requestPasswordReset(String email) async {
    bool success = false;
    await runBusyFuture(
      () => requestPasswordResetUseCase.execute(email: email),
      onSuccess: (result) {
        result.fold(
          (failure) {
            setError(failure.message);
            success = false;
          },
          (_) => success = true,
        );
      },
    );
    return success;
  }

  // Clear all auth tokens
  Future<void> _clearAuthTokens() async {
    try {
      await _secureStorage.delete(key: 'auth_token');
      await _secureStorage.delete(key: 'session_id');
      _currentUser = null;
      _jwtToken = null;
      _isSessionAuth = false;
      setError(null);
      notifyListeners();
    } catch (e) {
      // Log error but don't throw - we want to continue
      setError('Failed to clear auth tokens');
    }
  }

  // Check if user is logged in
  Future<bool> checkAuthStatus() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      final sessionId = await _secureStorage.read(key: 'session_id');
      return token != null || sessionId != null;
    } catch (e) {
      return false;
    }
  }

  // Clear auth tokens on startup
  Future<void> clearTokenOnStartup() async {
    try {
      setLoading(true);
      await _clearAuthTokens();
      setLoading(false);
    } catch (e) {
      setLoading(false);
      setError('Failed to clear auth tokens on startup');
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? password,
  }) async {
    bool success = false;
    await runBusyFuture(
      () => updateProfileUseCase.execute(
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        password: password,
      ),
      onSuccess: (result) {
        result?.fold(
          (failure) {
            setError(failure.message);
            success = false;
          },
          (user) {
            _currentUser = user;
            success = true;
          },
        );
      },
    );
    return success;
  }
}