import 'package:equatable/equatable.dart';
import 'package:qareeb/features/duaa/core/dua_source_localizer.dart';

class Dua extends Equatable {
  const Dua({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
    required this.repeat,
    this.titleAr,
    this.translationAr,
  });

  final int id;
  final String categoryId;
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String source;
  final int repeat;
  final String? titleAr;
  final String? translationAr;

  String titleFor({required bool isArabicLocale}) {
    if (isArabicLocale && titleAr != null && titleAr!.isNotEmpty) {
      return titleAr!;
    }
    return title;
  }

  String translationFor({required bool isArabicLocale}) {
    if (isArabicLocale && translationAr != null && translationAr!.isNotEmpty) {
      return translationAr!;
    }
    return translation;
  }

  String sourceFor({required bool isArabicLocale}) {
    return DuaSourceLocalizer.localize(source, isArabicLocale: isArabicLocale);
  }

  bool get shouldShowTranslationInArabic {
    final arabicTranslation = translationAr;
    if (arabicTranslation == null || arabicTranslation.isEmpty) {
      return false;
    }

    if (arabicTranslation.contains('(')) {
      return true;
    }

    return _normalizeArabic(arabicTranslation) != _normalizeArabic(arabic);
  }

  static String _normalizeArabic(String value) {
    return value
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u0640]'), '')
        .replaceAll(RegExp(r'[^\u0621-\u064A\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  @override
  List<Object?> get props => [
    id,
    categoryId,
    title,
    arabic,
    transliteration,
    translation,
    source,
    repeat,
    titleAr,
    translationAr,
  ];
}
