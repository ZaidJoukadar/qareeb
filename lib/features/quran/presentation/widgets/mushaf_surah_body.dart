import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qareeb/features/quran/domain/entities/ayah.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qareeb/features/quran/presentation/utils/bismillah_text.dart';
import 'package:qareeb/features/quran/presentation/utils/translation_text.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_surah_header.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart' hide Ayah;

/// Mushaf reading: surah header → standalone Bismillah → ayah text (no Bismillah in ayah 1).
class MushafSurahBody extends StatefulWidget {
  const MushafSurahBody({
    required this.surahNumber,
    required this.surahNameArabic,
    required this.ayahs,
    this.showTranslation = false,
    this.headerTitle,
    this.headerTextDirection,
    this.headerTitleStyle,
    this.playingAyahNumber,
    this.loadingAyahNumber,
    this.onAyahTap,
    super.key,
  });

  final int surahNumber;
  final String surahNameArabic;
  final bool showTranslation;
  final String? headerTitle;
  final TextDirection? headerTextDirection;
  final TextStyle? headerTitleStyle;
  final List<Ayah> ayahs;
  final int? playingAyahNumber;
  final int? loadingAyahNumber;
  final void Function(int ayahNumber)? onAyahTap;

  @override
  State<MushafSurahBody> createState() => _MushafSurahBodyState();
}

class _MushafSurahBodyState extends State<MushafSurahBody> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    _clearRecognizers();
    super.dispose();
  }

  void _clearRecognizers() {
    _recognizers.forEach(_disposeRecognizer);
    _recognizers.clear();
  }

  void _disposeRecognizer(TapGestureRecognizer recognizer) {
    recognizer.dispose();
  }

  TapGestureRecognizer _tapRecognizer(int ayahNumber) {
    final recognizer = TapGestureRecognizer()
      ..onTap = widget.onAyahTap == null
          ? null
          : () => widget.onAyahTap!(ayahNumber);
    _recognizers.add(recognizer);
    return recognizer;
  }

  String _displayTextForAyah(Ayah ayah) {
    if (widget.showTranslation) {
      var text = TranslationText.forDisplay(_cleanText(ayah.textTranslation));
      if (ayah.ayahNumber == 1 &&
          BismillahText.showStandaloneUnderHeader(widget.surahNumber)) {
        text = BismillahText.stripFromTranslationAyah(text);
      }
      return text;
    }

    var text = _cleanText(ayah.textArabic);
    if (ayah.ayahNumber == 1 &&
        BismillahText.showStandaloneUnderHeader(widget.surahNumber)) {
      text = BismillahText.stripFromAyah(text);
    }
    return text;
  }

  TextStyle _ayahStyleFor(Ayah ayah, TextStyle baseStyle) {
    final isPlaying = widget.playingAyahNumber == ayah.ayahNumber;
    final isLoading = widget.loadingAyahNumber == ayah.ayahNumber;

    return baseStyle.copyWith(
      color: isPlaying ? QuranReaderTheme.ornamentGold : null,
      decoration: isLoading ? TextDecoration.underline : null,
    );
  }

  String _ayahMarkerText(Ayah ayah) {
    if (widget.showTranslation) {
      return '${ayah.ayahNumber}';
    }
    return getayaNoQCF(widget.surahNumber, ayah.ayahNumber);
  }

  /// Arabic: QCF ornate markers (Hafs font). English: readable verse numbers.
  TextStyle _ayahMarkerStyle(Ayah ayah, TextStyle baseStyle) {
    final isPlaying = widget.playingAyahNumber == ayah.ayahNumber;
    final isLoading = widget.loadingAyahNumber == ayah.ayahNumber;
    final highlightColor =
        isPlaying ? QuranReaderTheme.ornamentGold : QuranReaderTheme.arabicText;

    if (widget.showTranslation) {
      return _ayahStyleFor(ayah, baseStyle).copyWith(
        fontWeight: FontWeight.w700,
        color: QuranReaderTheme.ornamentGold,
        decoration: isLoading ? TextDecoration.underline : null,
      );
    }

    return QuranTextStyles.hafsStyle(
      fontSize: QuranReaderTheme.mushafBodyFontSize,
      height: QuranReaderTheme.mushafBodyLineHeight,
      color: highlightColor,
    ).copyWith(
      decoration: isLoading ? TextDecoration.underline : null,
    );
  }

  Iterable<InlineSpan> _spansForAyah(Ayah ayah, TextStyle baseStyle) {
    final text = _displayTextForAyah(ayah);
    if (text.isEmpty) return const [];

    final ayahStyle = _ayahStyleFor(ayah, baseStyle);

    return [
      TextSpan(
        text: '$text ',
        style: ayahStyle,
        recognizer: _tapRecognizer(ayah.ayahNumber),
      ),
      TextSpan(
        text: '${_ayahMarkerText(ayah)} ',
        style: _ayahMarkerStyle(ayah, baseStyle),
        recognizer: _tapRecognizer(ayah.ayahNumber),
      ),
    ];
  }

  TextStyle _bodyStyle(BuildContext context) {
    if (widget.showTranslation) {
      return QuranReaderTheme.mushafTranslationBodyStyle(context);
    }
    return QuranTextStyles.hafsStyle(
      fontSize: QuranReaderTheme.mushafBodyFontSize,
      height: QuranReaderTheme.mushafBodyLineHeight,
      color: QuranReaderTheme.arabicText,
    );
  }

  List<InlineSpan> _buildAyahSpans(TextStyle baseStyle) {
    return widget.ayahs
        .expand((ayah) => _spansForAyah(ayah, baseStyle))
        .toList();
  }

  String get _basmallahGlyph =>
      widget.surahNumber == 97 || widget.surahNumber == 95
      ? '齃𧻓𥳐龎'
      : '齃𧻓𥳐𥉉';

  @override
  Widget build(BuildContext context) {
    _clearRecognizers();

    final showBasmallah =
        BismillahText.showStandaloneUnderHeader(widget.surahNumber);

    final baseStyle = _bodyStyle(context);
    final textDirection =
        widget.showTranslation ? TextDirection.ltr : TextDirection.rtl;
    final basmallahStyle = QuranTextStyles.basmallahStyle(
      fontSize: QuranReaderTheme.mushafBasmallahFontSize,
      color: QuranReaderTheme.arabicText,
    );

    final spans = _buildAyahSpans(baseStyle);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MushafSurahHeader(
            title: widget.headerTitle ?? widget.surahNameArabic,
            textDirection: widget.headerTextDirection ?? TextDirection.rtl,
            titleStyle: widget.headerTitleStyle,
          ),
          if (showBasmallah) ...[
            const SizedBox(height: 12),
            Center(
              child: Text(
                _basmallahGlyph,
                textAlign: TextAlign.center,
                style: basmallahStyle,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Directionality(
            textDirection: textDirection,
            child: SelectableText.rich(
              TextSpan(children: spans),
              textAlign: TextAlign.justify,
              textDirection: textDirection,
            ),
          ),
        ],
      ),
    );
  }

  String _cleanText(String text) {
    return text.trim().replaceAll('\uFEFF', '').replaceAll('\n', ' ');
  }
}
