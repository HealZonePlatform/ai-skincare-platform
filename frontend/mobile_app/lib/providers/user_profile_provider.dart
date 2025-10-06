// lib/providers/user_profile_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ai_skincare_platform/api/user_profile_api_service.dart';
import 'package:ai_skincare_platform/models/user_profile.dart';
import 'package:ai_skincare_platform/services/secure_storage_service.dart';

class UserProfileProvider with ChangeNotifier {
 final UserProfileApiService _apiService = UserProfileApiService();
  final SecureStorageService _storageService = SecureStorageService();

  UserProfile? _userProfile;
  List<SkinAnalysisHistory> _skinAnalysisHistory = [];
  List<SkinAnalysisHistory> _filteredSkinAnalysisHistory = [];
  
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _errorMessage;
  String _searchQuery = '';

  UserProfile? get userProfile => _userProfile;
  List<SkinAnalysisHistory> get skinAnalysisHistory => _filteredSkinAnalysisHistory.isEmpty ? _skinAnalysisHistory : _filteredSkinAnalysisHistory;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;
  
  String get searchQuery => _searchQuery;

  UserProfileProvider() {
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _storageService.getAccessToken();
      if (token != null) {
        final response = await _apiService.getUserProfile(token);
        if (response.statusCode == 200 || response.statusCode == 201) {
          _userProfile = UserProfile.fromJson(response.data['data']);
          // Tải lịch sử phân tích trong nền để không làm chậm tải hồ sơ chính
          _loadSkinAnalysisHistoryInBackground();
        } else {
          _errorMessage = 'Không thể tải thông tin người dùng';
        }
      } else {
        _errorMessage = 'Người dùng chưa đăng nhập';
      }
    } on DioException catch (e) {
      // Xử lý lỗi mạng và lỗi API
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
        _errorMessage = 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        _errorMessage = 'Hết thời gian kết nối. Vui lòng thử lại sau.';
      } else if (e.type == DioExceptionType.sendTimeout) {
        _errorMessage = 'Hết thời gian gửi yêu cầu. Vui lòng thử lại sau.';
      } else if (e.response?.statusCode == 401) {
        _errorMessage = 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
      } else {
        _errorMessage = e.response?.data['message'] ?? 'Đã xảy ra lỗi khi tải thông tin người dùng.';
      }
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không xác định: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Hàm tải lịch sử phân tích trong nền
  Future<void> _loadSkinAnalysisHistoryInBackground() async {
    try {
      final token = await _storageService.getAccessToken();
      if (token != null) {
        final response = await _apiService.getSkinAnalysisHistory(token);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final List<dynamic> historyList = response.data['data'];
          _skinAnalysisHistory = historyList
              .map((item) => SkinAnalysisHistory.fromJson(item))
              .toList();
          notifyListeners();
        } else {
          _errorMessage = 'Không thể tải lịch sử phân tích da';
        }
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Đã xảy ra lỗi khi tải lịch sử phân tích da.';
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không xác định: $e';
    }
  }

  // Thêm các thuộc tính cho phân trang
  int _currentPage = 1;
  int _totalPages = 1;
  int _pageSize = 10;
  bool _hasMoreData = true;
  
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get pageSize => _pageSize;
  bool get hasMoreData => _hasMoreData;

  Future<void> loadSkinAnalysisHistory({int page = 1, bool isLoadMore = false}) async {
    if (page == 1 && !isLoadMore) {
      _isLoading = true;
    }
    notifyListeners();

    try {
      final token = await _storageService.getAccessToken();
      if (token != null) {
        // Thêm tham số phân trang vào API (giả định API hỗ trợ)
        final response = await _apiService.getSkinAnalysisHistory(token);
        if (response.statusCode == 20 || response.statusCode == 201) {
          final List<dynamic> historyList = response.data['data'];
          final newHistory = historyList
              .map((item) => SkinAnalysisHistory.fromJson(item))
              .toList();
          
          if (isLoadMore) {
            _skinAnalysisHistory.addAll(newHistory);
          } else {
            _skinAnalysisHistory = newHistory;
          }
          
          // Cập nhật thông tin phân trang (giả định từ API)
          _currentPage = page;
          _totalPages = response.data['totalPages'] ?? 1;
          _hasMoreData = _currentPage < _totalPages;
        } else {
          _errorMessage = 'Không thể tải lịch sử phân tích da';
        }
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Đã xảy ra lỗi khi tải lịch sử phân tích da.';
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không xác định: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> loadMoreSkinAnalysisHistory() async {
    if (_hasMoreData && !_isLoading) {
      await loadSkinAnalysisHistory(page: _currentPage + 1, isLoadMore: true);
    }
  }

  Future<bool> updateUserProfile({
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _storageService.getAccessToken();
      if (token != null) {
        final userData = <String, dynamic>{};
        if (fullName != null) userData['fullName'] = fullName;
        if (phoneNumber != null) userData['phoneNumber'] = phoneNumber;
        if (avatarUrl != null) userData['avatarUrl'] = avatarUrl;

        final response = await _apiService.updateUserProfile(token, userData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Cập nhật thông tin trong local
          _userProfile = UserProfile.fromJson(response.data['data']);
          notifyListeners();
          return true;
        } else {
          _errorMessage = 'Không thể cập nhật thông tin người dùng';
          return false;
        }
      } else {
        _errorMessage = 'Người dùng chưa đăng nhập';
        return false;
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Đã xảy ra lỗi khi cập nhật thông tin người dùng.';
      return false;
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không xác định: $e';
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Thêm phương thức upload avatar
  Future<bool> uploadAvatar(String filePath) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final token = await _storageService.getAccessToken();
      if (token != null) {
        final response = await _apiService.uploadAvatar(token, filePath);
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Cập nhật thông tin avatar trong local
          final updatedData = response.data['data'];
          _userProfile = _userProfile!.copyWith(avatarUrl: updatedData['avatarUrl']);
          notifyListeners();
          return true;
        } else {
          _errorMessage = 'Không thể cập nhật ảnh đại diện';
          return false;
        }
      } else {
        _errorMessage = 'Người dùng chưa đăng nhập';
        return false;
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Đã xảy ra lỗi khi cập nhật ảnh đại diện.';
      return false;
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không xác định: $e';
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }
  
  // Thay đổi mật khẩu người dùng
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final token = await _storageService.getAccessToken();
      if (token != null) {
        final response = await _apiService.changePassword(token, oldPassword, newPassword);
        if (response.statusCode == 200 || response.statusCode == 201) {
          notifyListeners();
          return true;
        } else {
          _errorMessage = 'Không thể thay đổi mật khẩu';
          return false;
        }
      } else {
        _errorMessage = 'Người dùng chưa đăng nhập';
        return false;
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Đã xảy ra lỗi khi thay đổi mật khẩu.';
      return false;
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không xác định: $e';
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }
}

void setSearchQuery(String query) {
  _searchQuery = query;
  if (query.isEmpty) {
    _filteredSkinAnalysisHistory = [];
  } else {
    _filteredSkinAnalysisHistory = _skinAnalysisHistory
        .where((item) =>
            item.id.toLowerCase().contains(query.toLowerCase()) ||
            item.createdAt.toString().toLowerCase().contains(query.toLowerCase()) ||
            (item.status?.toLowerCase().contains(query.toLowerCase()) ?? false))
        .toList();
  }
  notifyListeners();
}

void clearError() {
  _errorMessage = null;
  notifyListeners();
}
}
}