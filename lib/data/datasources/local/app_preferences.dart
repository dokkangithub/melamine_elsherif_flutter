import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// A class that manages the app's shared preferences
class AppPreferences {
  final SharedPreferences _preferences;

  // Preference keys
  static const String _keyLanguage = 'language';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyIsFirstLaunch = 'is_first_launch';
  static const String _keyLastCacheTime = 'last_cache_time';
  static const String _keyUserProfile = 'user_profile';
  static const String _keyCartId = 'cart_id';
  static const String _keySearchHistory = 'search_history';

  AppPreferences(this._preferences);

  // Language preferences
  Future<void> setLanguage(String languageCode) async {
    await _preferences.setString(_keyLanguage, languageCode);
  }

  String getLanguage() {
    return _preferences.getString(_keyLanguage) ?? 'en';
  }

  // Theme mode preferences
  Future<void> setThemeMode(String themeMode) async {
    await _preferences.setString(_keyThemeMode, themeMode);
  }

  String getThemeMode() {
    return _preferences.getString(_keyThemeMode) ?? 'system';
  }

  // First launch preference
  Future<void> setIsFirstLaunch(bool isFirstLaunch) async {
    await _preferences.setBool(_keyIsFirstLaunch, isFirstLaunch);
  }

  bool isFirstLaunch() {
    return _preferences.getBool(_keyIsFirstLaunch) ?? true;
  }

  // Cache time preferences
  Future<void> setLastCacheTime(DateTime dateTime) async {
    await _preferences.setString(_keyLastCacheTime, dateTime.toIso8601String());
  }

  DateTime? getLastCacheTime() {
    final timeString = _preferences.getString(_keyLastCacheTime);
    if (timeString == null) return null;
    
    try {
      return DateTime.parse(timeString);
    } catch (e) {
      return null;
    }
  }

  // Check if cache is valid
  bool isCacheValid(int cacheDurationInSeconds) {
    final lastCacheTime = getLastCacheTime();
    if (lastCacheTime == null) return false;
    
    final currentTime = DateTime.now();
    final difference = currentTime.difference(lastCacheTime).inSeconds;
    
    return difference < cacheDurationInSeconds;
  }

  // User profile preferences (stores user data in JSON format)
  Future<void> setUserProfile(Map<String, dynamic> userProfile) async {
    await _preferences.setString(_keyUserProfile, jsonEncode(userProfile));
  }

  Map<String, dynamic>? getUserProfile() {
    final userProfileString = _preferences.getString(_keyUserProfile);
    if (userProfileString == null) return null;
    
    try {
      return jsonDecode(userProfileString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<void> clearUserProfile() async {
    await _preferences.remove(_keyUserProfile);
  }

  // Cart ID preference
  Future<void> setCartId(String cartId) async {
    await _preferences.setString(_keyCartId, cartId);
  }

  String? getCartId() {
    return _preferences.getString(_keyCartId);
  }

  Future<void> clearCartId() async {
    await _preferences.remove(_keyCartId);
  }

  // Search history preference (stores a list of recent searches)
  Future<void> addToSearchHistory(String query) async {
    final history = getSearchHistory();
    
    // Remove the query if it already exists to avoid duplicates
    history.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
    
    // Add the query to the beginning of the list
    history.insert(0, query);
    
    // Keep only the most recent 10 searches
    if (history.length > 10) {
      history.removeLast();
    }
    
    await _preferences.setStringList(_keySearchHistory, history);
  }

  List<String> getSearchHistory() {
    return _preferences.getStringList(_keySearchHistory) ?? [];
  }

  Future<void> clearSearchHistory() async {
    await _preferences.remove(_keySearchHistory);
  }

  // Clear all preferences
  Future<void> clearAll() async {
    await _preferences.clear();
  }
} 