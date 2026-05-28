import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';

void main() {
  test('audio loading uses dedicated theme color', () {
    expect(QuranReaderTheme.audioLoading, isNot(QuranReaderTheme.ornamentGold));
    expect(QuranReaderTheme.audioLoading, isNot(QuranReaderTheme.readFlag));
  });

  test('mushaf surah body does not underline loading ayahs', () {
    final file = File('lib/features/quran/presentation/widgets/mushaf_surah_body.dart');
    final content = file.readAsStringSync();
    expect(content.contains('TextDecoration.underline'), isFalse);
  });
}
