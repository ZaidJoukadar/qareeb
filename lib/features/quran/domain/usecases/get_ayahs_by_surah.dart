import 'package:qareeb/features/quran/domain/entities/ayah.dart';
import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class GetAyahsBySurah {
  const GetAyahsBySurah(this._repository);

  final QuranRepository _repository;

  Future<List<Ayah>> call(int surahNumber) =>
      _repository.getAyahsBySurah(surahNumber);
}
