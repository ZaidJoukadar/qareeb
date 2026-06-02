import 'package:qareeb/features/hadith/domain/entities/hadith.dart';

class HadithDto {
  const HadithDto({
    required this.id,
    required this.collectionId,
    required this.collectionName,
    required this.number,
    required this.arabic,
    required this.english,
    this.grade,
  });

  factory HadithDto.fromJson(Map<String, dynamic> json) {
    return HadithDto(
      id: json['id'] as String,
      collectionId: json['collection'] as String,
      collectionName: json['collection_name'] as String,
      number: json['hadithnumber'] as int,
      arabic: json['arabic'] as String,
      english: json['english'] as String,
      grade: json['grade'] as String?,
    );
  }

  final String id;
  final String collectionId;
  final String collectionName;
  final int number;
  final String arabic;
  final String english;
  final String? grade;

  Hadith toEntity() {
    return Hadith(
      id: id,
      collectionId: collectionId,
      collectionName: collectionName,
      number: number,
      arabic: arabic,
      english: english,
      grade: grade,
    );
  }

  static List<Hadith> entitiesFromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((item) => HadithDto.fromJson(item as Map<String, dynamic>).toEntity())
        .toList();
  }
}
