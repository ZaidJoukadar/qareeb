import 'package:qareeb/features/duaa/domain/entities/dua.dart';

class DuaDto {
  const DuaDto({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
    required this.repeat,
  });

  factory DuaDto.fromJson(Map<String, dynamic> json) {
    return DuaDto(
      id: json['id'] as int,
      categoryId: json['category'] as String,
      title: json['title'] as String,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      translation: json['translation'] as String,
      source: json['source'] as String,
      repeat: json['repeat'] as int,
    );
  }

  final int id;
  final String categoryId;
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String source;
  final int repeat;

  Dua toEntity() {
    return Dua(
      id: id,
      categoryId: categoryId,
      title: title,
      arabic: arabic,
      transliteration: transliteration,
      translation: translation,
      source: source,
      repeat: repeat,
    );
  }
}
