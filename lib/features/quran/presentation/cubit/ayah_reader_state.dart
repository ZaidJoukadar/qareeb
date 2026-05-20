import 'package:equatable/equatable.dart';
import 'package:qareeb/features/quran/domain/entities/ayah.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';

enum AyahReaderStatus { initial, loading, success, failure }

class AyahReaderState extends Equatable {
  const AyahReaderState({
    this.status = AyahReaderStatus.initial,
    this.surah,
    this.ayahs = const [],
    this.playingAyahNumber,
    this.isAudioLoading = false,
    this.audioError,
    this.errorMessage,
  });

  final AyahReaderStatus status;
  final Surah? surah;
  final List<Ayah> ayahs;
  final int? playingAyahNumber;
  final bool isAudioLoading;
  final String? audioError;
  final String? errorMessage;

  AyahReaderState copyWith({
    AyahReaderStatus? status,
    Surah? surah,
    List<Ayah>? ayahs,
    int? playingAyahNumber,
    bool? isAudioLoading,
    String? audioError,
    String? errorMessage,
    bool clearPlayingAyah = false,
    bool clearAudioError = false,
  }) {
    return AyahReaderState(
      status: status ?? this.status,
      surah: surah ?? this.surah,
      ayahs: ayahs ?? this.ayahs,
      playingAyahNumber: clearPlayingAyah
          ? null
          : (playingAyahNumber ?? this.playingAyahNumber),
      isAudioLoading: isAudioLoading ?? this.isAudioLoading,
      audioError: clearAudioError ? null : (audioError ?? this.audioError),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    surah,
    ayahs,
    playingAyahNumber,
    isAudioLoading,
    audioError,
    errorMessage,
  ];
}
