import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SecureStorageService {
  static SecureStorageService? _instance;
  static Future<SecureStorageService> getInstance() async {
    if (_instance == null) {
      _instance = SecureStorageService._();
      await _instance!._init();
    }
    return _instance!;
  }

  SecureStorageService._();

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  Future<void> _init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      if (kDebugMode) {
        print('✅ SharedPreferences initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to initialize SharedPreferences: $e');
      }
      _isInitialized = false;
    }
  }

  bool get isInitialized => _isInitialized;

  Future<bool?> getBool(String key) async {
    if (!_isInitialized || _prefs == null) return null;
    try {
      return _prefs!.getBool(key);
    } catch (e) {
      if (kDebugMode) print('Error getting bool: $e');
      return null;
    }
  }

  Future<bool> setBool(String key, bool value) async {
    if (!_isInitialized || _prefs == null) return false;
    try {
      return await _prefs!.setBool(key, value);
    } catch (e) {
      if (kDebugMode) print('Error setting bool: $e');
      return false;
    }
  }

  Future<bool> remove(String key) async {
    if (!_isInitialized || _prefs == null) return false;
    try {
      return await _prefs!.remove(key);
    } catch (e) {
      if (kDebugMode) print('Error removing key: $e');
      return false;
    }
  }

  Future<bool> clear() async {
    if (!_isInitialized || _prefs == null) return false;
    try {
      return await _prefs!.clear();
    } catch (e) {
      if (kDebugMode) print('Error clearing: $e');
      return false;
    }
  }
}