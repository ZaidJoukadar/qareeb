import 'package:qcf_quran_lite/qcf_quran_lite.dart' hide Ayah, Surah;

/// Text helpers for mushaf surah headers.
abstract final class SurahHeaderText {
  static String shortSurahName({
    required int surahNumber,
    required String nameArabic,
    required bool isArabic,
  }) {
    if (isArabic) {
      try {
        return getSurahNameArabic(surahNumber);
      } catch (_) {
        return _stripSurahPrefix(nameArabic);
      }
    }
    try {
      return getSurahNameEnglish(surahNumber);
    } catch (_) {
      return nameArabic;
    }
  }

  static String bannerTitle({
    required int surahNumber,
    required String nameArabic,
    required bool isArabic,
  }) {
    if (isArabic) {
      final short = shortSurahName(
        surahNumber: surahNumber,
        nameArabic: nameArabic,
        isArabic: true,
      );
      return 'سورة $short';
    }
    try {
      return 'Surah ${getSurahNameEnglish(surahNumber)}';
    } catch (_) {
      return 'Surah $nameArabic';
    }
  }

  static String _stripSurahPrefix(String name) {
    final text = name.trim();
    const prefixes = ['سُورَةُ ', 'سورة ', 'سُورَة ', 'سوره '];
    return prefixes
            .where((prefix) => text.startsWith(prefix))
            .map((prefix) => text.substring(prefix.length).trim())
            .firstOrNull ??
        text;
  }
}
