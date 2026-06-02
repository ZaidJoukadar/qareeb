/// Cleans English translation lines for mushaf display (translation only, no tafsir).
abstract final class TranslationText {
  /// Footnotes / interpretive notes some editions embed in brackets.
  static final RegExp _bracketedNotes = RegExp(r'\[[^\]]*\]');

  /// Returns [text] without bracketed interpretation footnotes.
  static String forDisplay(String text) {
    final withoutNotes = text.replaceAll(_bracketedNotes, '');
    return withoutNotes.replaceAll(RegExp(r'  +'), ' ').trim();
  }
}
