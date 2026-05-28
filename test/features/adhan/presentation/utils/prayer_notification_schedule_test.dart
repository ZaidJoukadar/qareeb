import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_alert_preference.dart';
import 'package:qareeb/features/adhan/presentation/utils/prayer_notification_schedule.dart';
import 'package:qareeb/features/adhan/presentation/utils/prayer_schedule.dart';

void main() {
  group('prayer notification schedule', () {
    final day = DateTime(2026, 5, 26);
    final slots = [
      PrayerSlot(
        name: PrayerName.fajr,
        time: '05:00',
        dateTime: day.add(const Duration(hours: 5)),
      ),
      PrayerSlot(
        name: PrayerName.dhuhr,
        time: '12:00',
        dateTime: day.add(const Duration(hours: 12)),
      ),
      PrayerSlot(
        name: PrayerName.maghrib,
        time: '18:00',
        dateTime: day.add(const Duration(hours: 18)),
      ),
    ];

    test('max before dhuhr is measured from fajr not midnight overflow', () {
      expect(maxBeforeMinutes(slots[1], slots), 7 * 60);
    });

    test('before notification is anchored to upcoming adhan', () {
      const preference = PrayerAlertPreference(
        timing: PrayerAlertTiming.before,
        minutes: 30,
      );

      final notificationAt = notificationTimeFor(
        preference: preference,
        slot: slots[2],
        slots: slots,
      );

      expect(notificationAt, day.add(const Duration(hours: 17, minutes: 30)));
    });

    test('before minutes are clamped to previous prayer boundary', () {
      const preference = PrayerAlertPreference(
        timing: PrayerAlertTiming.before,
        minutes: 400,
      );

      final notificationAt = notificationTimeFor(
        preference: preference,
        slot: slots[2],
        slots: slots,
      );

      expect(notificationAt, day.add(const Duration(hours: 12)));
    });
  });
}
