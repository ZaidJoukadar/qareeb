import 'package:flutter/material.dart';

abstract final class Responsive {
  /// Logical shortest side of a typical phone used as the 1.0 design baseline.
  static const double designShortestSide = 390;

  static const double minScale = 0.88;
  static const double maxScale = 1.28;

  static double widthOf(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double heightOf(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  static double shortestSideOf(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape;

  /// True when vertical space is tight (landscape phones, split screen, etc.).
  static bool useCompactDrawer(BuildContext context) =>
      isLandscape(context) || heightOf(context) < 500;

  static double drawerWidth(BuildContext context) {
    if (isLandscape(context)) {
      return (widthOf(context) * 0.36).clamp(260.0, 300.0);
    }
    return 304.0;
  }

  /// Continuous scale factor derived from [shortestSideOf].
  static double scaleOf(BuildContext context) {
    return (shortestSideOf(context) / designShortestSide).clamp(
      minScale,
      maxScale,
    );
  }

  /// Scales a fixed design value (padding, spacing, icon size, etc.).
  static double spacing(BuildContext context, double base) =>
      base * scaleOf(context);

  static double horizontalPadding(BuildContext context) => spacing(context, 16);

  static EdgeInsets pagePadding(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: horizontalPadding(context));

  static EdgeInsets mushafPagePadding(BuildContext context) {
    return EdgeInsets.fromLTRB(
      spacing(context, 4),
      spacing(context, 2),
      spacing(context, 4),
      spacing(context, 8),
    );
  }

  static EdgeInsets mushafScrollPadding(BuildContext context) {
    return EdgeInsets.fromLTRB(
      spacing(context, 4),
      spacing(context, 2),
      spacing(context, 4),
      spacing(context, 16),
    );
  }

  /// Device-aware multiplier applied on top of the user Quran font scale.
  static double quranDeviceScale(BuildContext context) => scaleOf(context);

  /// [qcf_quran_lite] `assets/surah_banner.png` intrinsic aspect ratio (w ÷ h).
  static const double surahBannerAspectRatio = 3421 / 403;

  static double surahBannerHeightForWidth(double width) =>
      width / surahBannerAspectRatio;
}
