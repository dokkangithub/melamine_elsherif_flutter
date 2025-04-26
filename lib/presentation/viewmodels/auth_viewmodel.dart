import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:melamine_elsherif/domain/entities/user.dart';
import 'package:melamine_elsherif/domain/usecases/auth/get_current_user.dart';
import 'package:melamine_elsherif/domain/usecases/auth/login.dart';
import 'package:melamine_elsherif/domain/usecases/auth/logout.dart';
import 'package:melamine_elsherif/domain/usecases/auth/register.dart';
import 'package:melamine_elsherif/domain/usecases/auth/request_password_reset.dart';
import 'package:melamine_elsherif/presentation/viewmodels/base_viewmodel.dart';

class AuthViewModel extends BaseViewModel {
  final Login login;
  final Register register;
  final Logout logout;
  final GetCurrentUser getCurrentUser;
  final RequestPasswordReset requestPasswordResetUseCase;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthViewModel({
    required this.login,
    required this.register,
    required this.logout,
    required this.getCurrentUser,
    required this.requestPasswordResetUseCase,
  });

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  String? _jwtToken;
  String? get jwtToken => _jwtToken;

  // Initialize the view model by checking if user is logged in
  Future<void> init() async {
    await runBusyFuture(
      () => getCurrentUser.execute(),
      onSuccess: (result) {
        result.fold(
          (failure) => setError(failure.message),
          (user) => _currentUser = user,
        );
      },
    );
  }

  // Login with email and password
  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    bool success = false;
    await runBusyFuture(
      () => login.execute(email: email, password: password),
      onSuccess: (result) {
        result.fold(
          (failure) {
            setError(failure.message);
            success = false;
          },
          (loginResponse) {
            _currentUser = loginResponse.user;
            _jwtToken = loginResponse.token;
            _secureStorage.write(key: 'auth_token', value: _jwtToken);
            success = true;
          },
        );
      },
      onError: (error) {
        setError(error.toString());
        success = false;
      },
    );
    return success;
  }

  // Register a new user
  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    bool success = false;
    
    // Split name into first and last name
    final nameParts = name.split(' ');
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    
    final params = RegisterParams(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    
    await runBusyFuture(
      () => register.call(params),
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
      onError: (error) {
        success = false;
      },
    );
    return success;
  }

  // Log out the current user
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
            _currentUser = null;
            _secureStorage.delete(key: 'auth_token');
            success = true;
          },
        );
      },
      onError: (error) {
        success = false;
      },
    );
    return success;
  }
  
  // Request password reset
  Future<bool> requestPasswordReset({required String email}) async {
    bool success = false;
    await runBusyFuture(
      () => requestPasswordResetUseCase.execute(email: email),
      onSuccess: (result) {
        result.fold(
          (failure) {
            setError(failure.message);
            success = false;
          },
          (_) {
            success = true;
          },
        );
      },
      onError: (error) {
        success = false;
      },
    );
    return success;
  }

  // Clear token on startup for troubleshooting login issues
  Future<void> clearTokenOnStartup() async {
    try {
      await _secureStorage.delete(key: 'auth_token');
    } catch (e) {
      setError('Failed to clear token: ${e.toString()}');
    }
  }
}