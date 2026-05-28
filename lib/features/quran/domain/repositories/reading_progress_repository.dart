abstract class ReadingProgressRepository {
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
