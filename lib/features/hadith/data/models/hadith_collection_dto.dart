import 'package:qareeb/features/hadith/domain/entities/hadith_collection.dart';

class HadithCollectionDto {
  const HadithCollectionDto({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.total,
  });

  factory HadithCollectionDto.fromJson(Map<String, dynamic> json) {
    return HadithCollectionDto(
      id: json['key'] as String,
      name: json['name'] as String,
      nameAr: json['arabic_name'] as String? ?? json['name'] as String,
      total: json['total_hadiths'] as int? ?? 0,
    );
  }

  final String id;
  final String name;
  final String nameAr;
  final int total;

  HadithCollection toEntity() {
    return HadithCollection(
      id: id,
      name: name,
      nameAr: nameAr,
      total: total,
    );
  }
}
