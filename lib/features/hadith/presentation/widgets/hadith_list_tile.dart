import 'package:flutter/material.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class HadithListTile extends StatelessWidget {
  const HadithListTile({
    super.key,
    required this.hadith,
    required this.isArabicLocale,
    required this.onTap,
    this.showCollectionName = false,
  });

  final Hadith hadith;
  final bool isArabicLocale;
  final VoidCallback onTap;
  final bool showCollectionName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 44,
              child: Text(
                '${hadith.number}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showCollectionName) ...[
                    Text(
                      hadith.collectionName,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.navy.withValues(alpha: 0.55),
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: isArabicLocale
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    hadith.previewFor(isArabicLocale: isArabicLocale),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.navy,
                      height: 1.45,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textDirection: isArabicLocale
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                  if (hadith.grade != null && hadith.grade!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      hadith.grade!,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 4),
            Semantics(
              label: l10n.hadithOpenDetailHint,
              child: Icon(
                Icons.chevron_right,
                color: AppColors.navy.withValues(alpha: 0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
