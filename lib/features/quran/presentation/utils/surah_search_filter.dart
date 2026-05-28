import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/presentation/utils/surah_header_text.dart';

List<Surah> filterSurahs({
  required List<Surah> surahs,
  required String query,
  required bool isArabicLocale,
}) {
  final trimmed = query.trim();
  if (trimmed.isEmpty) {
    return surahs;
  }

  final lowerQuery = trimmed.toLowerCase();
  final numericQuery = int.tryParse(trimmed);

  return surahs.where((surah) {
    if (numericQuery != null && surah.number == numericQuery) {
      return true;
    }

    final shortName = SurahHeaderText.shortSurahName(
      surahNumber: surah.number,
      nameArabic: surah.nameArabic,
      isArabic: isArabicLocale,
    );

    return surah.nameEnglish.toLowerCase().contains(lowerQuery) ||
        surah.nameTranslated.toLowerCase().contains(lowerQuery) ||
        surah.nameArabic.contains(trimmed) ||
        shortName.toLowerCase().contains(lowerQuery) ||
        shortName.contains(trimmed) ||
        surah.number.toString().contains(trimmed);
  }).toList();
}
