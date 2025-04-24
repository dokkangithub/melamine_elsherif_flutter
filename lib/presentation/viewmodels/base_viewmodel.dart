import 'package:flutter/foundation.dart';

/// BaseViewModel is the parent class for all ViewModels
/// It contains common functionality that all ViewModels need
class BaseViewModel extends ChangeNotifier {
  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Error state
  String? _error;
  String? get error => _error;

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Disposed state
  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // Method to safely run async operations
  Future<void> runBusyFuture<T>(
    Future<T> Function() future, {
    Function(T)? onSuccess,
    Function(dynamic)? onError,
    bool throwException = false,
  }) async {
    clearError();
    setLoading(true);

    try {
      final result = await future();
      if (onSuccess != null) {
        onSuccess(result);
      }
    } catch (e) {
      if (onError != null) {
        onError(e);
      }
      
      setError(e.toString());
      
      if (throwException) {
        rethrow;
      }
    } finally {
      setLoading(false);
    }
  }
} 