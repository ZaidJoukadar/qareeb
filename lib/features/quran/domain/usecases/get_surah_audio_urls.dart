import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class GetSurahAudioUrls {
  const GetSurahAudioUrls(this._repository);

  final QuranRepository _repository;

  Future<Map<int, String>> call(int surahNumber) {
    return _repository.getSurahAudioUrls(surahNumber);
  }
}
