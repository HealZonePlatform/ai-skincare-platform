// lib/domain/profile/usecases/get_analysis_history_usecase.dart

import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';
import 'package:ai_skincare_platform/domain/profile/repositories/profile_repository.dart';

class GetAnalysisHistoryUseCase {
  final ProfileRepository _repository;

  const GetAnalysisHistoryUseCase({
    required ProfileRepository repository,
  }) : _repository = repository;

  Future<List<SkinAnalysisHistory>> execute({
    int page = 1,
    int pageSize = 10,
  }) {
    return _repository.fetchAnalysisHistory(page: page, pageSize: pageSize);
  }
}
