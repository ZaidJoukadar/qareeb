import 'package:flutter/material.dart';
import 'package:qareeb/core/presentation/bottom_sheets/app_bar_modal_bottom_sheet.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/duaa/domain/entities/dua.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

Future<void> showDuaDetailSheet({
  required BuildContext context,
  required Dua dua,
}) {
  return showAppBarModalBottomSheet<void>(
    context: context,
    builder: (context) {
      final l10n = context.l10n;
      final theme = Theme.of(context);
      final isArabicLocale =
          Localizations.localeOf(context).languageCode == 'ar';

      return AppBarModalScrollBody(
        maxHeightFactor: 0.85,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Responsive.horizontalPadding(context),
            8,
            Responsive.horizontalPadding(context),
            24 + MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                dua.titleFor(isArabicLocale: isArabicLocale),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                textDirection:
                    isArabicLocale ? TextDirection.rtl : TextDirection.ltr,
              ),
              const SizedBox(height: 16),
              Text(
                dua.arabic,
                style: theme.textTheme.headlineSmall?.copyWith(
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              if (!isArabicLocale) ...[
                const SizedBox(height: 12),
                Text(
                  dua.transliteration,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (!isArabicLocale || dua.shouldShowTranslationInArabic) ...[
                const SizedBox(height: 16),
                Text(
                  dua.translationFor(isArabicLocale: isArabicLocale),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.navy.withValues(alpha: 0.85),
                    height: 1.5,
                  ),
                  textAlign:
                      isArabicLocale ? TextAlign.right : TextAlign.left,
                  textDirection: isArabicLocale
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),
              ],
              const SizedBox(height: 20),
              Text(
                l10n.duaaSourceLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.navy.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: isArabicLocale ? TextAlign.right : TextAlign.left,
              ),
              const SizedBox(height: 4),
              Text(
                dua.sourceFor(isArabicLocale: isArabicLocale),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.navy.withValues(alpha: 0.75),
                ),
                textAlign: isArabicLocale ? TextAlign.right : TextAlign.left,
                textDirection:
                    isArabicLocale ? TextDirection.rtl : TextDirection.ltr,
              ),
              if (dua.repeat > 1) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.duaaRepeatLabel(dua.repeat),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
