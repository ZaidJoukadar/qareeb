/// Helpers for surah revelation place (Makki / Madani).
abstract final class SurahRevelationType {
  static bool isMakki(String revelationType) =>
      revelationType.toLowerCase() == 'meccan';

  static bool isMadani(String revelationType) =>
      revelationType.toLowerCase() == 'medinan';
}
