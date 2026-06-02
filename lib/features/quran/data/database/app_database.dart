import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:qareeb/features/quran/data/database/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Surahs, Ayahs, QuranSyncStateTable, ReadAyahs])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(readAyahs);
      }
    },
  );

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

  Future<Surah?> getSurahByNumber(int number) {
    return (select(surahs)..where((t) => t.number.equals(number)))
        .getSingleOrNull();
  }

  Future<List<Ayah>> getAyahsForPage(int page) {
    return (select(ayahs)
          ..where((t) => t.page.equals(page))
          ..orderBy([(t) => OrderingTerm.asc(t.globalAyahNumber)]))
        .get();
  }

  Future<int> getMaxMushafPage() async {
    final row = await (select(ayahs)
          ..orderBy([(t) => OrderingTerm.desc(t.page)])
          ..limit(1))
        .getSingleOrNull();
    return row?.page ?? 604;
  }

  Future<int?> getFirstPageForSurah(int surahNumber) async {
    final row = await (select(ayahs)
          ..where((t) => t.surahNumber.equals(surahNumber))
          ..orderBy([(t) => OrderingTerm.asc(t.ayahNumber)])
          ..limit(1))
        .getSingleOrNull();
    return row?.page;
  }

  Future<int?> getFirstPageForJuz(int juzNumber) async {
    final row = await (select(ayahs)
          ..where((t) => t.juz.equals(juzNumber))
          ..orderBy([(t) => OrderingTerm.asc(t.globalAyahNumber)])
          ..limit(1))
        .getSingleOrNull();
    return row?.page;
  }

  Future<Map<int, int>> getSurahCountByJuz() async {
    final rows = await customSelect(
      'SELECT juz, COUNT(DISTINCT surah_number) AS surah_count '
      'FROM ayahs GROUP BY juz',
      readsFrom: {ayahs},
    ).get();

    return {
      for (final row in rows)
        row.read<int>('juz'): row.read<int>('surah_count'),
    };
  }

  Future<Set<String>> getAllReadAyahKeys() async {
    final rows = await select(readAyahs).get();
    return rows.map((row) => '${row.surahNumber}-${row.ayahNumber}').toSet();
  }

  Future<Set<int>> getReadAyahNumbers(int surahNumber) async {
    final rows = await (select(readAyahs)
          ..where((t) => t.surahNumber.equals(surahNumber)))
        .get();
    return rows.map((row) => row.ayahNumber).toSet();
  }

  Future<Map<int, int>> getReadAyahCountsBySurah() async {
    final rows = await select(readAyahs).get();
    return rows.fold<Map<int, int>>(
      {},
      (counts, row) {
        counts[row.surahNumber] = (counts[row.surahNumber] ?? 0) + 1;
        return counts;
      },
    );
  }

  Future<bool> isAyahRead(int surahNumber, int ayahNumber) async {
    final row = await (select(readAyahs)
          ..where(
            (t) =>
                t.surahNumber.equals(surahNumber) &
                t.ayahNumber.equals(ayahNumber),
          ))
        .getSingleOrNull();
    return row != null;
  }

  Future<void> setAyahRead({
    required int surahNumber,
    required int ayahNumber,
    required bool isRead,
  }) async {
    if (isRead) {
      await into(readAyahs).insertOnConflictUpdate(
        ReadAyahsCompanion.insert(
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
        ),
      );
      return;
    }

    await (delete(readAyahs)
          ..where(
            (t) =>
                t.surahNumber.equals(surahNumber) &
                t.ayahNumber.equals(ayahNumber),
          ))
        .go();
  }

  Future<void> markSurahAsRead({
    required int surahNumber,
    required int ayahCount,
  }) async {
    await batch((batch) {
      batch.insertAll(
        readAyahs,
        Iterable.generate(
          ayahCount,
          (index) => ReadAyahsCompanion.insert(
            surahNumber: surahNumber,
            ayahNumber: index + 1,
          ),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }
}
