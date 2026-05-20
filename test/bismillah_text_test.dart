import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/features/quran/presentation/utils/bismillah_text.dart';

void main() {
  test('showStandaloneUnderHeader is false only for surah 9', () {
    expect(BismillahText.showStandaloneUnderHeader(9), isFalse);
    expect(BismillahText.showStandaloneUnderHeader(2), isTrue);
  });

  test('stripFromAyah removes leading Bismillah from ayah 1 text', () {
    // Exact Uthmani string from alquran.cloud surah 2 ayah 1.
    const withBismillah =
        'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ الٓمٓ';
    expect(
      BismillahText.stripFromAyah(withBismillah),
      'الٓمٓ',
    );
  });

  test('stripFromAyah returns empty when ayah is only Bismillah', () {
    const onlyBismillah = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';
    expect(BismillahText.stripFromAyah(onlyBismillah), isEmpty);
  });
}
