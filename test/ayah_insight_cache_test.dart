import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/features/quran/data/datasources/ayah_insight_cache_local_data_source.dart';
import 'package:qareeb/features/quran/domain/entities/ayah_insight.dart';
import 'package:qareeb/features/quran/domain/entities/ayah_word.dart';

void main() {
  late Directory tempDir;
  late AyahInsightCacheLocalDataSourceImpl cache;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('qareeb_insight_test_');
    cache = AyahInsightCacheLocalDataSourceImpl(cacheRootOverride: tempDir);
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('returns null when insight is not cached', () async {
    final insight = await cache.getInsight(
      surahNumber: 1,
      ayahNumber: 1,
      languageCode: 'en',
    );
    expect(insight, isNull);
  });

  test('saves and loads ayah insight', () async {
    const insight = AyahInsight(
      surahNumber: 2,
      ayahNumber: 255,
      meaning: 'Allah — there is no deity except Him.',
    );

    await cache.saveInsight(insight, languageCode: 'en');

    final loaded = await cache.getInsight(
      surahNumber: 2,
      ayahNumber: 255,
      languageCode: 'en',
    );

    expect(loaded, insight);
  });

  test('saves and loads ayah words', () async {
    const words = [
      AyahWord(
        position: 1,
        arabic: 'اللَّهُ',
        translation: 'Allah',
        transliteration: 'Allāhu',
      ),
      AyahWord(
        position: 2,
        arabic: 'لَا',
        translation: 'no',
        transliteration: 'lā',
      ),
    ];

    await cache.saveWords(
      surahNumber: 2,
      ayahNumber: 255,
      languageCode: 'en',
      words: words,
    );

    final loaded = await cache.getWords(
      surahNumber: 2,
      ayahNumber: 255,
      languageCode: 'en',
    );

    expect(loaded, words);
  });

  test('clearAll removes cached insight and words', () async {
    const insight = AyahInsight(
      surahNumber: 1,
      ayahNumber: 1,
      meaning: 'In the name of Allah.',
    );
    const words = [
      AyahWord(
        position: 1,
        arabic: 'بِسْمِ',
        translation: 'In the name of',
        transliteration: 'bis-mi',
      ),
    ];

    await cache.saveInsight(insight, languageCode: 'en');
    await cache.saveWords(
      surahNumber: 1,
      ayahNumber: 1,
      languageCode: 'en',
      words: words,
    );

    await cache.clearAll();

    expect(tempDir.existsSync(), isFalse);
    expect(
      await cache.getInsight(
        surahNumber: 1,
        ayahNumber: 1,
        languageCode: 'en',
      ),
      isNull,
    );
    expect(
      await cache.getWords(
        surahNumber: 1,
        ayahNumber: 1,
        languageCode: 'en',
      ),
      isNull,
    );
  });
}
