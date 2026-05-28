import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/presentation/cubit/ayah_reader_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/ayah_reader_state.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_page_frame.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_surah_body.dart';
import 'package:qareeb/features/quran/presentation/widgets/audio_reciter_picker_sheet.dart';
import 'package:qareeb/features/quran/presentation/widgets/quran_audio_player_bar.dart';
import 'package:qareeb/features/quran/presentation/widgets/surah_audio_play_button.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class SurahReaderBody extends StatelessWidget {
  const SurahReaderBody({
    required this.surah,
    required this.showTranslation,
    super.key,
  });

  final Surah surah;
  final bool showTranslation;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabicLocale = !showTranslation;

    return BlocBuilder<AyahReaderCubit, AyahReaderState>(
      builder: (context, state) {
        switch (state.status) {
          case AyahReaderStatus.initial:
          case AyahReaderStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case AyahReaderStatus.failure:
            return Center(child: Text(state.errorMessage ?? ''));
          case AyahReaderStatus.success:
            final cubit = context.read<AyahReaderCubit>();
            final isSurahPlaying =
                state.isSurahPlaybackActive &&
                !state.isAudioPaused &&
                !state.isAudioLoading;

            return Column(
              children: [
                if (state.audioError != null)
                  MaterialBanner(
                    content: Text(state.audioError!),
                    backgroundColor: Colors.red.shade50,
                    actions: [
                      TextButton(
                        onPressed: cubit.stopAudio,
                        child: Text(l10n.dismiss),
                      ),
                    ],
                  ),
                Expanded(
                  child: MushafPageFrame(
                    child: MushafSurahBody(
                    surahNumber: surah.number,
                    surahNameArabic: surah.nameArabic,
                    showTranslation: showTranslation,
                    juzNumber: state.ayahs.isNotEmpty
                        ? state.ayahs.first.juz
                        : 1,
                    ayahs: state.ayahs,
                    readAyahNumbers: state.readAyahNumbers,
                    flaggedAyahNumber: state.flaggedAyahNumber,
                    playingAyahNumber: state.playingAyahNumber,
                    loadingAyahNumber: state.isAudioLoading
                        ? state.playingAyahNumber
                        : null,
                    headerPlayAction: SurahAudioPlayButton(
                      isPlaying: isSurahPlaying,
                      isLoading:
                          state.isSurahPlaybackActive && state.isAudioLoading,
                      onPressed: cubit.playSurahFromStart,
                    ),
                    onAyahDoubleTap: cubit.playFromAyah,
                    onAyahLongPress: cubit.flagAyah,
                    ),
                  ),
                ),
                if (state.showAudioPlayerBar)
                  QuranAudioPlayerBar(
                    surahName: isArabicLocale
                        ? surah.nameArabic
                        : surah.nameEnglish,
                    currentAyah: state.playingAyahNumber ?? 1,
                    totalAyahs: surah.ayahCount,
                    isLoading: state.isAudioLoading,
                    isPaused: state.isAudioPaused,
                    position: state.playbackPosition,
                    duration: state.playbackDuration,
                    showAyahNavigation: !state.isSingleAyahPlayback,
                    canGoToPreviousAyah: (state.playingAyahNumber ?? 1) > 1,
                    canGoToNextAyah:
                        (state.playingAyahNumber ?? 1) < surah.ayahCount,
                    onTogglePlayPause: cubit.togglePlayPause,
                    onStop: cubit.stopAudio,
                    onPreviousAyah: cubit.skipToPreviousAyah,
                    onNextAyah: cubit.skipToNextAyah,
                    onSelectReciter: () =>
                        showAudioReciterPickerSheet(context),
                  ),
              ],
            );
        }
      },
    );
  }
}
