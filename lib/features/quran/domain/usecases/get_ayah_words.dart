import 'package:qareeb/features/quran/domain/entities/ayah_word.dart';
import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class GetAyahWords {
  const GetAyahWords(this._repository);

  final QuranRepository _repository;

  Future<List<AyahWord>> call({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  }) {
    return _repository.getAyahWords(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      languageCode: languageCode,
    );
  }
}
