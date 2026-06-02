import 'package:qareeb/features/quran/domain/repositories/reading_progress_repository.dart';

class ToggleAyahRead {
  const ToggleAyahRead(this._repository);

  final ReadingProgressRepository _repository;

  Future<bool> call({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final isRead = await _repository.isAyahRead(surahNumber, ayahNumber);
    await _repository.setAyahRead(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      isRead: !isRead,
    );
    return !isRead;
  }
}
