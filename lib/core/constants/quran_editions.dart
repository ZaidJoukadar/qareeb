/// Default [alquran.cloud](https://alquran.cloud/api) edition identifiers.
abstract final class QuranEditions {
  static const String arabicText = 'quran-uthmani';
  /// Saheeh International — direct English translation without tafsir/footnotes.
  static const String englishTranslation = 'en.sahih';
  static const String audioRecitation = 'ar.alafasy';

  /// Translation stored locally; Arabic UI may hide the translation line.
  static String translationForLocale(String languageCode) {
    return englishTranslation;
  }
}
