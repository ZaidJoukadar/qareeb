class AyahWordDto {
  const AyahWordDto({
    required this.arabic,
    required this.translation,
    required this.transliteration,
  });

  factory AyahWordDto.fromJson(Map<String, dynamic> json) {
    return AyahWordDto(
      arabic: json['word_arabic'] as String,
      translation: json['word_translation'] as String,
      transliteration: json['word_transliteration'] as String,
    );
  }

  final String arabic;
  final String translation;
  final String transliteration;
}
