import 'package:ai_skincare_platform/domain/home/entities/home_dashboard.dart';
import 'package:ai_skincare_platform/domain/home/repositories/home_repository.dart';

class GetHomeDashboardUseCase {
  const GetHomeDashboardUseCase({required HomeRepository repository})
      : _repository = repository;

  final HomeRepository _repository;

  Future<HomeDashboard> execute() {
    return _repository.fetchDashboard();
  }
}
