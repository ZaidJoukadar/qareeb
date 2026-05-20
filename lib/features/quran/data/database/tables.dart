import 'package:drift/drift.dart';

class Surahs extends Table {
  IntColumn get number => integer()();
  TextColumn get nameArabic => text()();
  TextColumn get nameEnglish => text()();
  TextColumn get nameTranslated => text()();
  IntColumn get ayahCount => integer()();
  TextColumn get revelationType => text()();
  IntColumn get displayOrder => integer()();

  @override
  Set<Column> get primaryKey => {number};
}

@TableIndex(
  name: 'ayahs_surah_ayah_idx',
  columns: {#surahNumber, #ayahNumber},
  unique: true,
)
class Ayahs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  IntColumn get ayahNumber => integer()();
  IntColumn get globalAyahNumber => integer()();
  TextColumn get textArabic => text()();
  TextColumn get textTranslation => text()();
  IntColumn get page => integer()();
  IntColumn get juz => integer()();
  IntColumn get hizbQuarter => integer()();
  IntColumn get ruku => integer()();
  BoolColumn get sajda => boolean().withDefault(const Constant(false))();
}

class QuranSyncStateTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get status => text()();
  IntColumn get completedSurahs => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  TextColumn get textEdition => text().nullable()();
  TextColumn get translationEdition => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
