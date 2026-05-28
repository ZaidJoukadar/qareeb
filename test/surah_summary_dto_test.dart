import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/core/network/ummah_api_response.dart';
import 'package:qareeb/features/quran/data/models/surah_summary_dto.dart';

void main() {
  test('parses surah list from UmmahAPI envelope', () {
    const json = {
      'success': true,
      'data': {
        'surahs': [
          {
            'number': 1,
            'name_arabic': 'الفاتحة',
            'name_english': 'Al-Fatihah',
            'name_translation': 'The Opener',
            'verses_count': 7,
            'revelation_place': 'makkah',
          },
        ],
      },
    };

    final response = UmmahApiResponse.fromJson(
      json,
      (data) => (data as Map<String, dynamic>)['surahs'] as List<dynamic>,
    );

    expect(response.success, isTrue);
    expect(response.data, hasLength(1));

    final dto = SurahSummaryDto(
      number: response.data.first['number'] as int,
      name: response.data.first['name_arabic'] as String,
      englishName: response.data.first['name_english'] as String,
      englishNameTranslation: response.data.first['name_translation'] as String,
      numberOfAyahs: response.data.first['verses_count'] as int,
      revelationType: 'Meccan',
    );
    expect(dto.englishName, 'Al-Fatihah');
  });
}
