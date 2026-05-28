import 'package:dio/dio.dart';
import 'package:qareeb/core/constants/quran_editions.dart';
import 'package:qareeb/core/monitoring/run_guarded.dart';
import 'package:qareeb/core/quran/quran_audio_reciter_settings.dart';
import 'package:qareeb/core/monitoring/sentry_report.dart';
import 'package:qareeb/features/quran/data/datasources/quran_audio_cache_data_source.dart';
import 'package:qareeb/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:qareeb/features/quran/data/datasources/quran_remote_data_source.dart';
import 'package:qareeb/features/quran/data/models/ayah_dto.dart';
import 'package:qareeb/features/quran/domain/entities/ayah.dart';
import 'package:qareeb/features/quran/domain/entities/ayah_insight.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class QuranRepositoryImpl implements QuranRepository {
  QuranRepositoryImpl(
    this._remote,
    this._local,
    this._audioCache,
    this._audioReciterSettings,
  );

  final QuranRemoteDataSource _remote;
  final QuranLocalDataSource _local;
  final QuranAudioCacheDataSource _audioCache;
  final QuranAudioReciterSettings _audioReciterSettings;

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
  Future<Surah?> getSurahByNumber(int number) => runGuarded(
    () => _local.getSurahByNumber(number),
    report: SentryReport(
      feature: 'quran',
      action: 'get_surah_by_number',
      extra: {'surah': number},
    ),
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

  @override
  Future<List<Ayah>> getAyahsByPage(int page) => runGuarded(
    () => _local.getAyahsByPage(page),
    report: SentryReport(
      feature: 'quran',
      action: 'get_ayahs_by_page',
      extra: {'page': page},
    ),
  );

  @override
  Future<int> getMaxMushafPage() => runGuarded(
    _local.getMaxMushafPage,
    report: const SentryReport(feature: 'quran', action: 'get_max_mushaf_page'),
  );

  @override
  Future<int?> getFirstPageForSurah(int surahNumber) => runGuarded(
    () => _local.getFirstPageForSurah(surahNumber),
    report: SentryReport(
      feature: 'quran',
      action: 'get_first_page_for_surah',
      extra: {'surah': surahNumber},
    ),
  );

  @override
  Future<int?> getFirstPageForJuz(int juzNumber) => runGuarded(
    () => _local.getFirstPageForJuz(juzNumber),
    report: SentryReport(
      feature: 'quran',
      action: 'get_first_page_for_juz',
      extra: {'juz': juzNumber},
    ),
  );

  @override
  Future<Map<int, int>> getSurahCountByJuz() => runGuarded(
    _local.getSurahCountByJuz,
    report: const SentryReport(
      feature: 'quran',
      action: 'get_surah_count_by_juz',
    ),
  );

  final Map<int, Map<int, String>> _audioUrlCache = {};
  String? _audioUrlCacheEdition;

  void _ensureAudioUrlCacheEdition() {
    final edition = _audioReciterSettings.editionIdentifier;
    if (_audioUrlCacheEdition == edition) return;
    _audioUrlCache.clear();
    _audioUrlCacheEdition = edition;
  }

  Future<Map<int, String>> _loadSurahAudioUrls(int surahNumber) async {
    _ensureAudioUrlCacheEdition();
    final cached = _audioUrlCache[surahNumber];
    if (cached != null) return cached;

    final ayahs = await _remote.fetchSurahAudioAyahs(surahNumber);
    final urlMap = _audioUrlMapFrom(ayahs);
    _audioUrlCache[surahNumber] = urlMap;
    return urlMap;
  }

  Future<String?> _urlForAyah({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    _ensureAudioUrlCacheEdition();
    final cached = _audioUrlCache[surahNumber]?[ayahNumber];
    if (cached != null) return cached;

    final single = await _remote.fetchAyahAudioUrl(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    if (single != null) {
      _audioUrlCache.putIfAbsent(surahNumber, () => {})[ayahNumber] = single;
      return single;
    }

    final urlMap = await _loadSurahAudioUrls(surahNumber);
    return urlMap[ayahNumber];
  }

  @override
  Future<String?> getAyahAudioUrl({
    required int surahNumber,
    required int ayahNumber,
  }) => runGuarded(
    () => _urlForAyah(surahNumber: surahNumber, ayahNumber: ayahNumber),
    report: SentryReport(
      feature: 'quran',
      action: 'get_ayah_audio_url',
      extra: {'surah': surahNumber, 'ayah': ayahNumber},
    ),
  );

  @override
  Future<Map<int, String>> getSurahAudioUrls(int surahNumber) => runGuarded(
    () => _loadSurahAudioUrls(surahNumber),
    report: SentryReport(
      feature: 'quran',
      action: 'get_surah_audio_urls',
      extra: {'surah': surahNumber},
    ),
  );

  @override
  Future<String> resolveAyahAudioSource({
    required int surahNumber,
    required int ayahNumber,
  }) => runGuarded(
    () async {
      final cached = await _audioCache.cachedFile(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
      );
      if (cached != null) return cached.path;

      final url = await _urlForAyah(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
      );
      if (url == null) {
        throw StateError(
          'Audio not available for $surahNumber:$ayahNumber',
        );
      }

      final file = await _audioCache.downloadToCache(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        url: url,
      );
      return file.path;
    },
    report: SentryReport(
      feature: 'quran',
      action: 'resolve_ayah_audio_source',
      extra: {'surah': surahNumber, 'ayah': ayahNumber},
    ),
  );

  @override
  Future<void> prefetchSurahAudio({
    required int surahNumber,
    required int fromAyah,
    Object? cancelToken,
  }) => runGuarded(
    () async {
      final urls = await _loadSurahAudioUrls(surahNumber);
      await _audioCache.prefetchAyahs(
        surahNumber: surahNumber,
        urls: urls,
        fromAyah: fromAyah,
        cancelToken: cancelToken is CancelToken ? cancelToken : null,
      );
    },
    report: SentryReport(
      feature: 'quran',
      action: 'prefetch_surah_audio',
      extra: {'surah': surahNumber, 'fromAyah': fromAyah},
    ),
  );

  @override
  Future<AyahInsight> getAyahInsight({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  }) => runGuarded(
    () => _remote.fetchAyahInsight(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      languageCode: languageCode,
    ),
    report: SentryReport(
      feature: 'quran',
      action: 'get_ayah_insight',
      extra: {
        'surah': surahNumber,
        'ayah': ayahNumber,
        'language': languageCode,
      },
    ),
  );
}
