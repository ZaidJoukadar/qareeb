import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class GetSurahByNumber {
  const GetSurahByNumber(this._repository);

  final QuranRepository _repository;

  Future<Surah?> call(int number) => _repository.getSurahByNumber(number);
}
