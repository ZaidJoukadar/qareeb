import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class GetMushafPageCount {
  const GetMushafPageCount(this._repository);

  final QuranRepository _repository;

  Future<int> call() => _repository.getMaxMushafPage();
}
