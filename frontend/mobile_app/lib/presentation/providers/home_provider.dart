import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/data/home/repositories/home_repository_impl.dart';
import 'package:ai_skincare_platform/domain/home/entities/home_dashboard.dart';
import 'package:ai_skincare_platform/domain/home/repositories/home_repository.dart';
import 'package:ai_skincare_platform/domain/home/usecases/get_home_dashboard_usecase.dart';
import 'package:ai_skincare_platform/core/network/connectivity_service.dart';
import 'package:ai_skincare_platform/utils/error_handler.dart';

enum HomeLoadStatus { idle, loading, loaded, error }

class HomeProvider with ChangeNotifier {
  HomeProvider({
    GetHomeDashboardUseCase? getHomeDashboardUseCase,
    HomeRepository? homeRepository,
  }) : _getHomeDashboardUseCase = getHomeDashboardUseCase ??
            GetHomeDashboardUseCase(
              repository: homeRepository ?? HomeRepositoryImpl(),
            );

  final GetHomeDashboardUseCase _getHomeDashboardUseCase;

  HomeDashboard? _dashboard;
  HomeLoadStatus _status = HomeLoadStatus.idle;
  String? _error;
  bool _usingCache = false;

  HomeDashboard? get dashboard => _dashboard;
  HomeLoadStatus get status => _status;
  bool get isLoading => _status == HomeLoadStatus.loading;
  String? get error => _error;
  bool get usingCache => _usingCache;

  Future<void> loadDashboard({bool forceRefresh = false}) async {
    if (_status == HomeLoadStatus.loading) {
      return;
    }
    final connectivity = ConnectivityService.instance;
    final isOffline = connectivity.isOffline;
    if (_dashboard != null && !forceRefresh) {
      if (isOffline) {
        _usingCache = true;
        _status = HomeLoadStatus.loaded;
        _error = 'Offline: showing last saved dashboard.';
        notifyListeners();
        connectivity.registerRetry(
          'home_dashboard',
          () => loadDashboard(forceRefresh: true),
        );
      }
      return;
    }

    _status = HomeLoadStatus.loading;
    _error = null;
    _usingCache = false;
    notifyListeners();

    try {
      final result = await _getHomeDashboardUseCase.execute();
      _dashboard = result;
      _status = HomeLoadStatus.loaded;
      _usingCache = isOffline;
      if (isOffline) {
        _error = 'Offline: showing cached dashboard.';
        connectivity.registerRetry(
            'home_dashboard', () => loadDashboard(forceRefresh: true));
      } else {
        connectivity.clearRetry('home_dashboard');
      }
    } catch (error, stackTrace) {
      ErrorHandler.logError(error, stackTrace);
      final normalized = ErrorHandler.normalize(error);
      _error = ErrorHandler.getUserMessage(normalized);
      _status = HomeLoadStatus.error;
      if (isOffline) {
        connectivity.registerRetry(
            'home_dashboard', () => loadDashboard(forceRefresh: true));
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> retry() {
    return loadDashboard(forceRefresh: true);
  }
}
