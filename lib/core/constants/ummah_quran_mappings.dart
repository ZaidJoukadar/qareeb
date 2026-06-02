/// Maps between app edition identifiers and [UmmahAPI](https://ummahapi.com/api/docs) fields.
abstract final class UmmahQuranMappings {
  static const int totalMushafPages = 604;

  /// Stable audio edition identifiers kept for persisted user settings.
  static const reciterEditionById = <int, String>{
    1: 'ar.alafasy',
    2: 'ar.abdurrahmaansudais',
    3: 'ar.abdulsamad',
    4: 'ar.abdulsamad.mujawwad',
    5: 'ar.mahermuaiqly',
    6: 'ar.saadghamdi',
    7: 'ar.haniarrifai',
    8: 'ar.shaatree',
  };

  static const reciterIdByEdition = <String, int>{
    'ar.alafasy': 1,
    'ar.abdurrahmaansudais': 2,
    'ar.abdulsamad': 3,
    'ar.abdulsamad.mujawwad': 4,
    'ar.mahermuaiqly': 5,
    'ar.saadghamdi': 6,
    'ar.haniarrifai': 7,
    'ar.shaatree': 8,
  };

  static const translationKeyByEdition = <String, String>{
    'en.sahih': 'sahih_international',
    'en.pickthall': 'pickthall',
    'en.yusufali': 'yusuf_ali',
  };

  /// Reciters whose per-ayah CDN links are missing or broken in UmmahAPI.
  static const unavailableAyahAudioReciterIds = <int>{5, 6, 12};

  static int reciterIdForEdition(String editionIdentifier) {
    final mapped = reciterIdByEdition[editionIdentifier];
    if (mapped != null) return mapped;

    const prefix = 'ummah.reciter.';
    if (editionIdentifier.startsWith(prefix)) {
      return int.tryParse(editionIdentifier.substring(prefix.length)) ?? 1;
    }

    return 1;
  }

  static bool isAyahAudioAvailableForReciterId(int reciterId) {
    return !unavailableAyahAudioReciterIds.contains(reciterId);
  }

  static String editionForReciterId(int reciterId) {
    return reciterEditionById[reciterId] ?? 'ummah.reciter.$reciterId';
  }

  static String translationKeyForEdition(String editionIdentifier) {
    return translationKeyByEdition[editionIdentifier] ?? 'sahih_international';
  }

  static String revelationTypeFromPlace(String place) {
    return switch (place.toLowerCase()) {
      'makkah' || 'mecca' => 'Meccan',
      'madinah' || 'medina' => 'Medinan',
      _ => place,
    };
  }

  /// Standard Madani mushaf juz boundaries: `(surah, ayah)` where each juz starts.
  static const juzStarts = <({int surah, int ayah})>[
    (surah: 1, ayah: 1),
    (surah: 2, ayah: 142),
    (surah: 2, ayah: 253),
    (surah: 3, ayah: 93),
    (surah: 4, ayah: 24),
    (surah: 4, ayah: 147),
    (surah: 5, ayah: 82),
    (surah: 6, ayah: 110),
    (surah: 7, ayah: 87),
    (surah: 8, ayah: 41),
    (surah: 9, ayah: 93),
    (surah: 11, ayah: 6),
    (surah: 12, ayah: 52),
    (surah: 15, ayah: 1),
    (surah: 17, ayah: 1),
    (surah: 18, ayah: 75),
    (surah: 21, ayah: 1),
    (surah: 23, ayah: 1),
    (surah: 25, ayah: 21),
    (surah: 27, ayah: 56),
    (surah: 29, ayah: 46),
    (surah: 33, ayah: 31),
    (surah: 36, ayah: 28),
    (surah: 39, ayah: 32),
    (surah: 41, ayah: 47),
    (surah: 46, ayah: 1),
    (surah: 51, ayah: 31),
    (surah: 57, ayah: 30),
    (surah: 67, ayah: 1),
    (surah: 78, ayah: 1),
  ];

  static int juzForAyah({required int surahNumber, required int ayahNumber}) {
    final index = juzStarts.lastIndexWhere(
      (start) =>
          surahNumber > start.surah ||
          (surahNumber == start.surah && ayahNumber >= start.ayah),
    );
    return index >= 0 ? index + 1 : 1;
  }
}
