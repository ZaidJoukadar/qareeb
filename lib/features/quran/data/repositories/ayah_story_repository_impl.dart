import 'package:qareeb/core/monitoring/run_guarded.dart';
import 'package:qareeb/core/monitoring/sentry_report.dart';
import 'package:qareeb/features/quran/data/datasources/ayah_story_remote_data_source.dart';
import 'package:qareeb/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:qareeb/features/quran/domain/entities/ayah_story.dart';
import 'package:qareeb/features/quran/domain/repositories/ayah_story_repository.dart';

class AyahStoryRepositoryImpl implements AyahStoryRepository {
  AyahStoryRepositoryImpl(this._remote, this._local);

  final AyahStoryRemoteDataSource _remote;
  final QuranLocalDataSource _local;

  @override
  Future<AyahStory> getAyahStory({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  }) {
    return runGuarded(
      () async {
        final surah = await _local.getSurahByNumber(surahNumber);
        if (surah == null) {
          throw StateError('Surah $surahNumber not found locally');
        }

        final ayahs = await _local.getAyahsBySurah(surahNumber);
        final ayahIndex = ayahs.indexWhere(
          (item) => item.ayahNumber == ayahNumber,
        );
        if (ayahIndex == -1) {
          throw StateError('Ayah $surahNumber:$ayahNumber not found locally');
        }

        final ayah = ayahs[ayahIndex];

        return _remote.fetchAyahStory(
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          languageCode: languageCode,
          surahNameArabic: surah.nameArabic,
          surahNameEnglish: surah.nameEnglish,
          ayahTextArabic: ayah.textArabic,
          ayahTranslation: ayah.textTranslation,
        );
      },
      report: SentryReport(
        feature: 'quran',
        action: 'get_ayah_story',
        extra: {
          'surah': surahNumber,
          'ayah': ayahNumber,
          'language': languageCode,
        },
      ),
    );
  }
}
