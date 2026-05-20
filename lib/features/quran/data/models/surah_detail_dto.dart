import 'package:qareeb/features/quran/data/models/ayah_dto.dart';

class SurahDetailDto {
  const SurahDetailDto({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.ayahs,
    required this.editionIdentifier,
  });

  factory SurahDetailDto.fromJson(Map<String, dynamic> json) {
    final ayahsJson = json['ayahs'] as List<dynamic>;
    return SurahDetailDto(
      number: json['number'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      englishNameTranslation: json['englishNameTranslation'] as String,
      revelationType: json['revelationType'] as String,
      numberOfAyahs: json['numberOfAyahs'] as int,
      ayahs: ayahsJson
          .map((e) => AyahDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      editionIdentifier:
          (json['edition'] as Map<String, dynamic>)['identifier'] as String,
    );
  }

  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<AyahDto> ayahs;
  final String editionIdentifier;
}
