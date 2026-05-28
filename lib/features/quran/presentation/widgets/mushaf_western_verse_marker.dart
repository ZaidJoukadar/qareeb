import 'package:flutter/material.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart' hide Ayah;

/// Same QCF ornate ayah frame as Arabic mushaf, with a Western numeral (1, 2, 3…).
class MushafWesternVerseMarker extends StatelessWidget {
  const MushafWesternVerseMarker({
    required this.surahNumber,
    required this.ayahNumber,
    required this.fontScale,
    this.color,
    super.key,
  });

  final int surahNumber;
  final int ayahNumber;
  final double fontScale;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fontSize = QuranReaderTheme.scaledBodyFontSize(fontScale);
    final lineHeight = QuranReaderTheme.mushafBodyLineHeight;
    final textColor = color ?? QuranReaderTheme.arabicTextOf(context);
    final frameStyle = QuranTextStyles.hafsStyle(
      fontSize: fontSize,
      height: lineHeight,
      color: textColor,
    );
    final digitSize = fontSize * 0.34;

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 2),
      child: SizedBox(
        height: fontSize * lineHeight,
        width: fontSize * 0.78,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Text(
              getayaNoQCF(surahNumber, ayahNumber),
              style: frameStyle,
              textAlign: TextAlign.center,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              decoration: BoxDecoration(
                color: QuranReaderTheme.pageBackgroundOf(context),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '$ayahNumber',
                style: TextStyle(
                  fontSize: digitSize,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
