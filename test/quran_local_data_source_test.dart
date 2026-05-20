import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/features/quran/data/database/app_database.dart';
import 'package:qareeb/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:qareeb/features/quran/data/models/surah_summary_dto.dart';

void main() {
  late AppDatabase database;
  late QuranLocalDataSourceImpl dataSource;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    dataSource = QuranLocalDataSourceImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('saveSurahList and getSurahs round-trip', () async {
    await dataSource.saveSurahList([
      const SurahSummaryDto(
        number: 1,
        name: 'الفاتحة',
        englishName: 'Al-Faatiha',
        englishNameTranslation: 'The Opening',
        numberOfAyahs: 7,
        revelationType: 'Meccan',
      ),
    ]);

    final surahs = await dataSource.getSurahs();
    expect(surahs, hasLength(1));
    expect(surahs.first.number, 1);
    expect(surahs.first.nameEnglish, 'Al-Faatiha');
  });

  test('markSyncCompleted sets completed status', () async {
    await dataSource.markSyncCompleted(
      textEdition: 'quran-uthmani',
      translationEdition: 'en.sahih',
    );

    expect(await dataSource.getSyncStatus(), QuranSyncStatus.completed);
    expect(await dataSource.getCompletedSurahs(), 114);
  });
}
