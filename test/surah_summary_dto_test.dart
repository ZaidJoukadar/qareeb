import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/features/quran/data/models/alquran_api_response.dart';
import 'package:qareeb/features/quran/data/models/surah_summary_dto.dart';

void main() {
  test('parses surah list from API envelope', () {
    const json = {
      'code': 200,
      'status': 'OK',
      'data': [
        {
          'number': 1,
          'name': 'الفاتحة',
          'englishName': 'Al-Faatiha',
          'englishNameTranslation': 'The Opening',
          'numberOfAyahs': 7,
          'revelationType': 'Meccan',
        },
      ],
    };

    final response = AlQuranApiResponse.fromJson(
      json,
      (data) => (data as List<dynamic>)
          .map((e) => SurahSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    expect(response.code, 200);
    expect(response.data, hasLength(1));
    expect(response.data.first.englishName, 'Al-Faatiha');
  });
}
