import 'package:qareeb/features/adhan/domain/entities/prayer_alert_preference.dart';
import 'package:qareeb/features/adhan/presentation/services/prayer_notification_service.dart';
import 'package:qareeb/features/adhan/presentation/utils/prayer_schedule.dart';
import 'package:qareeb/l10n/generated/app_localizations.dart';

class L10nPrayerNotificationCopyProvider
    implements PrayerNotificationCopyProvider {
  L10nPrayerNotificationCopyProvider(this.l10n);

  final AppLocalizations l10n;

  @override
  PrayerNotificationCopy copyFor({
    required PrayerName prayer,
    required PrayerAlertPreference preference,
  }) {
    final prayerLabel = _prayerLabel(prayer);

    return (
      title: l10n.adhanNotificationTitle(prayerLabel),
      body: switch (preference.timing) {
        PrayerAlertTiming.before => l10n.adhanNotificationBodyBefore(
          preference.minutes,
          prayerLabel,
        ),
        PrayerAlertTiming.at => l10n.adhanNotificationBodyAt(prayerLabel),
        PrayerAlertTiming.after => l10n.adhanNotificationBodyAfter(
          preference.minutes,
          prayerLabel,
        ),
        PrayerAlertTiming.off => '',
      },
    );
  }

  String _prayerLabel(PrayerName prayer) {
    return switch (prayer) {
      PrayerName.fajr => l10n.prayerFajr,
      PrayerName.sunrise => l10n.prayerSunrise,
      PrayerName.dhuhr => l10n.prayerDhuhr,
      PrayerName.asr => l10n.prayerAsr,
      PrayerName.maghrib => l10n.prayerMaghrib,
      PrayerName.isha => l10n.prayerIsha,
    };
  }
}
