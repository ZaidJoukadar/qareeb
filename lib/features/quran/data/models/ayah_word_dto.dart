import 'package:qareeb/features/quran/domain/entities/ayah_word.dart';

class AyahWordDto {
  const AyahWordDto({
    required this.position,
    required this.arabic,
    required this.translation,
    required this.transliteration,
  });

  factory AyahWordDto.fromJson(Map<String, dynamic> json) {
    final transliterationJson =
        json['transliteration'] as Map<String, dynamic>? ?? {};
    final translationField = json['translation'];
    final translation = translationField is String
        ? translationField
        : (translationField as Map<String, dynamic>?)?['text'] as String? ??
              '';
    return AyahWordDto(
      position: json['position'] as int,
      arabic: json['arabic'] as String,
      translation: translation.trim(),
      transliteration: (transliterationJson['text'] as String? ?? '').trim(),
    );
  }

  factory AyahWordDto.fromQuranComJson(Map<String, dynamic> json) {
    final transliterationJson =
        json['transliteration'] as Map<String, dynamic>? ?? {};
    final translationJson = json['translation'] as Map<String, dynamic>? ?? {};
    final arabic = (json['text_uthmani'] as String? ??
            json['text_imlaei'] as String? ??
            json['text'] as String? ??
            '')
        .trim();
    return AyahWordDto(
      position: json['position'] as int,
      arabic: arabic,
      translation: (translationJson['text'] as String? ?? '').trim(),
      transliteration: (transliterationJson['text'] as String? ?? '').trim(),
    );
  }

  final int position;
  final String arabic;
  final String translation;
  final String transliteration;

  AyahWord toEntity() {
    return AyahWord(
      position: position,
      arabic: arabic,
      translation: translation,
      transliteration: transliteration,
    );
  }
}
