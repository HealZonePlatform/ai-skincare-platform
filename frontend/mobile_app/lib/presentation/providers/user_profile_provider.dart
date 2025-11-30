import 'dart:async';

import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/demo/demo_session.dart';
import 'package:ai_skincare_platform/core/error/global_error_notifier.dart';
import 'package:ai_skincare_platform/core/session/auth_session_observer.dart';
import 'package:ai_skincare_platform/data/profile/datasources/profile_local_cache.dart';
import 'package:ai_skincare_platform/data/profile/repositories/profile_repository_impl.dart';
import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';
import 'package:ai_skincare_platform/domain/profile/repositories/profile_repository.dart';
import 'package:ai_skincare_platform/domain/profile/usecases/change_password_usecase.dart';
import 'package:ai_skincare_platform/domain/profile/usecases/get_analysis_history_usecase.dart';
import 'package:ai_skincare_platform/domain/profile/usecases/get_user_profile_usecase.dart';
import 'package:ai_skincare_platform/domain/profile/usecases/update_user_profile_usecase.dart';
import 'package:ai_skincare_platform/domain/profile/usecases/upload_avatar_usecase.dart';
import 'package:ai_skincare_platform/utils/error_handler.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfileProvider({
    ProfileRepository? profileRepository,
    ProfileLocalCache? cache,
    GetUserProfileUseCase? getUserProfileUseCase,
    GetAnalysisHistoryUseCase? getAnalysisHistoryUseCase,
    UpdateUserProfileUseCase? updateUserProfileUseCase,
    UploadAvatarUseCase? uploadAvatarUseCase,
    ChangePasswordUseCase? changePasswordUseCase,
  })  : _cache = cache ?? ProfileLocalCache(),
        _getUserProfileUseCase = getUserProfileUseCase ??
            GetUserProfileUseCase(
                repository: profileRepository ?? ProfileRepositoryImpl()),
        _getAnalysisHistoryUseCase = getAnalysisHistoryUseCase ??
            GetAnalysisHistoryUseCase(
                repository: profileRepository ?? ProfileRepositoryImpl()),
        _updateUserProfileUseCase = updateUserProfileUseCase ??
            UpdateUserProfileUseCase(
                repository: profileRepository ?? ProfileRepositoryImpl()),
        _uploadAvatarUseCase = uploadAvatarUseCase ??
            UploadAvatarUseCase(
                repository: profileRepository ?? ProfileRepositoryImpl()),
        _changePasswordUseCase = changePasswordUseCase ??
            ChangePasswordUseCase(
                repository: profileRepository ?? ProfileRepositoryImpl()) {
    loadUserProfile();
    _authSubscription = AuthSessionObserver.instance.events.listen((event) {
      if (event == AuthSessionEvent.signedIn) {
        loadUserProfile(forceRefresh: true);
      } else if (event == AuthSessionEvent.signedOut) {
        _userProfile = null;
        _history.clear();
        _filteredHistory.clear();
        notifyListeners();
      }
    });
  }

  final ProfileLocalCache _cache;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final GetAnalysisHistoryUseCase _getAnalysisHistoryUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final UploadAvatarUseCase _uploadAvatarUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  StreamSubscription<AuthSessionEvent>? _authSubscription;

  UserProfile? _userProfile;
  final List<SkinAnalysisHistory> _history = [];
  final List<SkinAnalysisHistory> _filteredHistory = [];

  bool _isLoading = false;
  bool _isUpdating = false;
  bool _historyLoading = false;
  bool _hasMoreHistory = true;
  int _currentPage = 1;
  final int _pageSize = 10;
  String? _errorMessage;
  String _searchQuery = '';

  UserProfile? get userProfile => _userProfile;
  List<SkinAnalysisHistory> get skinAnalysisHistory => _searchQuery.isEmpty
      ? List.unmodifiable(_history)
      : List.unmodifiable(_filteredHistory);
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  bool get isHistoryLoading => _historyLoading;
  bool get hasMoreHistory => _hasMoreHistory;
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> loadUserProfile({bool forceRefresh = false}) async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (DemoSession.isActive) {
      _applyDemoData();
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (!forceRefresh) {
      await _loadFromCache();
    }

    try {
      _userProfile = await _getUserProfileUseCase.execute();
      await _cache.cacheProfile(_userProfile!);
      await _initialiseHistory();
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFromCache() async {
    final cachedProfile = await _cache.readProfile();
    final cachedHistory = await _cache.readHistory();
    if (cachedProfile != null) {
      _userProfile = cachedProfile;
      _history
        ..clear()
        ..addAll(cachedHistory);
      _filteredHistory
        ..clear()
        ..addAll(cachedHistory);
      notifyListeners();
    }
  }

  Future<void> _initialiseHistory() async {
    if (DemoSession.isActive) {
      _applyDemoData();
      return;
    }
    try {
      _historyLoading = true;
      notifyListeners();
      final entries = await _getAnalysisHistoryUseCase.execute(
        page: _currentPage,
        pageSize: _pageSize,
      );
      _history
        ..clear()
        ..addAll(entries);
      _filteredHistory
        ..clear()
        ..addAll(entries);
      _hasMoreHistory = entries.length == _pageSize;
      await _cache.cacheHistory(_history);
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    } finally {
      _historyLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSkinAnalysisHistory({bool loadMore = false}) async {
    if (_historyLoading) return;
    if (loadMore && !_hasMoreHistory) return;

    _historyLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (DemoSession.isActive) {
      if (!loadMore) {
        _applyDemoData();
      }
      _historyLoading = false;
      notifyListeners();
      return;
    }

    try {
      final nextPage = loadMore ? _currentPage + 1 : 1;
      final entries = await _getAnalysisHistoryUseCase.execute(
        page: nextPage,
        pageSize: _pageSize,
      );

      if (loadMore) {
        _history.addAll(entries);
      } else {
        _history
          ..clear()
          ..addAll(entries);
      }

      _applySearchFilter(_searchQuery);
      _currentPage = nextPage;
      _hasMoreHistory = entries.length == _pageSize;
      await _cache.cacheHistory(_history);
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    } finally {
      _historyLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshSkinAnalysisHistory() async {
    _currentPage = 1;
    _hasMoreHistory = true;
    await loadSkinAnalysisHistory(loadMore: false);
  }

  Future<bool> updateUserProfile({
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    if (DemoSession.isActive) {
      final current = _userProfile ?? DemoSession.profile;
      final updated = current.copyWith(
        fullName: fullName ?? current.fullName,
        phoneNumber: phoneNumber ?? current.phoneNumber,
        avatarUrl: avatarUrl ?? current.avatarUrl,
      );
      _userProfile = updated;
      DemoSession.updateProfile(updated);
      _isUpdating = false;
      notifyListeners();
      return true;
    }

    try {
      final payload = <String, dynamic>{};
      if (fullName != null) payload['fullName'] = fullName;
      if (phoneNumber != null) payload['phoneNumber'] = phoneNumber;
      if (avatarUrl != null) payload['avatarUrl'] = avatarUrl;

      _userProfile = await _updateUserProfileUseCase.execute(payload);
      await _cache.cacheProfile(_userProfile!);
      return true;
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<bool> uploadAvatar(String filePath) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    if (DemoSession.isActive) {
      final current = _userProfile ?? DemoSession.profile;
      final updated = current.copyWith(avatarUrl: filePath);
      _userProfile = updated;
      DemoSession.updateProfile(updated);
      _isUpdating = false;
      notifyListeners();
      return true;
    }

    try {
      _userProfile = await _uploadAvatarUseCase.execute(filePath);
      await _cache.cacheProfile(_userProfile!);
      return true;
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    if (DemoSession.isActive) {
      _isUpdating = false;
      notifyListeners();
      return true;
    }

    try {
      await _changePasswordUseCase.execute(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return true;
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    _applySearchFilter(_searchQuery);
    notifyListeners();
  }

  void _applySearchFilter(String term) {
    _filteredHistory
      ..clear()
      ..addAll(
        _history.where(
          (entry) =>
              term.isEmpty ||
              entry.id.toLowerCase().contains(term.toLowerCase()) ||
              entry.status?.toLowerCase().contains(term.toLowerCase()) ==
                  true ||
              entry.createdAt
                  .toIso8601String()
                  .toLowerCase()
                  .contains(term.toLowerCase()),
        ),
      );
  }

  void _applyDemoData() {
    _userProfile = DemoSession.profile;
    final demoHistory = DemoSession.history;
    _history
      ..clear()
      ..addAll(demoHistory);
    _filteredHistory
      ..clear()
      ..addAll(demoHistory);
    _hasMoreHistory = false;
  }

  void _handleError(Object error, StackTrace stackTrace) {
    ErrorHandler.logError(error, stackTrace);
    final message = ErrorHandler.getUserMessage(error);
    _errorMessage = message;
    GlobalErrorNotifier.report(message);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
