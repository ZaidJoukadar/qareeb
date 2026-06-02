import 'package:flutter/material.dart';
import 'package:qareeb/core/presentation/bottom_sheets/app_bar_modal_bottom_sheet.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

Future<void> showHadithDetailSheet({
  required BuildContext context,
  required Hadith hadith,
}) {
  return showAppBarModalBottomSheet<void>(
    context: context,
    builder: (context) {
      final l10n = context.l10n;
      final theme = Theme.of(context);
      final isArabicLocale =
          Localizations.localeOf(context).languageCode == 'ar';

      return AppBarModalScrollBody(
        maxHeightFactor: 0.9,
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
                l10n.hadithNumberLabel(hadith.number),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                hadith.collectionName,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.navy.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                textDirection:
                    isArabicLocale ? TextDirection.rtl : TextDirection.ltr,
              ),
              if (hadith.grade != null && hadith.grade!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      hadith.grade!,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                hadith.arabic,
                style: theme.textTheme.titleMedium?.copyWith(
                  height: 1.7,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              if (!isArabicLocale) ...[
                const SizedBox(height: 20),
                Text(
                  hadith.english,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.navy.withValues(alpha: 0.85),
                    height: 1.55,
                  ),
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                ),
              ],
              const SizedBox(height: 20),
              Text(
                l10n.hadithSourceLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.navy.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: isArabicLocale ? TextAlign.right : TextAlign.left,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.hadithSourceReference(
                  hadith.collectionName,
                  hadith.number,
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.navy.withValues(alpha: 0.75),
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
