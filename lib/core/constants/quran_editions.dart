/// Default [UmmahAPI](https://ummahapi.com/api/docs) edition identifiers.
abstract final class QuranEditions {
  static const String arabicText = 'quran-uthmani';
  /// Saheeh International — direct English translation without tafsir/footnotes.
  static const String englishTranslation = 'en.sahih';
  static const String audioRecitation = 'ar.alafasy';
  static const String wordByWord = 'quran-wordbyword-2';
  static const String tafsirArabic = 'ar.muyassar';

  static String tafsirForLocale(String languageCode) {
    return tafsirArabic;
  }

  static String insightTranslationForLocale(String languageCode) {
    return languageCode == 'ar' ? arabicText : englishTranslation;
  }

  /// Translation stored locally; Arabic UI may hide the translation line.
  static String translationForLocale(String languageCode) {
    return languageCode == 'ar' ? arabicText : englishTranslation;
  }

  /// [Quran.com](https://api.quran.com/api/v4) `language` param for word glosses.
  /// English uses UmmahAPI instead; other locales use Quran.com word translations.
  static String wordTranslationLanguageForLocale(String languageCode) {
    return switch (languageCode) {
      'tr' => 'tr',
      'ar' => 'ar',
      _ => 'en',
    };
  }
}
