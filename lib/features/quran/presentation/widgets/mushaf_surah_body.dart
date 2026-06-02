import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/core/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:qareeb/features/quran/domain/entities/ayah.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qareeb/features/quran/presentation/utils/bismillah_text.dart';
import 'package:qareeb/features/quran/presentation/utils/translation_text.dart';
import 'package:qareeb/features/quran/presentation/utils/juz_label.dart';
import 'package:qareeb/features/quran/presentation/utils/mushaf_verse_marker.dart';
import 'package:qareeb/features/quran/presentation/utils/surah_header_text.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_surah_header.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_western_verse_marker.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart' hide Ayah;

/// Mushaf reading: surah header → standalone Bismillah → ayah text (no Bismillah in ayah 1).
class MushafSurahBody extends StatefulWidget {
  const MushafSurahBody({
    required this.surahNumber,
    required this.surahNameArabic,
    required this.ayahs,
    this.showTranslation = false,
    this.juzNumber,
    this.headerTitleStyle,
    this.playingAyahNumber,
    this.loadingAyahNumber,
    this.readAyahNumbers = const {},
    this.flaggedAyahNumber,
    this.onAyahTap,
    this.onAyahDoubleTap,
    this.onAyahLongPress,
    this.showSurahHeader = true,
    this.scrollable = true,
    this.headerPlayAction,
    this.leadingPlayRow,
    super.key,
  });

  final int surahNumber;
  final String surahNameArabic;
  final bool showTranslation;
  final int? juzNumber;
  final TextStyle? headerTitleStyle;
  final List<Ayah> ayahs;
  final int? playingAyahNumber;
  final int? loadingAyahNumber;
  final Set<int> readAyahNumbers;
  final int? flaggedAyahNumber;
  final void Function(int ayahNumber)? onAyahTap;
  final void Function(int ayahNumber)? onAyahDoubleTap;
  final void Function(int ayahNumber)? onAyahLongPress;
  final bool showSurahHeader;
  final bool scrollable;
  final Widget? headerPlayAction;
  final Widget? leadingPlayRow;

  @override
  State<MushafSurahBody> createState() => _MushafSurahBodyState();
}

class _MushafSurahBodyState extends State<MushafSurahBody> {
  final List<GestureRecognizer> _recognizers = [];
  int? _pendingTapAyah;
  DateTime? _lastTapAt;
  Timer? _longPressTimer;
  bool _longPressTriggered = false;

  static const _doubleTapWindow = Duration(milliseconds: 300);
  static const _longPressDelay = Duration(milliseconds: 500);

  @override
  void dispose() {
    _longPressTimer?.cancel();
    _clearRecognizers();
    super.dispose();
  }

  void _clearRecognizers() {
    _recognizers.forEach(_disposeRecognizer);
    _recognizers.clear();
  }

  void _disposeRecognizer(GestureRecognizer recognizer) {
    recognizer.dispose();
  }

  TapGestureRecognizer _tapRecognizer(int ayahNumber) {
    final recognizer = TapGestureRecognizer()
      ..onTapDown = (_) {
        _onAyahPressDown(ayahNumber);
      }
      ..onTapUp = (_) {
        _onAyahPressUp();
      }
      ..onTapCancel = () {
        _onAyahPressCancel();
      }
      ..onTap = () {
        _handleAyahTap(ayahNumber);
      };
    _recognizers.add(recognizer);
    return recognizer;
  }

  void _onAyahPressDown(int ayahNumber) {
    _longPressTriggered = false;
    _longPressTimer?.cancel();
    _longPressTimer = Timer(_longPressDelay, () {
      _longPressTriggered = true;
      _pendingTapAyah = null;
      widget.onAyahLongPress?.call(ayahNumber);
    });
  }

  void _onAyahPressUp() {
    _longPressTimer?.cancel();
  }

  void _onAyahPressCancel() {
    _longPressTimer?.cancel();
  }

  void _handleAyahTap(int ayahNumber) {
    if (_longPressTriggered) {
      _longPressTriggered = false;
      return;
    }

    final now = DateTime.now();
    final isDoubleTap = _pendingTapAyah == ayahNumber &&
        _lastTapAt != null &&
        now.difference(_lastTapAt!) <= _doubleTapWindow;

    if (isDoubleTap) {
      _pendingTapAyah = null;
      _lastTapAt = null;
      widget.onAyahDoubleTap?.call(ayahNumber);
      return;
    }

    _pendingTapAyah = ayahNumber;
    _lastTapAt = now;

    Future<void>.delayed(_doubleTapWindow, () {
      if (!mounted || _pendingTapAyah != ayahNumber) return;
      _pendingTapAyah = null;
      widget.onAyahTap?.call(ayahNumber);
    });
  }

  bool _isAyahRead(Ayah ayah) => widget.readAyahNumbers.contains(ayah.ayahNumber);

  bool _isAyahFlagged(Ayah ayah) => widget.flaggedAyahNumber == ayah.ayahNumber;

  String _arabicTextForAyah(Ayah ayah) {
    var text = _cleanText(ayah.textArabic);
    if (ayah.ayahNumber == 1 &&
        BismillahText.showStandaloneUnderHeader(widget.surahNumber)) {
      text = BismillahText.stripFromAyah(text);
    }
    return text;
  }

  String _translationTextForAyah(Ayah ayah) {
    var text = TranslationText.forDisplay(_cleanText(ayah.textTranslation));
    if (ayah.ayahNumber == 1 &&
        BismillahText.showStandaloneUnderHeader(widget.surahNumber)) {
      text = BismillahText.stripFromTranslationAyah(text);
    }
    return text;
  }

  Color? _ayahTextColor(BuildContext context, Ayah ayah) {
    final isPlaying = widget.playingAyahNumber == ayah.ayahNumber;
    final isLoading = widget.loadingAyahNumber == ayah.ayahNumber;
    final isRead = _isAyahRead(ayah);
    final isFlagged = _isAyahFlagged(ayah);

    if (isLoading) return QuranReaderTheme.audioLoadingOf(context);
    if (isPlaying) return QuranReaderTheme.ornamentGoldOf(context);
    if (isFlagged) return QuranReaderTheme.readFlagOf(context);
    if (isRead) return QuranReaderTheme.readFlagOf(context).withValues(alpha: 0.65);
    return null;
  }

  TextStyle _ayahStyleFor(
    BuildContext context,
    Ayah ayah,
    TextStyle baseStyle,
    double fontScale,
  ) {
    final color = _ayahTextColor(context, ayah);
    return color == null ? baseStyle : baseStyle.copyWith(color: color);
  }

  TextStyle _arabicMarkerStyle(
    BuildContext context,
    Ayah ayah,
    double fontScale,
  ) {
    final textColor = _ayahTextColor(context, ayah);

    return QuranTextStyles.hafsStyle(
      fontSize: QuranReaderTheme.scaledBodyFontSize(fontScale),
      height: QuranReaderTheme.mushafBodyLineHeight,
      color: textColor ?? QuranReaderTheme.arabicTextOf(context),
    );
  }

  Iterable<InlineSpan> _arabicSpansForAyah(
    BuildContext context,
    Ayah ayah,
    TextStyle baseStyle,
    double fontScale,
  ) {
    final text = _arabicTextForAyah(ayah);
    if (text.isEmpty) return const [];

    final ayahStyle = _ayahStyleFor(context, ayah, baseStyle, fontScale);

    return [
      TextSpan(
        text: '$text ',
        style: ayahStyle,
        recognizer: _tapRecognizer(ayah.ayahNumber),
      ),
      TextSpan(
        text: MushafVerseMarker.arabicGlyph(
          widget.surahNumber,
          ayah.ayahNumber,
        ),
        style: _arabicMarkerStyle(context, ayah, fontScale),
        recognizer: _tapRecognizer(ayah.ayahNumber),
      ),
      if (_isAyahFlagged(ayah))
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 4),
            child: Icon(
              Icons.flag,
              size: 14,
              color: QuranReaderTheme.readFlagOf(context),
            ),
          ),
        ),
    ];
  }

  TextStyle _arabicBodyStyle(BuildContext context, double fontScale) {
    return QuranTextStyles.hafsStyle(
      fontSize: QuranReaderTheme.scaledBodyFontSize(fontScale),
      height: QuranReaderTheme.mushafBodyLineHeight,
      color: QuranReaderTheme.arabicTextOf(context),
    );
  }

  TextStyle _translationBodyStyle(BuildContext context, double fontScale) {
    return QuranReaderTheme.mushafTranslationBodyStyle(
      context,
      scale: fontScale,
    );
  }

  Iterable<InlineSpan> _translationSpansForAyah(
    BuildContext context,
    Ayah ayah,
    TextStyle baseStyle,
    double fontScale,
  ) {
    final text = _translationTextForAyah(ayah);
    if (text.isEmpty) return const [];

    final ayahStyle = _ayahStyleFor(context, ayah, baseStyle, fontScale);
    final markerColor = _ayahTextColor(context, ayah);

    return [
      TextSpan(
        text: '$text ',
        style: ayahStyle,
        recognizer: _tapRecognizer(ayah.ayahNumber),
      ),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: MushafWesternVerseMarker(
          surahNumber: widget.surahNumber,
          ayahNumber: ayah.ayahNumber,
          fontScale: fontScale,
          color: markerColor,
        ),
      ),
      const TextSpan(text: ' '),
      if (_isAyahFlagged(ayah))
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 4),
            child: Icon(
              Icons.flag,
              size: 14,
              color: QuranReaderTheme.readFlagOf(context),
            ),
          ),
        ),
    ];
  }

  List<InlineSpan> _buildArabicAyahSpans(
    BuildContext context,
    TextStyle baseStyle,
    double fontScale,
  ) {
    return widget.ayahs
        .expand((ayah) => _arabicSpansForAyah(context, ayah, baseStyle, fontScale))
        .toList();
  }

  List<InlineSpan> _buildTranslationAyahSpans(
    BuildContext context,
    TextStyle baseStyle,
    double fontScale,
  ) {
    return widget.ayahs
        .expand(
          (ayah) => _translationSpansForAyah(context, ayah, baseStyle, fontScale),
        )
        .toList();
  }

  String get _basmallahGlyph =>
      widget.surahNumber == 97 || widget.surahNumber == 95
      ? '齃𧻓𥳐龎'
      : '齃𧻓𥳐𥉉';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      buildWhen: (previous, current) =>
          previous.quranFontScale != current.quranFontScale,
      builder: (context, settings) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: TextScaler.noScaling),
          child: _buildContent(context, settings.quranFontScale),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, double fontScale) {
    _clearRecognizers();

    final effectiveScale =
        fontScale * Responsive.quranDeviceScale(context);

    final showBasmallah = widget.showSurahHeader &&
        BismillahText.showStandaloneUnderHeader(widget.surahNumber);

    final isTranslationMode = widget.showTranslation;
    final bodyStyle = isTranslationMode
        ? _translationBodyStyle(context, effectiveScale)
        : _arabicBodyStyle(context, effectiveScale);
    final basmallahStyle = QuranTextStyles.basmallahStyle(
      fontSize: QuranReaderTheme.scaledBasmallahFontSize(effectiveScale),
      color: QuranReaderTheme.arabicTextOf(context),
    );
    final englishBasmallahStyle = _translationBodyStyle(
      context,
      effectiveScale,
    ).copyWith(
      fontSize: QuranReaderTheme.scaledBasmallahFontSize(effectiveScale),
      fontStyle: FontStyle.italic,
    );

    final ayahSpans = isTranslationMode
        ? _buildTranslationAyahSpans(context, bodyStyle, effectiveScale)
        : _buildArabicAyahSpans(context, bodyStyle, effectiveScale);
    final textDirection =
        isTranslationMode ? TextDirection.ltr : TextDirection.rtl;
    final textAlign =
        isTranslationMode ? TextAlign.start : TextAlign.justify;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.leadingPlayRow != null) widget.leadingPlayRow!,
        if (widget.showSurahHeader && widget.juzNumber != null) ...[
          MushafSurahHeader(
            surahShortName: SurahHeaderText.shortSurahName(
              surahNumber: widget.surahNumber,
              nameArabic: widget.surahNameArabic,
              isArabic: !widget.showTranslation,
            ),
            juzLabelText: JuzLabel.format(
              juzNumber: widget.juzNumber!,
              isArabic: !widget.showTranslation,
            ),
            bannerTitle: SurahHeaderText.bannerTitle(
              surahNumber: widget.surahNumber,
              nameArabic: widget.surahNameArabic,
              isArabic: !widget.showTranslation,
            ),
            isArabicLocale: !widget.showTranslation,
            titleStyle: widget.headerTitleStyle,
            fontScale: effectiveScale,
            playAction: widget.headerPlayAction,
          ),
          if (showBasmallah) ...[
            SizedBox(height: Responsive.spacing(context, 12)),
            Center(
              child: isTranslationMode
                  ? Text(
                      BismillahText.englishStandalone,
                      textAlign: TextAlign.center,
                      style: englishBasmallahStyle,
                    )
                  : Text(
                      _basmallahGlyph,
                      textAlign: TextAlign.center,
                      style: basmallahStyle,
                    ),
            ),
          ],
          SizedBox(height: Responsive.spacing(context, 16)),
        ],
        Directionality(
          textDirection: textDirection,
          child: Text.rich(
            TextSpan(children: ayahSpans),
            textAlign: textAlign,
            textDirection: textDirection,
          ),
        ),
      ],
    );

    if (widget.scrollable) {
      return SingleChildScrollView(
        padding: Responsive.mushafScrollPadding(context),
        child: content,
      );
    }

    return Padding(
      padding: Responsive.mushafPagePadding(context),
      child: content,
    );
  }

  String _cleanText(String text) {
    return text.trim().replaceAll('\uFEFF', '').replaceAll('\n', ' ');
  }
}
