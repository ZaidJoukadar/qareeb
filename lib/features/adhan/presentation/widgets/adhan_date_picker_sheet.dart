import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:qareeb/core/presentation/bottom_sheets/app_bar_modal_bottom_sheet.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';

const _defaultCalendarHeight = 346.0;
const _actionAreaHeight = 54.0;
const _maxDayGridRows = 7.0;
const _compactControlsHeight = 44.0;

CalendarDatePicker2WithActionButtonsConfig _datePickerConfigForHeight(
  BoxConstraints constraints,
  CalendarDatePicker2WithActionButtonsConfig base,
) {
  final maxHeight = constraints.maxHeight;
  if (!maxHeight.isFinite ||
      maxHeight >= _defaultCalendarHeight + _actionAreaHeight) {
    return base;
  }

  final calendarHeight = maxHeight - _actionAreaHeight;
  final contentHeight = calendarHeight - _compactControlsHeight;
  final rowHeight = contentHeight / _maxDayGridRows;
  final dayMaxWidth = (rowHeight - 2).clamp(24.0, 40.0);

  return base.copyWith(
    controlsHeight: _compactControlsHeight,
    dayMaxWidth: dayMaxWidth,
  );
}

Future<void> showAdhanDatePickerSheet({
  required BuildContext context,
  required List<PrayerDay> days,
  required DateTime selectedDate,
  required ValueChanged<DateTime> onSelected,
}) {
  return showAppBarModalBottomSheet<void>(
    context: context,
    builder: (context) {
      final now = DateTime.now();
      final dateOnlyNow = DateTime(now.year, now.month, now.day);
      final firstAvailable = days.isEmpty
          ? dateOnlyNow.subtract(const Duration(days: 3650))
          : days
                .map((day) => DateTime(day.date.year, day.date.month, day.date.day))
                .reduce((a, b) => a.isBefore(b) ? a : b)
                .subtract(const Duration(days: 3650));
      final lastAvailable = dateOnlyNow.add(const Duration(days: 3650));
      final initialDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      final textTheme = Theme.of(context).textTheme;

      final baseConfig = CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        firstDate: firstAvailable,
        lastDate: lastAvailable,
        currentDate: dateOnlyNow,
        dynamicCalendarRows: true,
        selectedDayHighlightColor: AppColors.gold,
        selectedDayTextStyle: textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        dayTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.navy,
        ),
        weekdayLabelTextStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.navy.withValues(alpha: 0.7),
          fontWeight: FontWeight.w600,
        ),
        controlsTextStyle: textTheme.titleMedium?.copyWith(
          color: AppColors.navy,
          fontWeight: FontWeight.w700,
        ),
      );

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CalendarDatePicker2WithActionButtons(
                config: _datePickerConfigForHeight(constraints, baseConfig),
                value: [initialDate],
                onValueChanged: (values) {
                  if (values.isEmpty) {
                    return;
                  }
                  final picked = values.first;
                  if (picked == null) {
                    return;
                  }
                  onSelected(
                    DateTime(picked.year, picked.month, picked.day),
                  );
                },
              );
            },
          ),
        ),
      );
    },
  );
}
