import 'package:qareeb/features/quran/presentation/utils/arabic_numerals.dart';

/// Human-readable juz labels for mushaf headers (1–30).
abstract final class JuzLabel {
  static const _arabicOrdinals = {
    1: 'الأول',
    2: 'الثاني',
    3: 'الثالث',
    4: 'الرابع',
    5: 'الخامس',
    6: 'السادس',
    7: 'السابع',
    8: 'الثامن',
    9: 'التاسع',
    10: 'العاشر',
    11: 'الحادي عشر',
    12: 'الثاني عشر',
    13: 'الثالث عشر',
    14: 'الرابع عشر',
    15: 'الخامس عشر',
    16: 'السادس عشر',
    17: 'السابع عشر',
    18: 'الثامن عشر',
    19: 'التاسع عشر',
    20: 'العشرون',
    21: 'الحادي والعشرون',
    22: 'الثاني والعشرون',
    23: 'الثالث والعشرون',
    24: 'الرابع والعشرون',
    25: 'الخامس والعشرون',
    26: 'السادس والعشرون',
    27: 'السابع والعشرون',
    28: 'الثامن والعشرون',
    29: 'التاسع والعشرون',
    30: 'الثلاثون',
  };

  static String format({
    required int juzNumber,
    required bool isArabic,
  }) {
    final juz = juzNumber.clamp(1, 30);
    if (isArabic) {
      final ordinal = _arabicOrdinals[juz] ?? toArabicIndicNumerals(juz);
      return 'الجزء $ordinal';
    }
    return "Juz' $juz";
  }
}
