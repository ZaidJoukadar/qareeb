class AudioEditionDto {
  const AudioEditionDto({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
  });

  factory AudioEditionDto.fromJson(Map<String, dynamic> json) {
    return AudioEditionDto(
      identifier: json['identifier'] as String,
      language: json['language'] as String,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
    );
  }

  final String identifier;
  final String language;
  final String name;
  final String englishName;

  String displayNameForLocale(String languageCode) {
    if (languageCode == 'ar') return name;
    return englishName;
  }
}
