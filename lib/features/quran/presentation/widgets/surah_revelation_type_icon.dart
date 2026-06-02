import 'package:flutter/material.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qareeb/features/quran/presentation/utils/surah_revelation_type.dart';

class SurahRevelationTypeLabel extends StatelessWidget {
  const SurahRevelationTypeLabel({
    super.key,
    required this.revelationType,
    required this.makkiLabel,
    required this.madaniLabel,
    this.iconSize = 14,
    this.textDirection,
  });

  final String revelationType;
  final String makkiLabel;
  final String madaniLabel;
  final double iconSize;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    final isMakki = SurahRevelationType.isMakki(revelationType);
    final isMadani = SurahRevelationType.isMadani(revelationType);

    if (!isMakki && !isMadani) {
      return const SizedBox.shrink();
    }

    final label = isMakki ? makkiLabel : madaniLabel;
    final color = QuranReaderTheme.ornamentGoldOf(context);
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: QuranReaderTheme.translationTextOf(context),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: textDirection,
      children: [
        Icon(
          isMakki ? Icons.mosque_outlined : Icons.location_city_outlined,
          size: iconSize,
          color: color,
          semanticLabel: label,
        ),
        const SizedBox(width: 4),
        Text(label, style: labelStyle),
      ],
    );
  }
}
