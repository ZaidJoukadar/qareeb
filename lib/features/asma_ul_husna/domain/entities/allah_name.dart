import 'package:equatable/equatable.dart';

class AllahName extends Equatable {
  const AllahName({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.english,
    required this.meaning,
    this.translationAr,
    this.meaningAr,
  });

  final int number;
  final String arabic;
  final String transliteration;
  final String english;
  final String meaning;
  final String? translationAr;
  final String? meaningAr;

  String translationFor({required bool isArabicLocale}) {
    if (isArabicLocale && translationAr != null && translationAr!.isNotEmpty) {
      return translationAr!;
    }
    return english;
  }

  String meaningFor({required bool isArabicLocale}) {
    if (isArabicLocale && meaningAr != null && meaningAr!.isNotEmpty) {
      return meaningAr!;
    }
    return meaning;
  }

  @override
  List<Object?> get props => [
    number,
    arabic,
    transliteration,
    english,
    meaning,
    translationAr,
    meaningAr,
  ];
}
