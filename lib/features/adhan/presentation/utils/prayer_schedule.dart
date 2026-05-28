import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_timings.dart';

enum PrayerName { fajr, sunrise, dhuhr, asr, maghrib, isha }

class PrayerSlot {
  const PrayerSlot({
    required this.name,
    required this.time,
    required this.dateTime,
  });

  final PrayerName name;
  final String time;
  final DateTime dateTime;
}

List<PrayerSlot> buildPrayerSlots(PrayerDay day) {
  final entries = <(PrayerName, String)>[
    (PrayerName.fajr, day.timings.fajr),
    (PrayerName.sunrise, day.timings.sunrise),
    (PrayerName.dhuhr, day.timings.dhuhr),
    (PrayerName.asr, day.timings.asr),
    (PrayerName.maghrib, day.timings.maghrib),
    (PrayerName.isha, day.timings.isha),
  ];

  return entries
      .map(
        (entry) => PrayerSlot(
          name: entry.$1,
          time: entry.$2,
          dateTime: parsePrayerTime(day.date, entry.$2),
        ),
      )
      .toList();
}

DateTime parsePrayerTime(DateTime day, String time) {
  final parts = time.split(':');
  if (parts.length < 2) {
    throw FormatException('Invalid prayer time: $time');
  }

  return DateTime(
    day.year,
    day.month,
    day.day,
    int.parse(parts[0]),
    int.parse(parts[1]),
  );
}

PrayerSlot? findNextPrayerSlot(List<PrayerSlot> slots, DateTime now) {
  final upcoming = slots.where((slot) => slot.dateTime.isAfter(now));
  return upcoming.isEmpty ? null : upcoming.first;
}

String prayerTimeFor(PrayerTimings timings, PrayerName name) {
  return switch (name) {
    PrayerName.fajr => timings.fajr,
    PrayerName.sunrise => timings.sunrise,
    PrayerName.dhuhr => timings.dhuhr,
    PrayerName.asr => timings.asr,
    PrayerName.maghrib => timings.maghrib,
    PrayerName.isha => timings.isha,
  };
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
