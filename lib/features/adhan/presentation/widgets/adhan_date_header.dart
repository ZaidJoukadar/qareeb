import 'package:flutter/material.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';
import 'package:qareeb/features/adhan/presentation/utils/adhan_date_formatting.dart';

class AdhanDateHeader extends StatelessWidget {
  const AdhanDateHeader({
    required this.day,
    required this.locale,
    required this.onTap,
    super.key,
  });

  final PrayerDay day;
  final String locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hijriText = formatAdhanHijriHeader(day, locale);
    final gregorianText = formatAdhanGregorianDate(day, locale);

    return Padding(
      padding: Responsive.pagePadding(context).copyWith(top: 8, bottom: 0),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: AppColors.navy.withValues(alpha: 0.85),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                hijriText,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: AppColors.navy,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 22,
                              color: AppColors.navy.withValues(alpha: 0.7),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          gregorianText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.navy.withValues(alpha: 0.45),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.navy.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }
}
