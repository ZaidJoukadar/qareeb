import 'package:qareeb/core/constants/quran_editions.dart';
import 'package:qareeb/core/monitoring/run_guarded.dart';
import 'package:qareeb/core/monitoring/sentry_report.dart';
import 'package:qareeb/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:qareeb/features/quran/data/datasources/quran_remote_data_source.dart';
import 'package:qareeb/features/quran/data/models/ayah_dto.dart';
import 'package:qareeb/features/quran/domain/entities/ayah.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class QuranRepositoryImpl implements QuranRepository {
  QuranRepositoryImpl(this._remote, this._local);

  final QuranRemoteDataSource _remote;
  final QuranLocalDataSource _local;

  static const int _totalSurahs = 114;

  @override
  Future<QuranSyncStatus> getSyncStatus() => runGuarded(
    _local.getSyncStatus,
    report: const SentryReport(feature: 'quran', action: 'get_sync_status'),
  );

  @override
  Future<int> getCompletedSurahs() => runGuarded(
    _local.getCompletedSurahs,
    report: const SentryReport(
      feature: 'quran',
      action: 'get_completed_surahs',
    ),
  );

  @override
  Future<void> syncQuranToLocal({required String translationEdition}) =>
      runGuarded(
        () async {
          final textEdition = QuranEditions.arabicText;
          final startSurah = await _local.getCompletedSurahs();

          try {
            await _prepareSync(
              startSurah: startSurah,
              textEdition: textEdition,
              translationEdition: translationEdition,
            );
            await _syncSurahsSequentially(
              fromSurah: startSurah + 1,
              translationEdition: translationEdition,
            );
            await _local.markSyncCompleted(
              textEdition: textEdition,
              translationEdition: translationEdition,
            );
          } catch (error) {
            await _local.markSyncFailed(error.toString());
            rethrow;
          }
        },
        report: const SentryReport(feature: 'quran', action: 'sync_quran'),
      );

  Future<void> _prepareSync({
    required int startSurah,
    required String textEdition,
    required String translationEdition,
  }) async {
    await _local.markSyncInProgress(
      textEdition: textEdition,
      translationEdition: translationEdition,
    );

    if (startSurah != 0) return;

    final summaries = await _remote.fetchSurahList();
    await _local.saveSurahList(summaries);
  }

  List<int> _surahNumbersFrom(int firstSurah) => List.generate(
    _totalSurahs - firstSurah + 1,
    (index) => firstSurah + index,
  );

  Future<void> _syncSurahsSequentially({
    required int fromSurah,
    required String translationEdition,
  }) {
    return _surahNumbersFrom(fromSurah).fold<Future<void>>(
      Future.value(),
      (previous, surahNumber) => previous.then(
        (_) => _downloadAndSaveSurah(
          surahNumber: surahNumber,
          translationEdition: translationEdition,
        ),
      ),
    );
  }

  Future<void> _downloadAndSaveSurah({
    required int surahNumber,
    required String translationEdition,
  }) async {
    final editions = await _remote.fetchSurahTextEditions(
      surahNumber: surahNumber,
      translationEdition: translationEdition,
    );

    final inserts = _ayahInsertsFrom(
      surahNumber: surahNumber,
      arabicAyahs: editions.arabic.ayahs,
      translationAyahs: editions.translation.ayahs,
    );

    await _local.saveAyahsForSurah(surahNumber: surahNumber, ayahs: inserts);
    await _local.updateSyncProgress(completedSurahs: surahNumber);
  }

  List<AyahInsert> _ayahInsertsFrom({
    required int surahNumber,
    required List<AyahDto> arabicAyahs,
    required List<AyahDto> translationAyahs,
  }) {
    return List.generate(
      arabicAyahs.length,
      (index) => _ayahInsertFrom(
        surahNumber: surahNumber,
        arabic: arabicAyahs[index],
        translation: translationAyahs[index],
      ),
    );
  }

  AyahInsert _ayahInsertFrom({
    required int surahNumber,
    required AyahDto arabic,
    required AyahDto translation,
  }) {
    return AyahInsert(
      surahNumber: surahNumber,
      ayahNumber: arabic.numberInSurah,
      globalAyahNumber: arabic.number,
      textArabic: arabic.text,
      textTranslation: translation.text,
      page: arabic.page,
      juz: arabic.juz,
      hizbQuarter: arabic.hizbQuarter,
      ruku: arabic.ruku,
      sajda: arabic.sajda,
    );
  }

  Map<int, String> _audioUrlMapFrom(List<AyahDto> ayahs) {
    return Map.fromEntries(
      ayahs
          .where((ayah) => ayah.audio != null)
          .map(
            (ayah) => MapEntry(ayah.numberInSurah, ayah.audio!),
          ),
    );
  }

  @override
  Future<List<Surah>> getSurahs() => runGuarded(
    _local.getSurahs,
    report: const SentryReport(feature: 'quran', action: 'get_surahs'),
  );

  @override
  Future<List<Ayah>> getAyahsBySurah(int surahNumber) => runGuarded(
    () => _local.getAyahsBySurah(surahNumber),
    report: SentryReport(
      feature: 'quran',
      action: 'get_ayahs_by_surah',
      extra: {'surah': surahNumber},
    ),
  );

  final Map<int, Map<int, String>> _audioUrlCache = {};

  @override
  Future<String?> getAyahAudioUrl({
    required int surahNumber,
    required int ayahNumber,
  }) => runGuarded(
    () async {
      final cached = _audioUrlCache[surahNumber]?[ayahNumber];
      if (cached != null) return cached;

      final ayahs = await _remote.fetchSurahAudioAyahs(surahNumber);
      final urlMap = _audioUrlMapFrom(ayahs);
      _audioUrlCache[surahNumber] = urlMap;
      return urlMap[ayahNumber];
    },
    report: SentryReport(
      feature: 'quran',
      action: 'get_ayah_audio_url',
      extra: {'surah': surahNumber, 'ayah': ayahNumber},
    ),
  );
}
