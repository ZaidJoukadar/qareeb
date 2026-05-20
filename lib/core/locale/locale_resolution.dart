import 'package:flutter/material.dart';
import 'package:qareeb/l10n/generated/app_localizations.dart';

Locale? localeResolutionCallback(
  Locale? locale,
  Iterable<Locale> supportedLocales,
) {
  if (locale == null) return supportedLocales.first;

  final match = _firstLocaleWithLanguageCode(
    supportedLocales,
    locale.languageCode,
  );
  return match ?? supportedLocales.first;
}

Locale? _firstLocaleWithLanguageCode(
  Iterable<Locale> supportedLocales,
  String languageCode,
) {
  final matches = supportedLocales
      .where((supported) => supported.languageCode == languageCode)
      .toList();
  return matches.isEmpty ? null : matches.first;
}

List<Locale> get supportedLocales => AppLocalizations.supportedLocales;
