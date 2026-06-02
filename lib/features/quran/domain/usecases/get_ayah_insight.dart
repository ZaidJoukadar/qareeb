import 'package:qareeb/features/quran/domain/entities/ayah_insight.dart';
import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class GetAyahInsight {
  const GetAyahInsight(this._repository);

  final QuranRepository _repository;

  Future<AyahInsight> call({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  }) {
    return _repository.getAyahInsight(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      languageCode: languageCode,
    );
  }
}
