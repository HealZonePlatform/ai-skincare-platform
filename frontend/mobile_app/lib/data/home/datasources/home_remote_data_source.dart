import 'package:ai_skincare_platform/api/analyses_api_service.dart';
import 'package:ai_skincare_platform/data/home/home_mock_data.dart';
import 'package:ai_skincare_platform/domain/home/entities/home_dashboard.dart';

/// Placeholder datasource until real backend endpoint is available.
/// TODO: Replace stubbed mock with actual API response mapping when backend opens.
class HomeRemoteDataSource {
  HomeRemoteDataSource({AnalysesApiService? apiService})
      : _apiService = apiService ?? AnalysesApiService();

  // ignore: unused_field
  final AnalysesApiService _apiService;

  Future<HomeDashboard> fetchDashboard() async {
    // TODO: call real dashboard endpoint via _apiService when ready.
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return HomeMockData.dashboard;
  }
}
