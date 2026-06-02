import 'package:flutter/material.dart';

/// Colors and typography for Quran reading screens.
abstract final class QuranReaderTheme {
  static const Color pageBackground = Color(0xFFFFF9F1);
  static const Color arabicText = Color(0xFF1A1A1A);
  static const Color headerBrown = Color(0xFF4A3728);
  static const Color ornamentGold = Color(0xFFB8956B);
  static const Color ornamentBorder = Color(0xFFD4BC96);
  static const Color markerFill = Color(0xFFF5EDE3);
  static const Color markerBorder = Color(0xFFC9A86C);
  static const Color translationText = Color(0xFF4A4A4A);
  static const Color readFlag = Color(0xFF2E7D32);
  static const Color audioLoading = Color(0xFF5C7A8A);

  static const Color _darkPageBackground = Color(0xFF121820);
  static const Color _darkHeaderBrown = Color(0xFFD4BC96);
  static const Color _darkArabicText = Color(0xFFF5F0E8);
  static const Color _darkOrnamentGold = Color(0xFFD4BC96);
  static const Color _darkOrnamentBorder = Color(0xFF6B5A45);
  static const Color _darkMarkerFill = Color(0xFF1E2832);
  static const Color _darkMarkerBorder = Color(0xFF8B7355);
  static const Color _darkTranslationText = Color(0xFFB8B4AC);
  static const Color _darkReadFlag = Color(0xFF66BB6A);
  static const Color _darkAudioLoading = Color(0xFF90A4AE);

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color pageBackgroundOf(BuildContext context) =>
      isDark(context) ? _darkPageBackground : pageBackground;

  static Color arabicTextOf(BuildContext context) =>
      isDark(context) ? _darkArabicText : arabicText;

  static Color headerBrownOf(BuildContext context) =>
      isDark(context) ? _darkHeaderBrown : headerBrown;

  static Color ornamentGoldOf(BuildContext context) =>
      isDark(context) ? _darkOrnamentGold : ornamentGold;

  static Color ornamentBorderOf(BuildContext context) =>
      isDark(context) ? _darkOrnamentBorder : ornamentBorder;

  static Color markerFillOf(BuildContext context) =>
      isDark(context) ? _darkMarkerFill : markerFill;

  static Color markerBorderOf(BuildContext context) =>
      isDark(context) ? _darkMarkerBorder : markerBorder;

  static Color translationTextOf(BuildContext context) =>
      isDark(context) ? _darkTranslationText : translationText;

  static Color readFlagOf(BuildContext context) =>
      isDark(context) ? _darkReadFlag : readFlag;

  static Color audioLoadingOf(BuildContext context) =>
      isDark(context) ? _darkAudioLoading : audioLoading;

  static TextStyle translationStyle(BuildContext context, {double scale = 1}) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontSize: 17 * scale,
      height: 1.65,
      color: translationTextOf(context),
    );
  }

  /// Mushaf body text metrics (Arabic Hafs or English translation).
  static const double mushafBodyFontSize = 26;
  static const double mushafBodyLineHeight = 2.05;
  static const double mushafBasmallahFontSize = 24;
  static const double mushafHeaderMaxFontSize = 32;
  static const double mushafHeaderMinFontSize = 20;

  static double scaledBodyFontSize(double scale) => mushafBodyFontSize * scale;

  static double scaledBasmallahFontSize(double scale) =>
      mushafBasmallahFontSize * scale;

  static TextStyle mushafTranslationBodyStyle(
    BuildContext context, {
    double scale = 1,
  }) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontSize: scaledBodyFontSize(scale),
      height: mushafBodyLineHeight,
      color: arabicTextOf(context),
    );
  }
}
