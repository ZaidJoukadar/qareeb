import 'package:flutter/material.dart';
import 'package:qareeb/core/locale/data/locale_local_data_source.dart';
import 'package:qareeb/core/locale/domain/repositories/locale_repository.dart';
import 'package:qareeb/l10n/generated/app_localizations.dart';

class LocaleRepositoryImpl implements LocaleRepository {
  LocaleRepositoryImpl(this._localDataSource);

  final LocaleLocalDataSource _localDataSource;

  @override
  Future<Locale?> getSavedLocale() async {
    final code = await _localDataSource.getLanguageCode();
    if (code == null) return null;

    return _localeForLanguageCode(code);
  }

  Locale? _localeForLanguageCode(String code) {
    final matches = AppLocalizations.supportedLocales
        .where((locale) => locale.languageCode == code)
        .toList();
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    await _localDataSource.saveLanguageCode(locale.languageCode);
  }
}
