import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/adhan/data/datasources/prayer_alert_preferences_local_data_source.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_alert_preference.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';
import 'package:qareeb/features/adhan/presentation/cubit/adhan_cubit.dart';
import 'package:qareeb/features/adhan/presentation/services/prayer_notification_service.dart';
import 'package:qareeb/features/adhan/presentation/utils/adhan_date_formatting.dart';
import 'package:qareeb/features/adhan/presentation/utils/prayer_notification_copy.dart';
import 'package:qareeb/features/adhan/presentation/utils/prayer_schedule.dart';
import 'package:qareeb/features/adhan/presentation/widgets/prayer_alert_settings_sheet.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class PrayerTimesList extends StatefulWidget {
  const PrayerTimesList({
    required this.day,
    required this.isToday,
    super.key,
  });

  final PrayerDay day;
  final bool isToday;

  @override
  State<PrayerTimesList> createState() => _PrayerTimesListState();
}

class _PrayerTimesListState extends State<PrayerTimesList> {
  final _preferencesDataSource = getIt<PrayerAlertPreferencesLocalDataSource>();
  final _notificationService = getIt<PrayerNotificationService>();

  PrayerAlertPreferences _preferences = {};
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final preferences = await _preferencesDataSource.loadAll();
    if (!mounted) return;
    setState(() => _preferences = preferences);
  }

  Future<void> _openAlertSettings(PrayerName name) async {
    final slots = buildPrayerSlots(widget.day);
    final preference =
        _preferences[name] ?? const PrayerAlertPreference();
    final l10n = context.l10n;
    final cubit = context.read<AdhanCubit>();

    await showPrayerAlertSettingsSheet(
      context: context,
      prayer: name,
      slots: slots,
      initialPreference: preference,
      preferencesDataSource: _preferencesDataSource,
      notificationService: _notificationService,
      copyProvider: L10nPrayerNotificationCopyProvider(l10n),
      onSaved: () async {
        await _loadPreferences();
        await cubit.rescheduleNotifications();
      },
    );
  }

  String _labelFor(PrayerName name) {
    final l10n = context.l10n;
    return switch (name) {
      PrayerName.fajr => l10n.prayerFajr,
      PrayerName.sunrise => l10n.prayerSunrise,
      PrayerName.dhuhr => l10n.prayerDhuhr,
      PrayerName.asr => l10n.prayerAsr,
      PrayerName.maghrib => l10n.prayerMaghrib,
      PrayerName.isha => l10n.prayerIsha,
    };
  }

  @override
  Widget build(BuildContext context) {
    final slots = buildPrayerSlots(widget.day);
    final nextSlot = widget.isToday ? findNextPrayerSlot(slots, _now) : null;

    return Padding(
      padding: Responsive.pagePadding(context).copyWith(top: 8),
      child: Column(
        children: slots
            .map(
              (slot) => _PrayerTimeRow(
                label: _labelFor(slot.name),
                time: slot.time,
                preference:
                    _preferences[slot.name] ?? const PrayerAlertPreference(),
                isNext: nextSlot?.name == slot.name,
                countdown: nextSlot?.name == slot.name
                    ? slot.dateTime.difference(_now)
                    : null,
                onAlertTap: () => _openAlertSettings(slot.name),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _PrayerTimeRow extends StatelessWidget {
  const _PrayerTimeRow({
    required this.label,
    required this.time,
    required this.preference,
    required this.isNext,
    required this.onAlertTap,
    this.countdown,
  });

  final String label;
  final String time;
  final PrayerAlertPreference preference;
  final bool isNext;
  final Duration? countdown;
  final VoidCallback onAlertTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontWeight = isNext ? FontWeight.w700 : FontWeight.w400;
    final textStyle = theme.textTheme.bodyLarge?.copyWith(
      color: AppColors.navy,
      fontWeight: fontWeight,
    );
    final timeStyle = textStyle?.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          _AlertIcon(preference: preference, onTap: onAlertTap),
          if (countdown != null && !countdown!.isNegative) ...[
            const SizedBox(width: 8),
            Text(
              formatAdhanCountdown(countdown!),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w500,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          ),
          Text(time, style: timeStyle),
        ],
      ),
    );
  }
}

class _AlertIcon extends StatelessWidget {
  const _AlertIcon({required this.preference, required this.onTap});

  final PrayerAlertPreference preference;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = switch (preference.timing) {
      PrayerAlertTiming.off => Icons.notifications_off_outlined,
      PrayerAlertTiming.before => preference.delivery == PrayerAlertDelivery.sound
          ? Icons.notifications_active_outlined
          : Icons.vibration,
      PrayerAlertTiming.at => preference.delivery == PrayerAlertDelivery.sound
          ? Icons.volume_up
          : Icons.vibration,
      PrayerAlertTiming.after => preference.delivery == PrayerAlertDelivery.sound
          ? Icons.schedule_outlined
          : Icons.vibration,
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, color: AppColors.gold, size: 22),
      ),
    );
  }
}
