import 'package:equatable/equatable.dart';

class Surah extends Equatable {
  const Surah({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTranslated,
    required this.ayahCount,
    required this.revelationType,
  });

  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String nameTranslated;
  final int ayahCount;
  final String revelationType;

  @override
  List<Object?> get props => [
    number,
    nameArabic,
    nameEnglish,
    nameTranslated,
    ayahCount,
    revelationType,
  ];
}
