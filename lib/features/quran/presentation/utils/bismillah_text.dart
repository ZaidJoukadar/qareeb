/// Helpers for standalone Bismillah under the surah header (not inside ayah 1).
abstract final class BismillahText {
  static const int atTawbahSurahNumber = 9;

  /// Matches the end of Bismillah (`...الرَّحِيمِ`) across Uthmani spelling variants.
  static final RegExp _bismillahEnd = RegExp(
    r'ر[\u064B-\u065F\u0670\u064E\u0650\u0651\u0652\u064C\u064D]*'
    r'ح[\u064B-\u065F\u0670\u064E\u0650\u0651\u0652\u064C\u064D]*'
    r'ي[\u064B-\u065F\u0670\u064E\u0650\u0651\u0652\u064C\u064D]*'
    r'م[\u064B-\u065F\u0670\u064E\u0650\u0651\u0652\u064C\u064D\u0640]*',
  );

  /// Surahs that open with Bismillah before the first verse (all except At-Tawbah).
  static bool showStandaloneUnderHeader(int surahNumber) {
    return surahNumber != atTawbahSurahNumber;
  }

  static const String englishStandalone =
      'In the name of Allah, the Entirely Merciful, the Especially Merciful.';

  static const String _englishBismillahEnd = 'Especially Merciful.';

  /// Removes a leading English Bismillah from translation ayah 1.
  static String stripFromTranslationAyah(String text) {
    final cleaned = text.trim().replaceAll('\uFEFF', '').replaceAll('\n', ' ');

    if (!cleaned.startsWith('In the name of Allah')) {
      return cleaned;
    }

    final end = cleaned.indexOf(_englishBismillahEnd);
    if (end == -1) {
      return cleaned;
    }

    return cleaned.substring(end + _englishBismillahEnd.length).trim();
  }

  /// Removes the leading Bismillah phrase from [text] (API includes it on ayah 1).
  static String stripFromAyah(String text) {
    final cleaned = text.trim().replaceAll('\uFEFF', '').replaceAll('\n', ' ');

    if (!cleaned.startsWith('ب')) {
      return cleaned;
    }

    final match = _bismillahEnd.firstMatch(cleaned);
    if (match == null) {
      return cleaned;
    }

    return cleaned.substring(match.end).trim();
  }
}
