import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing sensitive data like authentication tokens
class SecureStorageService {
  final FlutterSecureStorage _secureStorage;
  
  // Keys for secure storage
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  
  // Options for Android and iOS
  final _secureStorageOptions = const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  /// Creates an instance of [SecureStorageService]
  SecureStorageService() 
      : _secureStorage = const FlutterSecureStorage();
  
  /// Saves the authentication token
  Future<void> saveToken(String token) async {
    await _secureStorage.write(
      key: _tokenKey,
      value: token,
      aOptions: _secureStorageOptions,
    );
  }
  
  /// Gets the authentication token
  Future<String?> getToken() async {
    return await _secureStorage.read(
      key: _tokenKey,
      aOptions: _secureStorageOptions,
    );
  }
  
  /// Saves the refresh token
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(
      key: _refreshTokenKey,
      value: token,
      aOptions: _secureStorageOptions,
    );
  }
  
  /// Gets the refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(
      key: _refreshTokenKey,
      aOptions: _secureStorageOptions,
    );
  }
  
  /// Saves the user ID
  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(
      key: _userIdKey,
      value: userId,
      aOptions: _secureStorageOptions,
    );
  }
  
  /// Gets the user ID
  Future<String?> getUserId() async {
    return await _secureStorage.read(
      key: _userIdKey,
      aOptions: _secureStorageOptions,
    );
  }
  
  /// Deletes the authentication token
  Future<void> deleteToken() async {
    await _secureStorage.delete(
      key: _tokenKey,
      aOptions: _secureStorageOptions,
    );
  }
  
  /// Deletes the refresh token
  Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(
      key: _refreshTokenKey,
      aOptions: _secureStorageOptions,
    );
  }
  
  /// Clears all stored data
  Future<void> clearAll() async {
    await _secureStorage.deleteAll(
      aOptions: _secureStorageOptions,
    );
  }
} 