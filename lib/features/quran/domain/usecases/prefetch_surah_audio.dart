import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class PrefetchSurahAudio {
  const PrefetchSurahAudio(this._repository);

  final QuranRepository _repository;

  Future<void> call({
    required int surahNumber,
    required int fromAyah,
    Object? cancelToken,
  }) {
    return _repository.prefetchSurahAudio(
      surahNumber: surahNumber,
      fromAyah: fromAyah,
      cancelToken: cancelToken,
    );
  }
}
