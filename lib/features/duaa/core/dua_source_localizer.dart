abstract final class DuaSourceLocalizer {
  static const _bookReplacements = <(String, String)>[
    ('Sahih Al-Bukhari', 'صحيح البخاري'),
    ('Sahih Muslim', 'صحيح مسلم'),
    ('Abu Dawud', 'أبو داود'),
    ('At-Tirmidhi', 'الترمذي'),
    ('An-Nasai, Al-Kubra', 'النسائي الكبرى'),
    ('An-Nasai', 'النسائي'),
    ('Ibn As-Sunni', 'ابن السني'),
    ('Ibn Hibban', 'ابن حبان'),
    ('Ibn Majah', 'ابن ماجه'),
    ('Al-Muwatta\'', 'الموطأ'),
    ('Al-Bayhaqi', 'البيهقي'),
    ('Al-Azraqi', 'الأزرقي'),
    ('Al-Hakim', 'الحاكم'),
    ('Ahmad', 'أحمد'),
  ];

  static String localize(String source, {required bool isArabicLocale}) {
    if (!isArabicLocale) {
      return source;
    }

    final localized = _bookReplacements.fold(
      source.replaceAll('Quran', 'القرآن'),
      (result, replacement) =>
          result.replaceAll(replacement.$1, replacement.$2),
    );

    return _toArabicDigits(localized);
  }

  static String _toArabicDigits(String input) {
    const western = '0123456789';
    const arabic = '٠١٢٣٤٥٦٧٨٩';

    return input.split('').map((char) {
      final index = western.indexOf(char);
      return index >= 0 ? arabic[index] : char;
    }).join();
  }
}
