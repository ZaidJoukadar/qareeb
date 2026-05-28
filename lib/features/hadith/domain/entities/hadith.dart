import 'package:equatable/equatable.dart';

class Hadith extends Equatable {
  const Hadith({
    required this.id,
    required this.collectionId,
    required this.collectionName,
    required this.number,
    required this.arabic,
    required this.english,
    this.grade,
  });

  final String id;
  final String collectionId;
  final String collectionName;
  final int number;
  final String arabic;
  final String english;
  final String? grade;

  String previewFor({required bool isArabicLocale}) {
    final text = isArabicLocale ? arabic : english;
    final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.length <= 160) {
      return normalized;
    }
    return '${normalized.substring(0, 157)}…';
  }

  @override
  List<Object?> get props => [
    id,
    collectionId,
    collectionName,
    number,
    arabic,
    english,
    grade,
  ];
}

class HadithPage extends Equatable {
  const HadithPage({
    required this.hadiths,
    required this.page,
    required this.totalPages,
    required this.total,
  });

  final List<Hadith> hadiths;
  final int page;
  final int totalPages;
  final int total;

  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [hadiths, page, totalPages, total];
}
