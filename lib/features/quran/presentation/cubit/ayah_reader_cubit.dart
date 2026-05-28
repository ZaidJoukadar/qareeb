import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayahs_by_surah.dart';
import 'package:qareeb/features/quran/domain/usecases/get_read_ayah_numbers.dart';
import 'package:qareeb/features/quran/domain/usecases/mark_surah_as_read.dart';
import 'package:qareeb/features/quran/domain/usecases/toggle_ayah_read.dart';
import 'package:qareeb/features/quran/presentation/cubit/ayah_reader_state.dart';
import 'package:qareeb/features/quran/presentation/services/quran_surah_playback_service.dart';

class AyahReaderCubit extends Cubit<AyahReaderState> {
  AyahReaderCubit({
    required GetAyahsBySurah getAyahsBySurah,
    required GetReadAyahNumbers getReadAyahNumbers,
    required ToggleAyahRead toggleAyahRead,
    required MarkSurahAsRead markSurahAsRead,
    required QuranSurahPlaybackService playback,
    required Surah surah,
    required bool showTranslation,
  }) : _getAyahsBySurah = getAyahsBySurah,
       _getReadAyahNumbers = getReadAyahNumbers,
       _toggleAyahRead = toggleAyahRead,
       _markSurahAsRead = markSurahAsRead,
       _playback = playback,
       _showTranslation = showTranslation,
       super(AyahReaderState(surah: surah));

  final GetAyahsBySurah _getAyahsBySurah;
  final GetReadAyahNumbers _getReadAyahNumbers;
  final ToggleAyahRead _toggleAyahRead;
  final MarkSurahAsRead _markSurahAsRead;
  final QuranSurahPlaybackService _playback;
  final bool _showTranslation;

  bool get showTranslation => _showTranslation;

  Future<void> load() async {
    final surah = state.surah;
    if (surah == null) return;

    emit(state.copyWith(status: AyahReaderStatus.loading));
    try {
      final ayahs = await _getAyahsBySurah(surah.number);
      final readAyahNumbers = await _getReadAyahNumbers(surah.number);

      emit(
        state.copyWith(
          status: AyahReaderStatus.success,
          ayahs: ayahs,
          readAyahNumbers: readAyahNumbers,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AyahReaderStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> toggleAyahRead(int ayahNumber) async {
    final surah = state.surah;
    if (surah == null) return;

    final isRead = await _toggleAyahRead(
      surahNumber: surah.number,
      ayahNumber: ayahNumber,
    );

    final updated = Set<int>.from(state.readAyahNumbers);
    if (isRead) {
      updated.add(ayahNumber);
    } else {
      updated.remove(ayahNumber);
    }

    emit(state.copyWith(readAyahNumbers: updated));
  }

  Future<void> markSurahAsRead() async {
    final surah = state.surah;
    if (surah == null) return;

    await _markSurahAsRead(
      surahNumber: surah.number,
      ayahCount: surah.ayahCount,
    );

    emit(
      state.copyWith(
        readAyahNumbers: Iterable.generate(
          surah.ayahCount,
          (index) => index + 1,
        ).toSet(),
      ),
    );
  }

  bool isSurahFullyRead() {
    final surah = state.surah;
    if (surah == null) return false;
    return state.readAyahNumbers.length >= surah.ayahCount;
  }

  void _onPlaybackTick({
    required int surahNumber,
    required int ayahNumber,
    required bool isLoading,
    required bool isPlaying,
    Duration position = Duration.zero,
    Duration? duration,
  }) {
    if (!_playback.isActive) return;

    emit(
      state.copyWith(
        playingAyahNumber: ayahNumber,
        isAudioLoading: isLoading,
        isAudioPaused: !isLoading && !isPlaying,
        playbackPosition: position,
        playbackDuration: duration,
        clearAudioError: true,
      ),
    );
  }

  void _onPlaybackError(String message) {
    emit(
      state.copyWith(
        isAudioLoading: false,
        audioError: message,
      ),
    );
  }

  Future<void> playSurahFromStart() async {
    final surah = state.surah;
    if (surah == null) return;

    if (state.isSurahPlaybackActive && !state.isAudioPaused && !state.isAudioLoading) {
      await pauseAudio();
      return;
    }

    await _startPlayback(startAyah: 1, endAyah: surah.ayahCount);
  }

  Future<void> playFromAyah(int ayahNumber) async {
    final surah = state.surah;
    if (surah == null) return;

    if (state.playingAyahNumber == ayahNumber && !state.isAudioLoading) {
      await stopAudio();
      return;
    }

    await _startPlayback(startAyah: ayahNumber, endAyah: ayahNumber);
  }

  void flagAyah(int ayahNumber) {
    if (state.flaggedAyahNumber == ayahNumber) {
      emit(state.copyWith(clearFlaggedAyah: true));
      return;
    }
    emit(state.copyWith(flaggedAyahNumber: ayahNumber));
  }

  Future<void> _startPlayback({
    required int startAyah,
    required int endAyah,
  }) async {
    final surah = state.surah!;

    final isSingleAyah = startAyah == endAyah;

    emit(
      state.copyWith(
        playingAyahNumber: startAyah,
        isAudioLoading: true,
        isAudioPaused: false,
        isSingleAyahPlayback: isSingleAyah,
        playbackPosition: Duration.zero,
        clearPlaybackDuration: true,
        clearAudioError: true,
      ),
    );

    await _playback.playFromAyah(
      surahNumber: surah.number,
      startAyah: startAyah,
      endAyah: endAyah,
      onTick: _onPlaybackTick,
      onError: _onPlaybackError,
      onStopped: () {
        if (isClosed) return;
        emit(
          state.copyWith(
            clearPlayingAyah: true,
            isAudioLoading: false,
            isAudioPaused: false,
            playbackPosition: Duration.zero,
            clearPlaybackDuration: true,
          ),
        );

        // For double-tap (single ayah) we fully dispose the audio resources
        // when the track ends naturally.
        if (isSingleAyah) {
          unawaited(_playback.dispose());
        }
      },
    );
  }

  Future<void> pauseAudio() async {
    await _playback.pause();
    emit(state.copyWith(isAudioPaused: true));
  }

  Future<void> resumeAudio() async {
    emit(state.copyWith(isAudioPaused: false));
    await _playback.resume(
      onTick: _onPlaybackTick,
      onError: _onPlaybackError,
    );
  }

  Future<void> togglePlayPause() async {
    if (state.isAudioPaused) {
      await resumeAudio();
    } else if (state.isSurahPlaybackActive) {
      await pauseAudio();
    }
  }

  Future<void> skipToPreviousAyah() async {
    if (state.isSingleAyahPlayback) return;

    final surah = state.surah;
    final current = state.playingAyahNumber;
    if (surah == null || current == null || current <= 1) return;

    final handled = await _playback.skipToPreviousAyah(
      onTick: _onPlaybackTick,
      onError: _onPlaybackError,
      onStopped: () {
        if (isClosed) return;
        emit(
          state.copyWith(
            clearPlayingAyah: true,
            isAudioLoading: false,
            isAudioPaused: false,
            playbackPosition: Duration.zero,
            clearPlaybackDuration: true,
          ),
        );
      },
    );
    if (handled) return;

    await _startPlayback(startAyah: current - 1, endAyah: surah.ayahCount);
  }

  Future<void> skipToNextAyah() async {
    if (state.isSingleAyahPlayback) return;

    final surah = state.surah;
    final current = state.playingAyahNumber;
    if (surah == null || current == null) return;

    if (current >= surah.ayahCount) {
      await stopAudio();
      return;
    }

    final handled = await _playback.skipToNextAyah(
      onError: _onPlaybackError,
      onTick: _onPlaybackTick,
    );
    if (handled) return;

    if (current < surah.ayahCount) {
      await _startPlayback(startAyah: current + 1, endAyah: surah.ayahCount);
    } else {
      await stopAudio();
    }
  }

  Future<void> stopAudio() async {
    await _playback.stop();
    emit(
      state.copyWith(
        clearPlayingAyah: true,
        isAudioLoading: false,
        isAudioPaused: false,
        playbackPosition: Duration.zero,
        clearPlaybackDuration: true,
        clearAudioError: true,
      ),
    );
  }

  @override
  Future<void> close() {
    _playback.dispose();
    return super.close();
  }
}
