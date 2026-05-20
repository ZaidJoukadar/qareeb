import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class GetSyncProgress {
  const GetSyncProgress(this._repository);

  final QuranRepository _repository;

  Future<int> call() => _repository.getCompletedSurahs();
}
