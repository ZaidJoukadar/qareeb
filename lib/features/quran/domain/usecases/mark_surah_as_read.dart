import 'package:qareeb/features/quran/domain/repositories/reading_progress_repository.dart';

class MarkSurahAsRead {
  const MarkSurahAsRead(this._repository);

  final ReadingProgressRepository _repository;

  Future<void> call({
    required int surahNumber,
    required int ayahCount,
  }) {
    return _repository.markSurahAsRead(
      surahNumber: surahNumber,
      ayahCount: ayahCount,
    );
  }
}
