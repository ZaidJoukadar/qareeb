import 'package:flutter/material.dart';

/// Colors and typography for Quran reading screens.
abstract final class QuranReaderTheme {
  static const Color pageBackground = Color(0xFFFDF8F2);
  static const Color arabicText = Color(0xFF1A1A1A);
  static const Color ornamentGold = Color(0xFFB8956B);
  static const Color ornamentBorder = Color(0xFFD4BC96);
  static const Color markerFill = Color(0xFFF5EDE3);
  static const Color markerBorder = Color(0xFFC9A86C);
  static const Color translationText = Color(0xFF4A4A4A);

  static TextStyle translationStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontSize: 17,
      height: 1.65,
      color: translationText,
    );
  }

  /// Mushaf body text metrics (Arabic Hafs or English translation).
  static const double mushafBodyFontSize = 26;
  static const double mushafBodyLineHeight = 2.05;
  static const double mushafBasmallahFontSize = 24;

  static TextStyle mushafTranslationBodyStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontSize: mushafBodyFontSize,
      height: mushafBodyLineHeight,
      color: arabicText,
    );
  }
}
