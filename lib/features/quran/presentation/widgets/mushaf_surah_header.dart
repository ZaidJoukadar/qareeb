import 'package:flutter/material.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart' hide Ayah, Surah;

/// Surah title banner using the official QCF [surah_banner] asset.
class MushafSurahHeader extends StatelessWidget {
  const MushafSurahHeader({
    required this.title,
    this.textDirection = TextDirection.rtl,
    this.titleStyle,
    super.key,
  });

  final String title;
  final TextDirection textDirection;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final headerWidth = constraints.maxWidth * 0.92;
        final fontSize = headerWidth * 0.055;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: SizedBox(
              width: headerWidth,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/surah_banner.png',
                    package: 'qcf_quran_lite',
                    width: headerWidth,
                    fit: BoxFit.contain,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      textDirection: textDirection,
                      style:
                          titleStyle ??
                          QuranTextStyles.hafsStyle(
                            fontSize: fontSize.clamp(20, 32),
                            color: QuranReaderTheme.arabicText,
                            height: 1.4,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
