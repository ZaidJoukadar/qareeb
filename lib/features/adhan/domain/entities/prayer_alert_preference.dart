import 'package:qareeb/features/adhan/presentation/utils/prayer_schedule.dart';

enum PrayerAlertTiming { off, before, at, after }

enum PrayerAlertDelivery { sound, vibrate }

class PrayerAlertPreference {
  const PrayerAlertPreference({
    this.timing = PrayerAlertTiming.off,
    this.minutes = 15,
    this.delivery = PrayerAlertDelivery.sound,
  });

  final PrayerAlertTiming timing;
  final int minutes;
  final PrayerAlertDelivery delivery;

  bool get isEnabled => timing != PrayerAlertTiming.off;

  PrayerAlertPreference copyWith({
    PrayerAlertTiming? timing,
    int? minutes,
    PrayerAlertDelivery? delivery,
  }) {
    return PrayerAlertPreference(
      timing: timing ?? this.timing,
      minutes: minutes ?? this.minutes,
      delivery: delivery ?? this.delivery,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timing': timing.name,
      'minutes': minutes,
      'delivery': delivery.name,
    };
  }

  factory PrayerAlertPreference.fromJson(Map<String, dynamic> json) {
    return PrayerAlertPreference(
      timing: PrayerAlertTiming.values.firstWhere(
        (value) => value.name == json['timing'],
        orElse: () => PrayerAlertTiming.off,
      ),
      minutes: (json['minutes'] as num?)?.toInt() ?? 15,
      delivery: PrayerAlertDelivery.values.firstWhere(
        (value) => value.name == json['delivery'],
        orElse: () => PrayerAlertDelivery.sound,
      ),
    );
  }
}

typedef PrayerAlertPreferences = Map<PrayerName, PrayerAlertPreference>;

const prayerAlertMinuteOptions = [5, 10, 15, 30, 45, 60];
