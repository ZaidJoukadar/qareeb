import 'package:flutter/material.dart';

/// Quran reader presentation rules tied to the active app locale.
abstract final class QuranReaderLocale {
  /// English and other locales show the translation line; Arabic hides it.
  static bool showTranslationFor(String languageCode) => languageCode != 'ar';

  static String languageCodeFrom(Locale? savedLocale, Locale appLocale) {
    return savedLocale?.languageCode ?? appLocale.languageCode;
  }
}
