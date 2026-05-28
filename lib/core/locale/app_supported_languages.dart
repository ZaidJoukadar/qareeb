import 'package:flutter/material.dart';
import 'package:qareeb/l10n/generated/app_localizations.dart';

/// Display metadata for a supported app language.
///
/// When adding a locale, update [AppLocalizations.supportedLocales] (l10n) and
/// add an entry to [_nativeNames] below.
class AppSupportedLanguage {
  const AppSupportedLanguage({
    required this.locale,
    required this.nativeName,
  });

  final Locale locale;
  final String nativeName;
}

/// Native names for each supported [languageCode].
const Map<String, String> _nativeNames = {
  'en': 'English',
  'ar': 'العربية',
  'tr': 'Türkçe',
};

/// Languages available in settings, derived from [AppLocalizations.supportedLocales].
List<AppSupportedLanguage> get appSupportedLanguages {
  return AppLocalizations.supportedLocales.map((locale) {
    final code = locale.languageCode;
    return AppSupportedLanguage(
      locale: locale,
      nativeName: _nativeNames[code] ?? code,
    );
  }).toList();
}

AppSupportedLanguage languageForLocale(Locale locale) {
  return appSupportedLanguages.firstWhere(
    (language) => language.locale.languageCode == locale.languageCode,
    orElse: () => appSupportedLanguages.first,
  );
}
