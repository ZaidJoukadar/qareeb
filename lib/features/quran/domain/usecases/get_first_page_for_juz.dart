import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class GetFirstPageForJuz {
  const GetFirstPageForJuz(this._repository);

  final QuranRepository _repository;

  Future<int?> call(int juzNumber) {
    return _repository.getFirstPageForJuz(juzNumber);
  }
}
