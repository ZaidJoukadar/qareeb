import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/adhan/presentation/cubit/adhan_cubit.dart';
import 'package:qareeb/features/adhan/presentation/cubit/adhan_state.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';
import 'package:qareeb/features/adhan/presentation/widgets/adhan_date_picker_sheet.dart';
import 'package:qareeb/features/adhan/presentation/widgets/adhan_day_panel.dart';
import 'package:qareeb/features/adhan/presentation/widgets/city_search_sheet.dart';
import 'package:qareeb/features/adhan/presentation/utils/prayer_notification_copy.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class AdhanPage extends StatelessWidget {
  const AdhanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdhanCubit>()..load(),
      child: const _AdhanView(),
    );
  }
}

class _AdhanView extends StatefulWidget {
  const _AdhanView();

  @override
  State<_AdhanView> createState() => _AdhanViewState();
}

class _AdhanViewState extends State<_AdhanView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<AdhanCubit>().setNotificationCopyProvider(
      L10nPrayerNotificationCopyProvider(context.l10n),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.navy,
        title: BlocBuilder<AdhanCubit, AdhanState>(
          buildWhen: (previous, current) =>
              previous.location != current.location,
          builder: (context, state) {
            final location = state.location;
            if (location == null) {
              return Text(l10n.adhanTitle);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.adhanTitle),
                Text(
                  location.displayLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.navy.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: l10n.adhanSearchCityTitle,
            onPressed: () => showCitySearchSheet(context),
          ),
        ],
      ),
      body: BlocBuilder<AdhanCubit, AdhanState>(
        builder: (context, state) {
          return switch (state.status) {
            AdhanStatus.initial || AdhanStatus.loading => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppColors.gold),
                  const SizedBox(height: 16),
                  Text(
                    l10n.adhanLoading,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
            AdhanStatus.failure => _AdhanErrorView(state: state),
            AdhanStatus.success => RefreshIndicator(
              color: AppColors.gold,
              onRefresh: () => context.read<AdhanCubit>().refresh(),
              child: _AdhanSuccessView(state: state),
            ),
          };
        },
      ),
    );
  }
}

class _AdhanSuccessView extends StatefulWidget {
  const _AdhanSuccessView({required this.state});

  final AdhanState state;

  @override
  State<_AdhanSuccessView> createState() => _AdhanSuccessViewState();
}

class _AdhanSuccessViewState extends State<_AdhanSuccessView> {
  DateTime? _selectedDate;

  @override
  void didUpdateWidget(covariant _AdhanSuccessView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.prayerDays.isEmpty) {
      _selectedDate = null;
      return;
    }

    final selected = _selectedDate;
    if (selected == null) {
      _selectedDate = _dateOnly(widget.state.prayerDays.first.date);
      return;
    }

    final hasSelectedDay = widget.state.prayerDays.any(
      (day) => _dateOnly(day.date) == selected,
    );
    if (!hasSelectedDay) {
      _selectedDate = _dateOnly(widget.state.prayerDays.first.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = widget.state.prayerDays;
    if (days.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [SizedBox(height: 200)],
      );
    }

    final effectiveSelectedDate = _selectedDate ?? _dateOnly(days.first.date);
    final selectedDay = _findDayForDate(days, effectiveSelectedDate) ?? days.first;
    _selectedDate ??= _dateOnly(selectedDay.date);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final selectedDate = DateTime(
      selectedDay.date.year,
      selectedDay.date.month,
      selectedDay.date.day,
    );
    final locale = Localizations.localeOf(context).toLanguageTag();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        AdhanDayPanel(
          day: selectedDay,
          locale: locale,
          isToday: selectedDate == todayDate,
          onDateTap: () => showAdhanDatePickerSheet(
            context: context,
            days: days,
            selectedDate: effectiveSelectedDate,
            onSelected: (date) async {
              final normalized = _dateOnly(date);
              if (!mounted) {
                return;
              }
              setState(() => _selectedDate = normalized);
              await context.read<AdhanCubit>().loadForDate(normalized);
            },
          ),
        ),
      ],
    );
  }

  PrayerDay? _findDayForDate(List<PrayerDay> days, DateTime date) {
    return days
        .where((day) => _dateOnly(day.date) == date)
        .cast<PrayerDay?>()
        .firstWhere((_) => true, orElse: () => null);
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}

class _AdhanErrorView extends StatelessWidget {
  const _AdhanErrorView({required this.state});

  final AdhanState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final message = switch (state.failureReason) {
      AdhanFailureReason.locationDenied => l10n.adhanLocationDenied,
      AdhanFailureReason.locationUnavailable => l10n.adhanLocationUnavailable,
      AdhanFailureReason.locationPluginUnavailable =>
        l10n.adhanLocationPluginUnavailable,
      AdhanFailureReason.locationTimeout => l10n.adhanLocationTimeout,
      AdhanFailureReason.generic || null =>
        state.errorMessage ?? l10n.adhanError,
    };

    final showOpenSettings =
        state.failureReason == AdhanFailureReason.locationDenied;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 48,
              color: AppColors.navy.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 24),
            if (showOpenSettings)
              OutlinedButton(
                onPressed: Geolocator.openAppSettings,
                child: Text(l10n.adhanOpenSettings),
              ),
            if (showOpenSettings) const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => showCitySearchSheet(context),
              icon: const Icon(Icons.search),
              label: Text(l10n.adhanSearchCityTitle),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.read<AdhanCubit>().load(),
              child: Text(l10n.adhanRetry),
            ),
          ],
        ),
      ),
    );
  }
}
