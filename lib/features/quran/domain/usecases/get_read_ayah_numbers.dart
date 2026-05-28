import 'package:qareeb/features/quran/domain/repositories/reading_progress_repository.dart';

class GetReadAyahNumbers {
  const GetReadAyahNumbers(this._repository);

  final ReadingProgressRepository _repository;

  Future<Set<int>> call(int surahNumber) {
    return _repository.getReadAyahNumbers(surahNumber);
  }
}
