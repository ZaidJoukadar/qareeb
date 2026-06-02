import 'package:equatable/equatable.dart';

class Ayah extends Equatable {
  const Ayah({
    required this.surahNumber,
    required this.ayahNumber,
    required this.globalAyahNumber,
    required this.textArabic,
    required this.textTranslation,
    required this.page,
    required this.juz,
    required this.hizbQuarter,
    required this.ruku,
    required this.sajda,
  });

  final int surahNumber;
  final int ayahNumber;
  final int globalAyahNumber;
  final String textArabic;
  final String textTranslation;
  final int page;
  final int juz;
  final int hizbQuarter;
  final int ruku;
  final bool sajda;

  @override
  List<Object?> get props => [
    surahNumber,
    ayahNumber,
    globalAyahNumber,
    textArabic,
    textTranslation,
    page,
    juz,
    hizbQuarter,
    ruku,
    sajda,
  ];
}
