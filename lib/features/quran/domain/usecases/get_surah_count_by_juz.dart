import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class GetSurahCountByJuz {
  const GetSurahCountByJuz(this._repository);

  final QuranRepository _repository;

  Future<Map<int, int>> call() => _repository.getSurahCountByJuz();
}
