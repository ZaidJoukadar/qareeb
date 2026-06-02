import 'package:qcf_quran_lite/qcf_quran_lite.dart' hide Ayah;

/// Mushaf end-of-ayah markers (QCF ornate glyphs).
abstract final class MushafVerseMarker {
  /// Arabic mushaf: per-ayah QCF ornate glyph with Arabic-Indic numeral.
  static String arabicGlyph(int surahNumber, int ayahNumber) {
    return '${getayaNoQCF(surahNumber, ayahNumber)} ';
  }
}
