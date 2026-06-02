import 'package:qareeb/features/quran/data/database/app_database.dart';

abstract class ReadingProgressLocalDataSource {
  Future<Set<int>> getReadAyahNumbers(int surahNumber);
  Future<Map<int, int>> getReadAyahCountsBySurah();
  Future<bool> isAyahRead(int surahNumber, int ayahNumber);
  Future<void> setAyahRead({
    required int surahNumber,
    required int ayahNumber,
    required bool isRead,
  });
  Future<void> markSurahAsRead({
    required int surahNumber,
    required int ayahCount,
  });
  Future<Set<String>> getAllReadAyahKeys();
}

class ReadingProgressLocalDataSourceImpl
    implements ReadingProgressLocalDataSource {
  ReadingProgressLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<Set<int>> getReadAyahNumbers(int surahNumber) {
    return _db.getReadAyahNumbers(surahNumber);
  }

  @override
  Future<Map<int, int>> getReadAyahCountsBySurah() {
    return _db.getReadAyahCountsBySurah();
  }

  @override
  Future<bool> isAyahRead(int surahNumber, int ayahNumber) {
    return _db.isAyahRead(surahNumber, ayahNumber);
  }

  @override
  Future<void> setAyahRead({
    required int surahNumber,
    required int ayahNumber,
    required bool isRead,
  }) {
    return _db.setAyahRead(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      isRead: isRead,
    );
  }

  @override
  Future<void> markSurahAsRead({
    required int surahNumber,
    required int ayahCount,
  }) {
    return _db.markSurahAsRead(
      surahNumber: surahNumber,
      ayahCount: ayahCount,
    );
  }

  @override
  Future<Set<String>> getAllReadAyahKeys() => _db.getAllReadAyahKeys();
}
