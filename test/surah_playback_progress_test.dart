import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/features/quran/presentation/utils/surah_playback_progress.dart';

void main() {
  test('returns zero-based surah fraction across ayahs', () {
    expect(
      surahPlaybackProgress(
        currentAyah: 1,
        totalAyahs: 7,
        position: Duration.zero,
        currentAyahDuration: const Duration(seconds: 10),
      ),
      0,
    );

    expect(
      surahPlaybackProgress(
        currentAyah: 1,
        totalAyahs: 7,
        position: const Duration(seconds: 5),
        currentAyahDuration: const Duration(seconds: 10),
      ),
      closeTo(5 / 70, 0.001),
    );

    expect(
      surahPlaybackProgress(
        currentAyah: 3,
        totalAyahs: 7,
        position: Duration.zero,
        currentAyahDuration: const Duration(seconds: 10),
      ),
      closeTo(2 / 7, 0.001),
    );

    expect(
      surahPlaybackProgress(
        currentAyah: 7,
        totalAyahs: 7,
        position: const Duration(seconds: 10),
        currentAyahDuration: const Duration(seconds: 10),
      ),
      1,
    );
  });
}
