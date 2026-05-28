import 'package:flutter/material.dart';
import 'package:qareeb/core/presentation/bottom_sheets/app_bar_modal_bottom_sheet.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/asma_ul_husna/domain/entities/allah_name.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

Future<void> showAllahNameDetailSheet({
  required BuildContext context,
  required AllahName name,
}) {
  return showAppBarModalBottomSheet<void>(
    context: context,
    builder: (context) {
      final l10n = context.l10n;
      final theme = Theme.of(context);
      final onSurface = theme.colorScheme.onSurface;
      final isArabicLocale =
          Localizations.localeOf(context).languageCode == 'ar';
      final translation = name.translationFor(isArabicLocale: isArabicLocale);
      final meaning = name.meaningFor(isArabicLocale: isArabicLocale);

      return AppBarModalScrollBody(
        maxHeightFactor: 0.75,
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
                l10n.asmaUlHusnaNameNumber(name.number),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: onSurface.withValues(alpha: 0.55),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                name.arabic,
                style: theme.textTheme.displaySmall?.copyWith(
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              if (!isArabicLocale) ...[
                const SizedBox(height: 8),
                Text(
                  name.transliteration,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 4),
              Text(
                translation,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: onSurface.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                textDirection:
                    isArabicLocale ? TextDirection.rtl : TextDirection.ltr,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.asmaUlHusnaMeaningLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: onSurface.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: isArabicLocale ? TextAlign.right : TextAlign.left,
              ),
              const SizedBox(height: 8),
              Text(
                meaning,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: onSurface.withValues(alpha: 0.85),
                  height: 1.5,
                ),
                textAlign: isArabicLocale ? TextAlign.right : TextAlign.left,
                textDirection:
                    isArabicLocale ? TextDirection.rtl : TextDirection.ltr,
              ),
            ],
          ),
        ),
      );
    },
  );
}
