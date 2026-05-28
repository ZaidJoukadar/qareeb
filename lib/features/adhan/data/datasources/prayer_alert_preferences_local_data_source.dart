import 'dart:convert';

import 'package:qareeb/core/constants/storage_keys.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_alert_preference.dart';
import 'package:qareeb/features/adhan/presentation/utils/prayer_schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PrayerAlertPreferencesLocalDataSource {
  Future<PrayerAlertPreferences> loadAll();
  Future<void> save(PrayerName prayer, PrayerAlertPreference preference);
  Future<void> saveAll(PrayerAlertPreferences preferences);
}

class PrayerAlertPreferencesLocalDataSourceImpl
    implements PrayerAlertPreferencesLocalDataSource {
  PrayerAlertPreferencesLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<PrayerAlertPreferences> loadAll() async {
    final raw = _prefs.getString(StorageKeys.prayerAlertPreferences);
    if (raw == null || raw.isEmpty) {
      return _defaultPreferences();
    }

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return Map<PrayerName, PrayerAlertPreference>.fromEntries(
        PrayerName.values.map(
          (prayer) => MapEntry(
            prayer,
            PrayerAlertPreference.fromJson(
              decoded[prayer.name] as Map<String, dynamic>? ?? const {},
            ),
          ),
        ),
      );
    } on Object {
      return _defaultPreferences();
    }
  }

  @override
  Future<void> save(
    PrayerName prayer,
    PrayerAlertPreference preference,
  ) async {
    final current = await loadAll();
    current[prayer] = preference;
    await saveAll(current);
  }

  @override
  Future<void> saveAll(PrayerAlertPreferences preferences) async {
    final encoded = jsonEncode(
      Map<String, dynamic>.fromEntries(
        preferences.entries.map(
          (entry) => MapEntry(entry.key.name, entry.value.toJson()),
        ),
      ),
    );
    await _prefs.setString(StorageKeys.prayerAlertPreferences, encoded);
  }

  PrayerAlertPreferences _defaultPreferences() {
    return Map<PrayerName, PrayerAlertPreference>.fromEntries(
      PrayerName.values.map(
        (prayer) => MapEntry(prayer, const PrayerAlertPreference()),
      ),
    );
  }
}
