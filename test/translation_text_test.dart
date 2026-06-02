import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/features/quran/presentation/utils/bismillah_text.dart';
import 'package:qareeb/features/quran/presentation/utils/translation_text.dart';

void main() {
  test('forDisplay removes bracketed interpretation footnotes', () {
    const withNote =
        'And Allah is Knowing of what you do. [This is an explanatory note.]';
    expect(
      TranslationText.forDisplay(withNote),
      'And Allah is Knowing of what you do.',
    );
  });

  test('stripFromTranslationAyah removes leading English Bismillah', () {
    const withBismillah =
        'In the name of Allah, the Entirely Merciful, the Especially Merciful. Alif, Lam, Meem.';
    expect(
      BismillahText.stripFromTranslationAyah(withBismillah),
      'Alif, Lam, Meem.',
    );
  });
}
