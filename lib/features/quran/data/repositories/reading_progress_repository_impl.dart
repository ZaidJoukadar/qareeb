import 'package:qareeb/core/monitoring/run_guarded.dart';
import 'package:qareeb/core/monitoring/sentry_report.dart';
import 'package:qareeb/features/quran/data/datasources/reading_progress_local_data_source.dart';
import 'package:qareeb/features/quran/domain/repositories/reading_progress_repository.dart';

class ReadingProgressRepositoryImpl implements ReadingProgressRepository {
  ReadingProgressRepositoryImpl(this._local);

  final ReadingProgressLocalDataSource _local;

  @override
  Future<Set<int>> getReadAyahNumbers(int surahNumber) => runGuarded(
    () => _local.getReadAyahNumbers(surahNumber),
    report: const SentryReport(
      feature: 'quran',
      action: 'get_read_ayah_numbers',
    ),
  );

  @override
  Future<Map<int, int>> getReadAyahCountsBySurah() => runGuarded(
    _local.getReadAyahCountsBySurah,
    report: const SentryReport(
      feature: 'quran',
      action: 'get_read_ayah_counts',
    ),
  );

  @override
  Future<bool> isAyahRead(int surahNumber, int ayahNumber) => runGuarded(
    () => _local.isAyahRead(surahNumber, ayahNumber),
    report: const SentryReport(feature: 'quran', action: 'is_ayah_read'),
  );

  @override
  Future<void> setAyahRead({
    required int surahNumber,
    required int ayahNumber,
    required bool isRead,
  }) => runGuarded(
    () => _local.setAyahRead(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      isRead: isRead,
    ),
    report: const SentryReport(feature: 'quran', action: 'set_ayah_read'),
  );

  @override
  Future<void> markSurahAsRead({
    required int surahNumber,
    required int ayahCount,
  }) => runGuarded(
    () => _local.markSurahAsRead(
      surahNumber: surahNumber,
      ayahCount: ayahCount,
    ),
    report: const SentryReport(feature: 'quran', action: 'mark_surah_read'),
  );

  @override
  Future<Set<String>> getAllReadAyahKeys() => runGuarded(
    _local.getAllReadAyahKeys,
    report: const SentryReport(feature: 'quran', action: 'get_all_read_ayah_keys'),
  );
}
