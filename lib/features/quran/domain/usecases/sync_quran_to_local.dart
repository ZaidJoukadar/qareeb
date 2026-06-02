import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class SyncQuranToLocal {
  const SyncQuranToLocal(this._repository);

  final QuranRepository _repository;

  Future<void> call({required String translationEdition}) {
    return _repository.syncQuranToLocal(translationEdition: translationEdition);
  }
}
