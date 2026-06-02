import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/features/quran/presentation/utils/arabic_numerals.dart';

void main() {
  test('toArabicIndicNumerals converts digits', () {
    expect(toArabicIndicNumerals(285), '٢٨٥');
    expect(toArabicIndicNumerals(1), '١');
    expect(toArabicIndicNumerals(114), '١١٤');
  });
}
