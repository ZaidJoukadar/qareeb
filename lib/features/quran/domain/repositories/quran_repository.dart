import 'package:qareeb/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:qareeb/features/quran/domain/entities/ayah.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';

abstract class QuranRepository {
  Future<QuranSyncStatus> getSyncStatus();

  Future<int> getCompletedSurahs();

  Future<void> syncQuranToLocal({required String translationEdition});

  Future<List<Surah>> getSurahs();

  Future<List<Ayah>> getAyahsBySurah(int surahNumber);

  Future<String?> getAyahAudioUrl({
    required int surahNumber,
    required int ayahNumber,
  });
}
