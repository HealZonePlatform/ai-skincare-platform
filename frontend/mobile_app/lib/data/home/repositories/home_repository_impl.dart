import 'package:ai_skincare_platform/data/home/datasources/home_local_cache.dart';
import 'package:ai_skincare_platform/data/home/datasources/home_remote_data_source.dart';
import 'package:ai_skincare_platform/data/home/models/home_dashboard_dto.dart';
import 'package:ai_skincare_platform/domain/home/entities/home_dashboard.dart';
import 'package:ai_skincare_platform/domain/home/repositories/home_repository.dart';
import 'package:ai_skincare_platform/utils/exceptions.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    HomeRemoteDataSource? remoteDataSource,
    HomeLocalCache? cache,
  })  : _remoteDataSource = remoteDataSource ?? HomeRemoteDataSource(),
        _cache = cache ?? HomeLocalCache();

  final HomeRemoteDataSource _remoteDataSource;
  final HomeLocalCache _cache;

  @override
  Future<HomeDashboard> fetchDashboard() async {
    try {
      final dto = await _remoteDataSource.fetchDashboardDto();
      await _cache.saveDashboard(dto.toJson());
      return dto.toEntity();
    } on AppException {
      final cached = await _loadCachedDashboard();
      if (cached != null) return cached;
      rethrow;
    } catch (_) {
      final cached = await _loadCachedDashboard();
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<HomeDashboard?> _loadCachedDashboard() async {
    final cachedJson = await _cache.readDashboard();
    if (cachedJson == null) {
      return null;
    }
    try {
      final dto = HomeDashboardDto.fromJson(cachedJson);
      return dto.toEntity();
    } catch (_) {
      return null;
    }
  }
}
