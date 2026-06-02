import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class ClearQuranAudioUrlCache {
  const ClearQuranAudioUrlCache(this._repository);

  final QuranRepository _repository;

  void call() => _repository.clearAudioUrlCache();
}
