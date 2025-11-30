import 'package:ai_skincare_platform/domain/home/entities/home_dashboard.dart';

abstract class HomeRepository {
  Future<HomeDashboard> fetchDashboard();
}
