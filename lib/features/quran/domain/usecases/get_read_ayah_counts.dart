import 'package:qareeb/features/quran/domain/repositories/reading_progress_repository.dart';

class GetReadAyahCounts {
  const GetReadAyahCounts(this._repository);

  final ReadingProgressRepository _repository;

  Future<Map<int, int>> call() => _repository.getReadAyahCountsBySurah();
}
