import 'dart:convert';

import 'package:qareeb/core/constants/storage_keys.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_timings.dart';
import 'package:qareeb/features/adhan/domain/entities/user_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AdhanLocalDataSource {
  Future<List<PrayerDay>?> getPrayerCalendar({
    required UserLocation location,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<void> savePrayerCalendar({
    required UserLocation location,
    required List<PrayerDay> days,
  });

  Future<void> purgeExpiredEntries();
}

class AdhanLocalDataSourceImpl implements AdhanLocalDataSource {
  AdhanLocalDataSourceImpl(this._prefs);

  static const _ttl = Duration(hours: 24);

  final SharedPreferences _prefs;

  @override
  Future<List<PrayerDay>?> getPrayerCalendar({
    required UserLocation location,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await purgeExpiredEntries();

    final cache = _readCache();
    final result = <PrayerDay>[];
    var current = _dateOnly(startDate);
    final last = _dateOnly(endDate);

    while (!current.isAfter(last)) {
      final entry = cache[_cacheKey(location: location, date: current)];
      if (entry == null) {
        return null;
      }
      result.add(_prayerDayFromJson(entry['day'] as Map<String, dynamic>));
      current = current.add(const Duration(days: 1));
    }

    return result;
  }

  @override
  Future<void> savePrayerCalendar({
    required UserLocation location,
    required List<PrayerDay> days,
  }) async {
    final cache = _readCache();
    final now = DateTime.now().toUtc();
    final expiresAt = now.add(_ttl).toIso8601String();

    for (final day in days) {
      final date = _dateOnly(day.date);
      cache[_cacheKey(location: location, date: date)] = {
        'expiresAt': expiresAt,
        'day': _prayerDayToJson(day),
      };
    }

    await _prefs.setString(StorageKeys.adhanPrayerDayCache, jsonEncode(cache));
  }

  @override
  Future<void> purgeExpiredEntries() async {
    final cache = _readCache();
    if (cache.isEmpty) {
      return;
    }

    final now = DateTime.now().toUtc();
    cache.removeWhere((_, value) {
      final expiresAtRaw = value['expiresAt'] as String?;
      if (expiresAtRaw == null) {
        return true;
      }
      final expiresAt = DateTime.tryParse(expiresAtRaw);
      if (expiresAt == null) {
        return true;
      }
      return now.isAfter(expiresAt);
    });

    await _prefs.setString(StorageKeys.adhanPrayerDayCache, jsonEncode(cache));
  }

  Map<String, dynamic> _readCache() {
    final raw = _prefs.getString(StorageKeys.adhanPrayerDayCache);
    if (raw == null || raw.isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded;
    } on Object {
      return <String, dynamic>{};
    }
  }

  String _cacheKey({required UserLocation location, required DateTime date}) {
    return '${location.latitude}|${location.longitude}|${_formatIsoDate(date)}';
  }

  String _formatIsoDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Map<String, dynamic> _prayerDayToJson(PrayerDay day) {
    return {
      'date': day.date.toIso8601String(),
      'readableDate': day.readableDate,
      'weekday': day.weekday,
      'timings': {
        'fajr': day.timings.fajr,
        'sunrise': day.timings.sunrise,
        'dhuhr': day.timings.dhuhr,
        'asr': day.timings.asr,
        'maghrib': day.timings.maghrib,
        'isha': day.timings.isha,
      },
      'hijriDate': day.hijriDate,
      'hijriWeekdayEn': day.hijriWeekdayEn,
      'hijriWeekdayAr': day.hijriWeekdayAr,
      'hijriDay': day.hijriDay,
      'hijriMonthEn': day.hijriMonthEn,
      'hijriMonthAr': day.hijriMonthAr,
      'hijriYear': day.hijriYear,
    };
  }

  PrayerDay _prayerDayFromJson(Map<String, dynamic> json) {
    final timings = json['timings'] as Map<String, dynamic>;
    return PrayerDay(
      date: DateTime.parse(json['date'] as String),
      readableDate: json['readableDate'] as String? ?? '',
      weekday: json['weekday'] as String? ?? '',
      timings: PrayerTimings(
        fajr: timings['fajr'] as String? ?? '',
        sunrise: timings['sunrise'] as String? ?? '',
        dhuhr: timings['dhuhr'] as String? ?? '',
        asr: timings['asr'] as String? ?? '',
        maghrib: timings['maghrib'] as String? ?? '',
        isha: timings['isha'] as String? ?? '',
      ),
      hijriDate: json['hijriDate'] as String? ?? '',
      hijriWeekdayEn: json['hijriWeekdayEn'] as String? ?? '',
      hijriWeekdayAr: json['hijriWeekdayAr'] as String? ?? '',
      hijriDay: json['hijriDay'] as String? ?? '',
      hijriMonthEn: json['hijriMonthEn'] as String? ?? '',
      hijriMonthAr: json['hijriMonthAr'] as String? ?? '',
      hijriYear: json['hijriYear'] as String? ?? '',
    );
  }
}
