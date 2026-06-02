import 'package:qareeb/features/adhan/domain/entities/prayer_alert_preference.dart';
import 'package:qareeb/features/adhan/presentation/utils/prayer_schedule.dart';

class ScheduledPrayerNotification {
  const ScheduledPrayerNotification({
    required this.id,
    required this.prayer,
    required this.scheduledAt,
    required this.adhanAt,
    required this.preference,
  });

  final int id;
  final PrayerName prayer;
  final DateTime scheduledAt;
  final DateTime adhanAt;
  final PrayerAlertPreference preference;
}

Duration maxBeforeOffset(PrayerSlot slot, List<PrayerSlot> slots) {
  final index = slots.indexWhere((entry) => entry.name == slot.name);
  if (index <= 0) {
    final dayStart = DateTime(
      slot.dateTime.year,
      slot.dateTime.month,
      slot.dateTime.day,
    );
    return slot.dateTime.difference(dayStart);
  }

  return slot.dateTime.difference(slots[index - 1].dateTime);
}

Duration maxAfterOffset(PrayerSlot slot, List<PrayerSlot> slots) {
  final index = slots.indexWhere((entry) => entry.name == slot.name);
  if (index < 0 || index >= slots.length - 1) {
    final dayEnd = DateTime(
      slot.dateTime.year,
      slot.dateTime.month,
      slot.dateTime.day,
    ).add(const Duration(days: 1));
    return dayEnd.difference(slot.dateTime);
  }

  return slots[index + 1].dateTime.difference(slot.dateTime);
}

int maxBeforeMinutes(PrayerSlot slot, List<PrayerSlot> slots) {
  return maxBeforeOffset(slot, slots).inMinutes;
}

int maxAfterMinutes(PrayerSlot slot, List<PrayerSlot> slots) {
  return maxAfterOffset(slot, slots).inMinutes;
}

int clampMinutesForTiming({
  required PrayerAlertTiming timing,
  required int minutes,
  required PrayerSlot slot,
  required List<PrayerSlot> slots,
}) {
  if (timing == PrayerAlertTiming.at || timing == PrayerAlertTiming.off) {
    return 0;
  }

  final maxMinutes = switch (timing) {
    PrayerAlertTiming.before => maxBeforeMinutes(slot, slots),
    PrayerAlertTiming.after => maxAfterMinutes(slot, slots),
    PrayerAlertTiming.at || PrayerAlertTiming.off => 0,
  };

  if (maxMinutes <= 0) {
    return 1;
  }

  return minutes.clamp(1, maxMinutes);
}

List<int> availableMinuteOptions({
  required PrayerAlertTiming timing,
  required PrayerSlot slot,
  required List<PrayerSlot> slots,
}) {
  if (timing == PrayerAlertTiming.at || timing == PrayerAlertTiming.off) {
    return const [];
  }

  final maxMinutes = switch (timing) {
    PrayerAlertTiming.before => maxBeforeMinutes(slot, slots),
    PrayerAlertTiming.after => maxAfterMinutes(slot, slots),
    PrayerAlertTiming.at || PrayerAlertTiming.off => 0,
  };

  final options = prayerAlertMinuteOptions
      .where((minutes) => minutes <= maxMinutes)
      .toList(growable: false);

  if (options.isEmpty && maxMinutes > 0) {
    return [maxMinutes];
  }

  return options;
}

DateTime? notificationTimeFor({
  required PrayerAlertPreference preference,
  required PrayerSlot slot,
  required List<PrayerSlot> slots,
}) {
  if (!preference.isEnabled) {
    return null;
  }

  final adhanTime = slot.dateTime;

  return switch (preference.timing) {
    PrayerAlertTiming.at => adhanTime,
    PrayerAlertTiming.before => adhanTime.subtract(
      Duration(
        minutes: clampMinutesForTiming(
          timing: preference.timing,
          minutes: preference.minutes,
          slot: slot,
          slots: slots,
        ),
      ),
    ),
    PrayerAlertTiming.after => adhanTime.add(
      Duration(
        minutes: clampMinutesForTiming(
          timing: preference.timing,
          minutes: preference.minutes,
          slot: slot,
          slots: slots,
        ),
      ),
    ),
    PrayerAlertTiming.off => null,
  };
}

int notificationIdFor({
  required int dayIndex,
  required PrayerName prayer,
}) {
  return (dayIndex * 10) + prayer.index;
}

List<ScheduledPrayerNotification> buildScheduledNotifications({
  required List<PrayerDaySlots> days,
  required PrayerAlertPreferences preferences,
  required DateTime now,
}) {
  return days.asMap().entries.expand((dayEntry) {
    final dayIndex = dayEntry.key;
    final day = dayEntry.value;
    return day.slots
        .map((slot) {
          final preference =
              preferences[slot.name] ?? const PrayerAlertPreference();
          final notificationAt = notificationTimeFor(
            preference: preference,
            slot: slot,
            slots: day.slots,
          );

          if (notificationAt == null || !notificationAt.isAfter(now)) {
            return null;
          }

          return ScheduledPrayerNotification(
            id: notificationIdFor(dayIndex: dayIndex, prayer: slot.name),
            prayer: slot.name,
            scheduledAt: notificationAt,
            adhanAt: slot.dateTime,
            preference: preference,
          );
        })
        .whereType<ScheduledPrayerNotification>();
  }).toList(growable: false);
}

class PrayerDaySlots {
  const PrayerDaySlots({
    required this.date,
    required this.slots,
  });

  final DateTime date;
  final List<PrayerSlot> slots;
}
