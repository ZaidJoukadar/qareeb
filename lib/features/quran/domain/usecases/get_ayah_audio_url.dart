import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class GetAyahAudioUrl {
  const GetAyahAudioUrl(this._repository);

  final QuranRepository _repository;

  Future<String?> call({
    required int surahNumber,
    required int ayahNumber,
  }) {
    return _repository.getAyahAudioUrl(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
  }
}
