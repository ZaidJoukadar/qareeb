import 'package:flutter/material.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart' hide Ayah, Surah;

/// Surah title banner using the official QCF [surah_banner] asset.
class MushafSurahHeader extends StatelessWidget {
  const MushafSurahHeader({
    required this.surahShortName,
    required this.juzLabelText,
    required this.bannerTitle,
    required this.isArabicLocale,
    this.titleStyle,
    this.fontScale = 1,
    this.playAction,
    super.key,
  });

  final String surahShortName;
  final String juzLabelText;
  final String bannerTitle;
  final bool isArabicLocale;
  final TextStyle? titleStyle;
  final double fontScale;
  final Widget? playAction;

  @override
  Widget build(BuildContext context) {
    final headerColor = QuranReaderTheme.headerBrownOf(context);
    final layoutScale = Responsive.scaleOf(context);
    final metaStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: headerColor,
      fontWeight: FontWeight.w600,
      fontSize: 17 * fontScale * layoutScale,
    );
    final textDirection =
        isArabicLocale ? TextDirection.rtl : TextDirection.ltr;

    return LayoutBuilder(
      builder: (context, constraints) {
        final headerWidth = constraints.maxWidth * 0.92;
        final bannerHeight = Responsive.surahBannerHeightForWidth(headerWidth);
        final cartoucheMaxWidth = headerWidth * 0.50;
        final bannerFontSize =
            (headerWidth * 0.085 * fontScale * layoutScale).clamp(
              QuranReaderTheme.mushafHeaderMinFontSize * fontScale,
              QuranReaderTheme.mushafHeaderMaxFontSize * fontScale,
            );

        final metaChildren = isArabicLocale
            ? [
                Flexible(
                  child: Text(
                    juzLabelText,
                    style: metaStyle,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    surahShortName,
                    style: metaStyle,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ]
            : [
                Flexible(
                  child: Text(
                    surahShortName,
                    style: metaStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    juzLabelText,
                    style: metaStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ];

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: Responsive.spacing(context, 12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (playAction != null)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: playAction!,
                ),
              Directionality(
                textDirection: textDirection,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: metaChildren,
                ),
              ),
              SizedBox(height: Responsive.spacing(context, 10)),
              Center(
                child: SizedBox(
                  width: headerWidth,
                  height: bannerHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/surah_banner.png',
                        package: 'qcf_quran_lite',
                        width: headerWidth,
                        height: bannerHeight,
                        fit: BoxFit.fill,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          headerWidth * 0.21,
                          bannerHeight * 0.14,
                          headerWidth * 0.21,
                          bannerHeight * 0.16,
                        ),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: cartoucheMaxWidth,
                              ),
                              child: Text(
                                bannerTitle,
                                textAlign: TextAlign.center,
                                textDirection: textDirection,
                                maxLines: 1,
                                style:
                                    titleStyle ??
                                    (isArabicLocale
                                        ? QuranTextStyles.hafsStyle(
                                            fontSize: bannerFontSize,
                                            color: headerColor,
                                            height: 1.2,
                                          )
                                        : Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: headerColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: bannerFontSize *
                                                    0.72,
                                                height: 1.05,
                                                letterSpacing: 0.1,
                                              )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Mid-page surah label with play control when the full header is not shown.
class MushafSurahPlayRow extends StatelessWidget {
  const MushafSurahPlayRow({
    required this.title,
    required this.juzLabel,
    required this.playAction,
    this.textDirection = TextDirection.rtl,
    super.key,
  });

  final String title;
  final String juzLabel;
  final TextDirection textDirection;
  final Widget playAction;

  @override
  Widget build(BuildContext context) {
    final headerColor = QuranReaderTheme.headerBrownOf(context);
    final layoutScale = Responsive.scaleOf(context);
    final metaStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: headerColor,
      fontWeight: FontWeight.w600,
      fontSize: 17 * layoutScale,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.spacing(context, 8)),
      child: Directionality(
        textDirection: textDirection,
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: textDirection == TextDirection.rtl
                    ? [
                        Text(
                          juzLabel,
                          style: metaStyle?.copyWith(fontSize: 14 * layoutScale),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Flexible(
                          child: Text(
                            title,
                            style: metaStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]
                    : [
                        Flexible(
                          child: Text(
                            title,
                            style: metaStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          juzLabel,
                          style: metaStyle?.copyWith(fontSize: 14 * layoutScale),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
              ),
            ),
            playAction,
          ],
        ),
      ),
    );
  }
}
