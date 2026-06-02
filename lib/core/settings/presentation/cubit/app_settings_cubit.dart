import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/constants/font_scale_defaults.dart';
import 'package:qareeb/core/constants/ummah_quran_mappings.dart';
import 'package:qareeb/core/constants/quran_editions.dart';
import 'package:qareeb/core/quran/quran_audio_reciter_settings.dart';
import 'package:qareeb/core/settings/data/app_settings_local_data_source.dart';
import 'package:qareeb/features/adhan/presentation/services/prayer_notification_service.dart';

part 'app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit({
    required AppSettingsLocalDataSource dataSource,
    required QuranAudioReciterSettings audioReciterSettings,
    required PrayerNotificationService notificationService,
  }) : _dataSource = dataSource,
       _audioReciterSettings = audioReciterSettings,
       _notificationService = notificationService,
       super(const AppSettingsState());

  final AppSettingsLocalDataSource _dataSource;
  final QuranAudioReciterSettings _audioReciterSettings;
  final PrayerNotificationService _notificationService;

  Future<void> load() async {
    final savedTheme = await _dataSource.getThemeMode();
    final notificationsEnabled = await _dataSource.getNotificationsEnabled();
    final appFontScale = await _dataSource.getAppFontScale();
    final quranFontScale = await _dataSource.getQuranFontScale();
    final savedReciter = await _dataSource.getQuranAudioReciter();
    final quranAudioReciter = _normalizeAudioReciter(savedReciter);
    if (quranAudioReciter != savedReciter) {
      await _dataSource.saveQuranAudioReciter(quranAudioReciter);
    }
    _audioReciterSettings.editionIdentifier = quranAudioReciter;

    emit(
      state.copyWith(
        themeMode: savedTheme ?? ThemeMode.light,
        notificationsEnabled: notificationsEnabled,
        appFontScale: _clampFontScale(appFontScale),
        quranFontScale: _clampFontScale(quranFontScale),
        quranAudioReciter: quranAudioReciter,
        status: AppSettingsStatus.ready,
      ),
    );
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _dataSource.saveThemeMode(themeMode);
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _dataSource.setNotificationsEnabled(enabled);
    emit(state.copyWith(notificationsEnabled: enabled));
    if (enabled) {
      await _notificationService.rescheduleFromCache();
    } else {
      await _notificationService.cancelAll();
    }
  }

  Future<void> setAppFontScale(double scale) async {
    final clamped = _clampFontScale(scale);
    await _dataSource.saveAppFontScale(clamped);
    emit(state.copyWith(appFontScale: clamped));
  }

  Future<void> setQuranFontScale(double scale) async {
    final clamped = _clampFontScale(scale);
    await _dataSource.saveQuranFontScale(clamped);
    emit(state.copyWith(quranFontScale: clamped));
  }

  Future<void> setQuranAudioReciter(String editionIdentifier) async {
    if (editionIdentifier == state.quranAudioReciter) return;
    if (!_isAyahAudioAvailable(editionIdentifier)) return;
    await _dataSource.saveQuranAudioReciter(editionIdentifier);
    _audioReciterSettings.editionIdentifier = editionIdentifier;
    emit(state.copyWith(quranAudioReciter: editionIdentifier));
  }

  String _normalizeAudioReciter(String editionIdentifier) {
    if (_isAyahAudioAvailable(editionIdentifier)) {
      return editionIdentifier;
    }
    return QuranEditions.audioRecitation;
  }

  bool _isAyahAudioAvailable(String editionIdentifier) {
    return UmmahQuranMappings.isAyahAudioAvailableForReciterId(
      UmmahQuranMappings.reciterIdForEdition(editionIdentifier),
    );
  }

  static double _clampFontScale(double scale) {
    return scale.clamp(FontScaleDefaults.min, FontScaleDefaults.max);
  }
}
