import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/locale/domain/usecases/get_saved_locale.dart';
import 'package:qareeb/core/locale/domain/usecases/save_locale.dart';
import 'package:qareeb/core/monitoring/sentry_scope_config.dart';
import 'package:qareeb/l10n/generated/app_localizations.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit({
    required GetSavedLocale getSavedLocale,
    required SaveLocale saveLocale,
  }) : _getSavedLocale = getSavedLocale,
       _saveLocale = saveLocale,
       super(const LocaleState());

  final GetSavedLocale _getSavedLocale;
  final SaveLocale _saveLocale;

  Future<void> load() async {
    final saved = await _getSavedLocale();
    emit(
      state.copyWith(
        locale: saved,
        status: LocaleStatus.ready,
      ),
    );
    if (saved != null) {
      await SentryScopeConfig.setLocaleTag(saved.languageCode);
    }
  }

  Future<void> setLocale(Locale locale) async {
    await _saveLocale(locale);
    emit(state.copyWith(locale: locale, status: LocaleStatus.ready));
    await SentryScopeConfig.setLocaleTag(locale.languageCode);
  }

  static Locale resolveLocale(Locale? deviceLocale, Locale? savedLocale) {
    if (savedLocale != null) return savedLocale;

    final deviceMatch = deviceLocale == null
        ? null
        : _firstSupportedMatch(deviceLocale);

    return deviceMatch ?? AppLocalizations.supportedLocales.first;
  }

  static Locale? _firstSupportedMatch(Locale deviceLocale) {
    final matches = AppLocalizations.supportedLocales
        .where(
          (supported) =>
              supported.languageCode == deviceLocale.languageCode,
        )
        .toList();
    return matches.isEmpty ? null : matches.first;
  }
}
