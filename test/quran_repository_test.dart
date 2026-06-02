import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qareeb/features/quran/data/datasources/ayah_insight_cache_local_data_source.dart';
import 'package:qareeb/features/quran/data/datasources/quran_audio_cache_data_source.dart';
import 'package:qareeb/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:qareeb/features/quran/data/datasources/quran_remote_data_source.dart';
import 'package:qareeb/features/quran/data/models/ayah_dto.dart';
import 'package:qareeb/features/quran/data/models/surah_detail_dto.dart';
import 'package:qareeb/features/quran/data/models/surah_summary_dto.dart';
import 'package:qareeb/core/quran/quran_audio_reciter_settings.dart';
import 'package:qareeb/features/quran/data/repositories/quran_repository_impl.dart';

class _MockRemote extends Mock implements QuranRemoteDataSource {}

class _MockLocal extends Mock implements QuranLocalDataSource {}

class _MockAudioCache extends Mock implements QuranAudioCacheDataSource {}

class _MockInsightCache extends Mock implements AyahInsightCacheLocalDataSource {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late _MockAudioCache audioCache;
  late _MockInsightCache insightCache;
  late QuranRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    audioCache = _MockAudioCache();
    insightCache = _MockInsightCache();
    repository = QuranRepositoryImpl(
      remote,
      local,
      audioCache,
      insightCache,
      QuranAudioReciterSettings(),
    );
  });

  test('sync saves surah list then ayahs for each surah', () async {
    when(() => local.getCompletedSurahs()).thenAnswer((_) async => 0);
    when(
      () => local.markSyncInProgress(
        textEdition: any(named: 'textEdition'),
        translationEdition: any(named: 'translationEdition'),
      ),
    ).thenAnswer((_) async {});
    when(() => remote.fetchSurahList()).thenAnswer(
      (_) async => [
        const SurahSummaryDto(
          number: 1,
          name: 'الفاتحة',
          englishName: 'Al-Faatiha',
          englishNameTranslation: 'The Opening',
          numberOfAyahs: 2,
          revelationType: 'Meccan',
        ),
      ],
    );
    when(() => local.saveSurahList(any())).thenAnswer((_) async {});
    when(
      () => remote.fetchSurahTextEditions(
        surahNumber: any(named: 'surahNumber'),
        translationEdition: any(named: 'translationEdition'),
      ),
    ).thenAnswer(
      (_) async => (
        arabic: SurahDetailDto(
          number: 1,
          name: 'الفاتحة',
          englishName: 'Al-Faatiha',
          englishNameTranslation: 'The Opening',
          revelationType: 'Meccan',
          numberOfAyahs: 2,
          editionIdentifier: 'quran-uthmani',
          ayahs: [
            AyahDto(
              number: 1,
              text: 'بسم الله',
              numberInSurah: 1,
              page: 1,
              juz: 1,
              hizbQuarter: 1,
              ruku: 1,
              sajda: false,
            ),
            AyahDto(
              number: 2,
              text: 'الحمد',
              numberInSurah: 2,
              page: 1,
              juz: 1,
              hizbQuarter: 1,
              ruku: 1,
              sajda: false,
            ),
          ],
        ),
        translation: SurahDetailDto(
          number: 1,
          name: 'الفاتحة',
          englishName: 'Al-Faatiha',
          englishNameTranslation: 'The Opening',
          revelationType: 'Meccan',
          numberOfAyahs: 2,
          editionIdentifier: 'en.sahih',
          ayahs: [
            AyahDto(
              number: 1,
              text: 'In the name of Allah',
              numberInSurah: 1,
              page: 1,
              juz: 1,
              hizbQuarter: 1,
              ruku: 1,
              sajda: false,
            ),
            AyahDto(
              number: 2,
              text: 'All praise',
              numberInSurah: 2,
              page: 1,
              juz: 1,
              hizbQuarter: 1,
              ruku: 1,
              sajda: false,
            ),
          ],
        ),
      ),
    );
    when(
      () => local.saveAyahsForSurah(
        surahNumber: any(named: 'surahNumber'),
        ayahs: any(named: 'ayahs'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => local.updateSyncProgress(
        completedSurahs: any(named: 'completedSurahs'),
        lastError: any(named: 'lastError'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => local.markSyncCompleted(
        textEdition: any(named: 'textEdition'),
        translationEdition: any(named: 'translationEdition'),
      ),
    ).thenAnswer((_) async {});

    await repository.syncQuranToLocal(translationEdition: 'en.sahih');

    verify(() => local.saveSurahList(any())).called(1);
    verify(
      () => local.saveAyahsForSurah(surahNumber: 1, ayahs: any(named: 'ayahs')),
    ).called(greaterThan(0));
    verify(
      () => local.markSyncCompleted(
        textEdition: 'quran-uthmani',
        translationEdition: 'en.sahih',
      ),
    ).called(1);
  });

  test('getAyahAudioUrl returns url from remote surah audio', () async {
    when(
      () => remote.fetchAyahAudioUrl(
        surahNumber: 1,
        ayahNumber: 1,
      ),
    ).thenAnswer((_) async => null);
    when(() => remote.fetchSurahAudioAyahs(1)).thenAnswer(
      (_) async => [
        AyahDto(
          number: 1,
          text: '',
          numberInSurah: 1,
          page: 1,
          juz: 1,
          hizbQuarter: 1,
          ruku: 1,
          sajda: false,
          audio: 'https://example.com/1.mp3',
        ),
      ],
    );

    final url = await repository.getAyahAudioUrl(
      surahNumber: 1,
      ayahNumber: 1,
    );

    expect(url, 'https://example.com/1.mp3');
  });
}
