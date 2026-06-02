import 'package:qareeb/features/quran/domain/entities/ayah.dart';
import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class GetAyahsByPage {
  const GetAyahsByPage(this._repository);

  final QuranRepository _repository;

  Future<List<Ayah>> call(int page) => _repository.getAyahsByPage(page);
}
