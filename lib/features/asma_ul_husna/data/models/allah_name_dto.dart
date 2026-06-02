import 'package:qareeb/features/asma_ul_husna/domain/entities/allah_name.dart';

class AllahNameDto {
  const AllahNameDto({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.english,
    required this.meaning,
  });

  factory AllahNameDto.fromJson(Map<String, dynamic> json) {
    return AllahNameDto(
      number: json['number'] as int,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      english: json['english'] as String,
      meaning: json['meaning'] as String,
    );
  }

  final int number;
  final String arabic;
  final String transliteration;
  final String english;
  final String meaning;

  AllahName toEntity({
    String? translationAr,
    String? meaningAr,
  }) {
    return AllahName(
      number: number,
      arabic: arabic,
      transliteration: transliteration,
      english: english,
      meaning: meaning,
      translationAr: translationAr,
      meaningAr: meaningAr,
    );
  }
}
