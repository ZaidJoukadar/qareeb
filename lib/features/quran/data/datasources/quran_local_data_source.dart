import 'package:drift/drift.dart';
import 'package:qareeb/features/quran/data/database/app_database.dart'
    as db;
import 'package:qareeb/features/quran/data/models/surah_summary_dto.dart';
import 'package:qareeb/features/quran/domain/entities/ayah.dart' as entities;
import 'package:qareeb/features/quran/domain/entities/surah.dart' as entities;

abstract class QuranLocalDataSource {
  Future<List<entities.Surah>> getSurahs();

  Future<List<entities.Ayah>> getAyahsBySurah(int surahNumber);

  Future<QuranSyncStatus> getSyncStatus();

  Future<int> getCompletedSurahs();

  Future<void> saveSurahList(List<SurahSummaryDto> summaries);

  Future<void> saveAyahsForSurah({
    required int surahNumber,
    required List<AyahInsert> ayahs,
  });

  Future<void> updateSyncProgress({
    required int completedSurahs,
    String? lastError,
  });

  Future<void> markSyncCompleted({
    required String textEdition,
    required String translationEdition,
  });

  Future<void> markSyncFailed(String error);

  Future<void> markSyncInProgress({
    required String textEdition,
    required String translationEdition,
  });

  Future<void> resetSyncProgress();
}

class AyahInsert {
  const AyahInsert({
    required this.surahNumber,
    required this.ayahNumber,
    required this.globalAyahNumber,
    required this.textArabic,
    required this.textTranslation,
    required this.page,
    required this.juz,
    required this.hizbQuarter,
    required this.ruku,
    required this.sajda,
  });

  final int surahNumber;
  final int ayahNumber;
  final int globalAyahNumber;
  final String textArabic;
  final String textTranslation;
  final int page;
  final int juz;
  final int hizbQuarter;
  final int ruku;
  final bool sajda;
}

enum QuranSyncStatus { none, inProgress, completed, failed }

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  QuranLocalDataSourceImpl(this._db);

  final db.AppDatabase _db;

  @override
  Future<List<entities.Surah>> getSurahs() async {
    final rows = await _db.getAllSurahs();
    return rows.map(_mapSurah).toList();
  }

  @override
  Future<List<entities.Ayah>> getAyahsBySurah(int surahNumber) async {
    final rows = await _db.getAyahsForSurah(surahNumber);
    return rows.map(_mapAyah).toList();
  }

  @override
  Future<QuranSyncStatus> getSyncStatus() async {
    final row = await _db.getSyncState();
    if (row == null) return QuranSyncStatus.none;
    return switch (row.status) {
      'in_progress' => QuranSyncStatus.inProgress,
      'completed' => QuranSyncStatus.completed,
      'failed' => QuranSyncStatus.failed,
      _ => QuranSyncStatus.none,
    };
  }

  @override
  Future<int> getCompletedSurahs() async {
    final row = await _db.getSyncState();
    return row?.completedSurahs ?? 0;
  }

  @override
  Future<void> saveSurahList(List<SurahSummaryDto> summaries) async {
    final rows = summaries
        .map(
          (s) => db.SurahsCompanion.insert(
            number: Value(s.number),
            nameArabic: s.name,
            nameEnglish: s.englishName,
            nameTranslated: s.englishNameTranslation,
            ayahCount: s.numberOfAyahs,
            revelationType: s.revelationType,
            displayOrder: s.number,
          ),
        )
        .toList();
    await _db.replaceSurahs(rows);
  }

  @override
  Future<void> saveAyahsForSurah({
    required int surahNumber,
    required List<AyahInsert> ayahs,
  }) async {
    final rows = ayahs
        .map(
          (a) => db.AyahsCompanion.insert(
            surahNumber: a.surahNumber,
            ayahNumber: a.ayahNumber,
            globalAyahNumber: a.globalAyahNumber,
            textArabic: a.textArabic,
            textTranslation: a.textTranslation,
            page: a.page,
            juz: a.juz,
            hizbQuarter: a.hizbQuarter,
            ruku: a.ruku,
            sajda: Value(a.sajda),
          ),
        )
        .toList();
    await _db.replaceAyahsForSurah(surahNumber, rows);
  }

  @override
  Future<void> updateSyncProgress({
    required int completedSurahs,
    String? lastError,
  }) async {
    await _db.upsertSyncState(
      db.QuranSyncStateTableCompanion(
        id: const Value(1),
        status: const Value('in_progress'),
        completedSurahs: Value(completedSurahs),
        lastError: Value(lastError),
      ),
    );
  }

  @override
  Future<void> markSyncCompleted({
    required String textEdition,
    required String translationEdition,
  }) async {
    await _db.upsertSyncState(
      db.QuranSyncStateTableCompanion(
        id: const Value(1),
        status: const Value('completed'),
        completedSurahs: const Value(114),
        lastError: const Value(null),
        syncedAt: Value(DateTime.now()),
        textEdition: Value(textEdition),
        translationEdition: Value(translationEdition),
      ),
    );
  }

  @override
  Future<void> markSyncFailed(String error) async {
    await _db.upsertSyncState(
      db.QuranSyncStateTableCompanion(
        id: const Value(1),
        status: const Value('failed'),
        lastError: Value(error),
      ),
    );
  }

  @override
  Future<void> markSyncInProgress({
    required String textEdition,
    required String translationEdition,
  }) async {
    await _db.upsertSyncState(
      db.QuranSyncStateTableCompanion(
        id: const Value(1),
        status: const Value('in_progress'),
        completedSurahs: const Value(0),
        lastError: const Value(null),
        textEdition: Value(textEdition),
        translationEdition: Value(translationEdition),
      ),
    );
  }

  @override
  Future<void> resetSyncProgress() async {
    await _db.upsertSyncState(
      const db.QuranSyncStateTableCompanion(
        id: Value(1),
        status: Value('none'),
        completedSurahs: Value(0),
        lastError: Value(null),
      ),
    );
  }

  entities.Surah _mapSurah(db.Surah row) {
    return entities.Surah(
      number: row.number,
      nameArabic: row.nameArabic,
      nameEnglish: row.nameEnglish,
      nameTranslated: row.nameTranslated,
      ayahCount: row.ayahCount,
      revelationType: row.revelationType,
    );
  }

  entities.Ayah _mapAyah(db.Ayah row) {
    return entities.Ayah(
      surahNumber: row.surahNumber,
      ayahNumber: row.ayahNumber,
      globalAyahNumber: row.globalAyahNumber,
      textArabic: row.textArabic,
      textTranslation: row.textTranslation,
      page: row.page,
      juz: row.juz,
      hizbQuarter: row.hizbQuarter,
      ruku: row.ruku,
      sajda: row.sajda,
    );
  }
}
