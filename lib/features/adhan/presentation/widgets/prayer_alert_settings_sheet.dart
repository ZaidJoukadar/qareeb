import 'package:flutter/material.dart';
import 'package:qareeb/core/presentation/bottom_sheets/app_bar_modal_bottom_sheet.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/adhan/data/datasources/prayer_alert_preferences_local_data_source.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_alert_preference.dart';
import 'package:qareeb/features/adhan/presentation/services/prayer_notification_service.dart';
import 'package:qareeb/features/adhan/presentation/utils/prayer_notification_schedule.dart';
import 'package:qareeb/features/adhan/presentation/utils/prayer_schedule.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

Future<void> showPrayerAlertSettingsSheet({
  required BuildContext context,
  required PrayerName prayer,
  required List<PrayerSlot> slots,
  required PrayerAlertPreference initialPreference,
  required PrayerAlertPreferencesLocalDataSource preferencesDataSource,
  required PrayerNotificationService notificationService,
  required PrayerNotificationCopyProvider copyProvider,
  required Future<void> Function() onSaved,
}) {
  return showAppBarModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.cream,
    builder: (_) => _PrayerAlertSettingsSheet(
      prayer: prayer,
      slots: slots,
      initialPreference: initialPreference,
      preferencesDataSource: preferencesDataSource,
      notificationService: notificationService,
      copyProvider: copyProvider,
      onSaved: onSaved,
    ),
  );
}

class _PrayerAlertSettingsSheet extends StatefulWidget {
  const _PrayerAlertSettingsSheet({
    required this.prayer,
    required this.slots,
    required this.initialPreference,
    required this.preferencesDataSource,
    required this.notificationService,
    required this.copyProvider,
    required this.onSaved,
  });

  final PrayerName prayer;
  final List<PrayerSlot> slots;
  final PrayerAlertPreference initialPreference;
  final PrayerAlertPreferencesLocalDataSource preferencesDataSource;
  final PrayerNotificationService notificationService;
  final PrayerNotificationCopyProvider copyProvider;
  final Future<void> Function() onSaved;

  @override
  State<_PrayerAlertSettingsSheet> createState() =>
      _PrayerAlertSettingsSheetState();
}

class _PrayerAlertSettingsSheetState extends State<_PrayerAlertSettingsSheet> {
  late PrayerAlertTiming _timing = widget.initialPreference.timing;
  late int _minutes = widget.initialPreference.minutes;
  late PrayerAlertDelivery _delivery = widget.initialPreference.delivery;
  bool _isSaving = false;

  PrayerSlot get _slot =>
      widget.slots.firstWhere((entry) => entry.name == widget.prayer);

  List<int> get _minuteOptions => availableMinuteOptions(
    timing: _timing,
    slot: _slot,
    slots: widget.slots,
  );

  int get _maxBeforeMinutes => maxBeforeMinutes(_slot, widget.slots);

  int get _maxAfterMinutes => maxAfterMinutes(_slot, widget.slots);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final prayerLabel = _prayerLabel(context, widget.prayer);

    return AppBarModalScrollBody(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.adhanAlertSettingsTitle(prayerLabel),
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.adhanAlertTimingSection,
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.navy.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _TimingChip(
                  label: l10n.adhanAlertOff,
                  selected: _timing == PrayerAlertTiming.off,
                  onTap: () => setState(() => _timing = PrayerAlertTiming.off),
                ),
                _TimingChip(
                  label: l10n.adhanAlertBefore,
                  selected: _timing == PrayerAlertTiming.before,
                  onTap: () => _selectTiming(PrayerAlertTiming.before),
                ),
                _TimingChip(
                  label: l10n.adhanAlertAtAdhan,
                  selected: _timing == PrayerAlertTiming.at,
                  onTap: () => _selectTiming(PrayerAlertTiming.at),
                ),
                _TimingChip(
                  label: l10n.adhanAlertAfter,
                  selected: _timing == PrayerAlertTiming.after,
                  onTap: () => _selectTiming(PrayerAlertTiming.after),
                ),
              ],
            ),
            if (_timing == PrayerAlertTiming.before ||
                _timing == PrayerAlertTiming.after) ...[
              const SizedBox(height: 20),
              Text(
                l10n.adhanAlertMinutesSection,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.navy.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _minuteOptions
                    .map(
                      (minutes) => _TimingChip(
                        label: l10n.adhanAlertMinutesLabel(minutes),
                        selected: _minutes == minutes,
                        onTap: () => setState(() => _minutes = minutes),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
              Text(
                _timing == PrayerAlertTiming.before
                    ? l10n.adhanAlertMaxBeforeHint(
                        _maxBeforeMinutes,
                        prayerLabel,
                      )
                    : l10n.adhanAlertMaxAfterHint(
                        _maxAfterMinutes,
                        prayerLabel,
                      ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.navy.withValues(alpha: 0.55),
                ),
              ),
            ],
            if (_timing != PrayerAlertTiming.off) ...[
              const SizedBox(height: 20),
              Text(
                l10n.adhanAlertDeliverySection,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.navy.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _DeliveryOption(
                      icon: Icons.volume_up_rounded,
                      label: l10n.adhanAlertSound,
                      selected: _delivery == PrayerAlertDelivery.sound,
                      onTap: () => setState(
                        () => _delivery = PrayerAlertDelivery.sound,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DeliveryOption(
                      icon: Icons.vibration_rounded,
                      label: l10n.adhanAlertVibrate,
                      selected: _delivery == PrayerAlertDelivery.vibrate,
                      onTap: () => setState(
                        () => _delivery = PrayerAlertDelivery.vibrate,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.navy,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.adhanAlertSave),
            ),
          ],
        ),
      ),
    );
  }

  void _selectTiming(PrayerAlertTiming timing) {
    setState(() {
      _timing = timing;
      if (timing == PrayerAlertTiming.before ||
          timing == PrayerAlertTiming.after) {
        _minutes = clampMinutesForTiming(
          timing: timing,
          minutes: _minutes,
          slot: _slot,
          slots: widget.slots,
        );
        final options = availableMinuteOptions(
          timing: timing,
          slot: _slot,
          slots: widget.slots,
        );
        if (options.isNotEmpty && !options.contains(_minutes)) {
          _minutes = options.first;
        }
      }
    });
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    final preference = PrayerAlertPreference(
      timing: _timing,
      minutes: _timing == PrayerAlertTiming.at || _timing == PrayerAlertTiming.off
          ? 0
          : clampMinutesForTiming(
              timing: _timing,
              minutes: _minutes,
              slot: _slot,
              slots: widget.slots,
            ),
      delivery: _delivery,
    );

    await widget.preferencesDataSource.save(widget.prayer, preference);

    if (_timing != PrayerAlertTiming.off) {
      final granted = await widget.notificationService.requestPermissions();
      if (!granted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.adhanNotificationPermissionDenied)),
        );
      }
    }

    await widget.onSaved();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  String _prayerLabel(BuildContext context, PrayerName prayer) {
    final l10n = context.l10n;
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

class _TimingChip extends StatelessWidget {
  const _TimingChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.gold.withValues(alpha: 0.35),
      checkmarkColor: AppColors.navy,
      labelStyle: TextStyle(
        color: AppColors.navy,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
      side: BorderSide(
        color: selected
            ? AppColors.gold
            : AppColors.navy.withValues(alpha: 0.15),
      ),
    );
  }
}

class _DeliveryOption extends StatelessWidget {
  const _DeliveryOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected
              ? AppColors.gold.withValues(alpha: 0.25)
              : Colors.white,
          border: Border.all(
            color: selected
                ? AppColors.gold
                : AppColors.navy.withValues(alpha: 0.12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, color: AppColors.gold),
              const SizedBox(height: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.navy,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
