import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:qareeb/features/quran/data/database/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Surahs, Ayahs, QuranSyncStateTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'qareeb_quran');
  }

  Future<List<Surah>> getAllSurahs() {
    return (select(surahs)..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
        .get();
  }

  Future<List<Ayah>> getAyahsForSurah(int surahNumber) {
    return (select(ayahs)
          ..where((t) => t.surahNumber.equals(surahNumber))
          ..orderBy([(t) => OrderingTerm.asc(t.ayahNumber)]))
        .get();
  }

  Future<QuranSyncStateTableData?> getSyncState() {
    return (select(quranSyncStateTable)..where((t) => t.id.equals(1)))
        .getSingleOrNull();
  }

  Future<void> upsertSyncState(QuranSyncStateTableCompanion companion) {
    return into(quranSyncStateTable).insertOnConflictUpdate(companion);
  }

  Future<void> replaceSurahs(List<SurahsCompanion> rows) async {
    await batch((batch) {
      batch.deleteAll(surahs);
      batch.insertAll(surahs, rows);
    });
  }

  Future<void> replaceAyahsForSurah(
    int surahNumber,
    List<AyahsCompanion> rows,
  ) async {
    await transaction(() async {
      await (delete(ayahs)..where((t) => t.surahNumber.equals(surahNumber)))
          .go();
      if (rows.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(ayahs, rows);
        });
      }
    });
  }

  Future<bool> hasAyahs() async {
    final count = await ayahs.count().getSingle();
    return count > 0;
  }
}
