import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class GetSurahs {
  const GetSurahs(this._repository);

  final QuranRepository _repository;

  Future<List<Surah>> call() => _repository.getSurahs();
}
