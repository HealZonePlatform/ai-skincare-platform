// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ai_skincare_platform/api/auth_api_service.dart';
import 'package:ai_skincare_platform/services/secure_storage_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthApiService _apiService = AuthApiService();
  final SecureStorageService _storageService = SecureStorageService();

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  AuthProvider() {
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final token = await _storageService.getAccessToken();
    if (token != null) {
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final accessToken = response.data['data']['accessToken'];
        final refreshToken = response.data['data']['refreshToken'];
        await _storageService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        _isLoggedIn = true;
        return true;
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Đã xảy ra lỗi không xác định.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  // ✅ FIXED: Changed from (String email, String password) to (Map<String, dynamic> userData)
  Future<bool> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.register(userData);
      if (response.statusCode == 201) {
        // Auto login after successful registration
        final email = userData['email'];
        final password = userData['password'];
        return await login(email, password);
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Đăng ký thất bại.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> logout() async {
    await _storageService.deleteAllTokens();
    _isLoggedIn = false;
    notifyListeners();
  }
}
