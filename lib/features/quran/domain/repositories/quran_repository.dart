import 'package:qareeb/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:qareeb/features/quran/domain/entities/ayah.dart';
import 'package:qareeb/features/quran/domain/entities/ayah_insight.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';

abstract class QuranRepository {
  Future<QuranSyncStatus> getSyncStatus();

  Future<int> getCompletedSurahs();

  Future<void> syncQuranToLocal({required String translationEdition});

  Future<List<Surah>> getSurahs();

  Future<Surah?> getSurahByNumber(int number);

  Future<List<Ayah>> getAyahsBySurah(int surahNumber);

  Future<List<Ayah>> getAyahsByPage(int page);

  Future<int> getMaxMushafPage();

  Future<int?> getFirstPageForSurah(int surahNumber);

  Future<int?> getFirstPageForJuz(int juzNumber);

  Future<Map<int, int>> getSurahCountByJuz();

  Future<String?> getAyahAudioUrl({
    required int surahNumber,
    required int ayahNumber,
  });

  Future<Map<int, String>> getSurahAudioUrls(int surahNumber);

  Future<String> resolveAyahAudioSource({
    required int surahNumber,
    required int ayahNumber,
  });

  Future<void> prefetchSurahAudio({
    required int surahNumber,
    required int fromAyah,
    Object? cancelToken,
  });

  Future<AyahInsight> getAyahInsight({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  });
}
