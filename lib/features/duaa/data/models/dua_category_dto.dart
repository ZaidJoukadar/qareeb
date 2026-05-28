import 'package:qareeb/features/duaa/domain/entities/dua_category.dart';

class DuaCategoryDto {
  const DuaCategoryDto({
    required this.id,
    required this.name,
    required this.description,
    required this.count,
  });

  factory DuaCategoryDto.fromJson(Map<String, dynamic> json) {
    return DuaCategoryDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      count: json['count'] as int,
    );
  }

  final String id;
  final String name;
  final String description;
  final int count;

  DuaCategory toEntity() {
    return DuaCategory(
      id: id,
      name: name,
      description: description,
      count: count,
    );
  }
}
