import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/features/quran/data/models/surah_detail_dto.dart';
import 'package:qareeb/features/quran/data/models/surah_summary_dto.dart';

void main() {
  test('SurahSummaryDto parses surah list item', () {
    final dto = SurahSummaryDto.fromJson({
      'number': 1,
      'name': 'الفاتحة',
      'englishName': 'Al-Faatiha',
      'englishNameTranslation': 'The Opening',
      'numberOfAyahs': 7,
      'revelationType': 'Meccan',
    });

    expect(dto.number, 1);
    expect(dto.numberOfAyahs, 7);
  });

  test('SurahDetailDto parses ayahs with edition', () {
    final dto = SurahDetailDto.fromJson({
      'number': 1,
      'name': 'الفاتحة',
      'englishName': 'Al-Faatiha',
      'englishNameTranslation': 'The Opening',
      'revelationType': 'Meccan',
      'numberOfAyahs': 1,
      'ayahs': [
        {
          'number': 1,
          'text': 'بسم الله',
          'numberInSurah': 1,
          'page': 1,
          'juz': 1,
          'hizbQuarter': 1,
          'ruku': 1,
          'sajda': false,
        },
      ],
      'edition': {'identifier': 'quran-uthmani'},
    });

    expect(dto.editionIdentifier, 'quran-uthmani');
    expect(dto.ayahs, hasLength(1));
    expect(dto.ayahs.first.numberInSurah, 1);
  });
}
