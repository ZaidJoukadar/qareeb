import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class ResolveAyahAudioSource {
  const ResolveAyahAudioSource(this._repository);

  final QuranRepository _repository;

  Future<String> call({
    required int surahNumber,
    required int ayahNumber,
  }) {
    return _repository.resolveAyahAudioSource(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
  }
}
