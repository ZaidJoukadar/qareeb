import 'package:flutter/material.dart';
import 'package:qareeb/features/quran/domain/entities/ayah.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_surah_body.dart';
import 'package:qareeb/features/quran/presentation/utils/juz_label.dart';
import 'package:qareeb/features/quran/presentation/utils/surah_header_text.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_page_frame.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_surah_header.dart';
import 'package:qareeb/features/quran/presentation/widgets/surah_audio_play_button.dart';

class MushafPageBody extends StatelessWidget {
  const MushafPageBody({
    required this.ayahs,
    required this.surahsByNumber,
    required this.showTranslation,
    required this.readAyahNumbersForSurah,
    required this.flaggedAyahNumberForSurah,
    required this.isPlayingAyah,
    required this.isLoadingAyah,
    required this.isSurahPlaybackActive,
    required this.isSurahAudioLoading,
    required this.onAyahTap,
    required this.onAyahDoubleTap,
    required this.onAyahLongPress,
    required this.onSurahPlay,
    super.key,
  });

  final List<Ayah> ayahs;
  final Map<int, Surah> surahsByNumber;
  final bool showTranslation;
  final Set<int> Function(int surahNumber) readAyahNumbersForSurah;
  final int? Function(int surahNumber) flaggedAyahNumberForSurah;
  final bool Function(int surahNumber, int ayahNumber) isPlayingAyah;
  final bool Function(int surahNumber, int ayahNumber) isLoadingAyah;
  final bool Function(int surahNumber) isSurahPlaybackActive;
  final bool Function(int surahNumber) isSurahAudioLoading;
  final void Function(int surahNumber, int ayahNumber) onAyahTap;
  final void Function(int surahNumber, int ayahNumber) onAyahDoubleTap;
  final void Function(int surahNumber, int ayahNumber) onAyahLongPress;
  final void Function(int surahNumber, int firstAyahOnPage) onSurahPlay;

  @override
  Widget build(BuildContext context) {
    if (ayahs.isEmpty) {
      return const SizedBox.shrink();
    }

    final groups = ayahs.fold<Map<int, List<Ayah>>>(
      {},
      (map, ayah) {
        map.putIfAbsent(ayah.surahNumber, () => []).add(ayah);
        return map;
      },
    );

    return MushafPageFrame(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: groups.entries.map((entry) {
          return Builder(
            builder: (context) {
              final surahNumber = entry.key;
              final pageAyahs = entry.value;
              final surah = surahsByNumber[surahNumber];
              if (surah == null) {
                return const SizedBox.shrink();
              }

              final startsAtAyahOne = pageAyahs.first.ayahNumber == 1;
              final firstAyahOnPage = pageAyahs.first.ayahNumber;
              final juzNumber = pageAyahs.first.juz;
              final isArabicLocale = !showTranslation;
              final playingAyahNumber = pageAyahs.fold<int?>(
                null,
                (result, ayah) => isPlayingAyah(surahNumber, ayah.ayahNumber)
                    ? ayah.ayahNumber
                    : result,
              );
              final loadingAyahNumber = pageAyahs.fold<int?>(
                null,
                (result, ayah) => isLoadingAyah(surahNumber, ayah.ayahNumber)
                    ? ayah.ayahNumber
                    : result,
              );

              final playButton = SurahAudioPlayButton(
                isPlaying: isSurahPlaybackActive(surahNumber),
                isLoading: isSurahAudioLoading(surahNumber),
                onPressed: () => onSurahPlay(surahNumber, firstAyahOnPage),
              );

              final shortName = SurahHeaderText.shortSurahName(
                surahNumber: surahNumber,
                nameArabic: surah.nameArabic,
                isArabic: isArabicLocale,
              );
              final juzLabel = JuzLabel.format(
                juzNumber: juzNumber,
                isArabic: isArabicLocale,
              );

              return MushafSurahBody(
                surahNumber: surahNumber,
                surahNameArabic: surah.nameArabic,
                showTranslation: showTranslation,
                showSurahHeader: startsAtAyahOne,
                scrollable: false,
                juzNumber: juzNumber,
                headerPlayAction: startsAtAyahOne ? playButton : null,
                leadingPlayRow: startsAtAyahOne
                    ? null
                    : MushafSurahPlayRow(
                        title: shortName,
                        juzLabel: juzLabel,
                        textDirection: isArabicLocale
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        playAction: playButton,
                      ),
                ayahs: pageAyahs,
                readAyahNumbers: readAyahNumbersForSurah(surahNumber),
                flaggedAyahNumber: flaggedAyahNumberForSurah(surahNumber),
                playingAyahNumber: playingAyahNumber,
                loadingAyahNumber: loadingAyahNumber,
                onAyahTap: (ayahNumber) =>
                    onAyahTap(surahNumber, ayahNumber),
                onAyahDoubleTap: (ayahNumber) =>
                    onAyahDoubleTap(surahNumber, ayahNumber),
                onAyahLongPress: (ayahNumber) =>
                    onAyahLongPress(surahNumber, ayahNumber),
              );
            },
          );
        }).toList(),
        ),
      ),
    );
  }
}
