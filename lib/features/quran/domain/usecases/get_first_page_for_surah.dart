import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class GetFirstPageForSurah {
  const GetFirstPageForSurah(this._repository);

  final QuranRepository _repository;

  Future<int?> call(int surahNumber) {
    return _repository.getFirstPageForSurah(surahNumber);
  }
}
