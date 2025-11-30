import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/data/home/repositories/home_repository_impl.dart';
import 'package:ai_skincare_platform/domain/home/entities/home_dashboard.dart';
import 'package:ai_skincare_platform/domain/home/repositories/home_repository.dart';
import 'package:ai_skincare_platform/domain/home/usecases/get_home_dashboard_usecase.dart';
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

  HomeDashboard? get dashboard => _dashboard;
  HomeLoadStatus get status => _status;
  bool get isLoading => _status == HomeLoadStatus.loading;
  String? get error => _error;

  Future<void> loadDashboard({bool forceRefresh = false}) async {
    if (_status == HomeLoadStatus.loading) {
      return;
    }
    if (_dashboard != null && !forceRefresh) {
      return;
    }

    _status = HomeLoadStatus.loading;
    _error = null;
    notifyListeners();

    try {
      // TODO: add connectivity check + refresh token flow when backend is live.
      final result = await _getHomeDashboardUseCase.execute();
      _dashboard = result;
      _status = HomeLoadStatus.loaded;
    } catch (error, stackTrace) {
      ErrorHandler.logError(error, stackTrace);
      _error = ErrorHandler.getUserMessage(error);
      _status = HomeLoadStatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> retry() {
    return loadDashboard(forceRefresh: true);
  }
}
