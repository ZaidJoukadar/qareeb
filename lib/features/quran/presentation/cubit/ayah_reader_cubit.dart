import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayah_audio_url.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayahs_by_surah.dart';
import 'package:qareeb/features/quran/presentation/cubit/ayah_reader_state.dart';
import 'package:qareeb/features/quran/presentation/services/quran_audio_player_service.dart';

class AyahReaderCubit extends Cubit<AyahReaderState> {
  AyahReaderCubit({
    required GetAyahsBySurah getAyahsBySurah,
    required GetAyahAudioUrl getAyahAudioUrl,
    required QuranAudioPlayerService audioPlayer,
    required Surah surah,
    required bool showTranslation,
  }) : _getAyahsBySurah = getAyahsBySurah,
       _getAyahAudioUrl = getAyahAudioUrl,
       _audioPlayer = audioPlayer,
       _showTranslation = showTranslation,
       super(AyahReaderState(surah: surah));

  final GetAyahsBySurah _getAyahsBySurah;
  final GetAyahAudioUrl _getAyahAudioUrl;
  final QuranAudioPlayerService _audioPlayer;
  final bool _showTranslation;

  bool get showTranslation => _showTranslation;

  Future<void> load() async {
    final surah = state.surah;
    if (surah == null) return;

    emit(state.copyWith(status: AyahReaderStatus.loading));
    try {
      final ayahs = await _getAyahsBySurah(surah.number);
      emit(
        state.copyWith(
          status: AyahReaderStatus.success,
          ayahs: ayahs,
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

  Future<void> playAyah(int ayahNumber) async {
    final surah = state.surah;
    if (surah == null) return;

    emit(
      state.copyWith(
        isAudioLoading: true,
        playingAyahNumber: ayahNumber,
        clearAudioError: true,
      ),
    );

    try {
      await _audioPlayer.stop();
      final url = await _getAyahAudioUrl(
        surahNumber: surah.number,
        ayahNumber: ayahNumber,
      );
      if (url == null) {
        emit(
          state.copyWith(
            isAudioLoading: false,
            audioError: 'Audio not available',
          ),
        );
        return;
      }
      await _audioPlayer.playUrl(url);
      emit(state.copyWith(isAudioLoading: false));
    } catch (error) {
      emit(
        state.copyWith(
          isAudioLoading: false,
          audioError: error.toString(),
        ),
      );
    }
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    emit(state.copyWith(clearPlayingAyah: true, clearAudioError: true));
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
