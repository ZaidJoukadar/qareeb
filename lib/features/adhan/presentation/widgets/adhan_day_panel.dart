import 'package:flutter/material.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';
import 'package:qareeb/features/adhan/presentation/widgets/adhan_date_header.dart';
import 'package:qareeb/features/adhan/presentation/widgets/prayer_times_list.dart';

class AdhanDayPanel extends StatelessWidget {
  const AdhanDayPanel({
    required this.day,
    required this.locale,
    required this.isToday,
    required this.onDateTap,
    super.key,
  });

  final PrayerDay day;
  final String locale;
  final bool isToday;
  final VoidCallback onDateTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdhanDateHeader(
          day: day,
          locale: locale,
          onTap: onDateTap,
        ),
        PrayerTimesList(
          day: day,
          isToday: isToday,
        ),
        SizedBox(height: Responsive.spacing(context, 24)),
      ],
    );
  }
}
