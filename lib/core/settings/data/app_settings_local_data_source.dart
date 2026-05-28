import 'package:flutter/material.dart';
import 'package:qareeb/core/constants/font_scale_defaults.dart';
import 'package:qareeb/core/constants/quran_editions.dart';
import 'package:qareeb/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppSettingsLocalDataSource {
  Future<ThemeMode?> getThemeMode();
  Future<void> saveThemeMode(ThemeMode themeMode);
  Future<bool> getNotificationsEnabled();
  Future<void> setNotificationsEnabled(bool enabled);
  Future<double> getFontScale();
  Future<void> saveFontScale(double scale);
  Future<String> getQuranAudioReciter();
  Future<void> saveQuranAudioReciter(String editionIdentifier);
}

class AppSettingsLocalDataSourceImpl implements AppSettingsLocalDataSource {
  AppSettingsLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<ThemeMode?> getThemeMode() async {
    final value = _prefs.getString(StorageKeys.themeMode);
    return switch (value) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => null,
    };
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final value = switch (themeMode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(StorageKeys.themeMode, value);
  }

  @override
  Future<bool> getNotificationsEnabled() async {
    return _prefs.getBool(StorageKeys.notificationsEnabled) ?? false;
  }

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(StorageKeys.notificationsEnabled, enabled);
  }

  @override
  Future<double> getFontScale() async {
    final stored = _prefs.getDouble(StorageKeys.fontScale);
    if (stored != null) {
      return stored;
    }

    final legacyApp = _prefs.getDouble(StorageKeys.appFontScale);
    final legacyQuran = _prefs.getDouble(StorageKeys.quranFontScale);
    final migrated = legacyApp ?? legacyQuran;
    if (migrated != null) {
      await saveFontScale(migrated);
      return migrated;
    }

    return FontScaleDefaults.defaultScale;
  }

  @override
  Future<void> saveFontScale(double scale) async {
    await _prefs.setDouble(StorageKeys.fontScale, scale);
  }

  @override
  Future<String> getQuranAudioReciter() async {
    return _prefs.getString(StorageKeys.quranAudioReciter) ??
        QuranEditions.audioRecitation;
  }

  @override
  Future<void> saveQuranAudioReciter(String editionIdentifier) async {
    await _prefs.setString(StorageKeys.quranAudioReciter, editionIdentifier);
  }
}
