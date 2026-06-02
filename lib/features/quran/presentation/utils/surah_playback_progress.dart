/// Progress through a surah (0–1), weighting each ayah equally.
double surahPlaybackProgress({
  required int currentAyah,
  required int totalAyahs,
  required Duration position,
  Duration? currentAyahDuration,
}) {
  if (totalAyahs <= 0 || currentAyah < 1) return 0;

  final ayahFraction = currentAyahDuration != null &&
          currentAyahDuration.inMilliseconds > 0
      ? (position.inMilliseconds / currentAyahDuration.inMilliseconds)
          .clamp(0.0, 1.0)
      : 0.0;

  return ((currentAyah - 1) + ayahFraction) / totalAyahs;
}
