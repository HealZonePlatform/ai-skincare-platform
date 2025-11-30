import 'package:ai_skincare_platform/data/home/datasources/home_remote_data_source.dart';
import 'package:ai_skincare_platform/domain/home/entities/home_dashboard.dart';
import 'package:ai_skincare_platform/domain/home/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({HomeRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? HomeRemoteDataSource();

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<HomeDashboard> fetchDashboard() {
    return _remoteDataSource.fetchDashboard();
  }
}
