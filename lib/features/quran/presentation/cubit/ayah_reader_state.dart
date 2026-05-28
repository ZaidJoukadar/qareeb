import 'package:equatable/equatable.dart';
import 'package:qareeb/features/quran/domain/entities/ayah.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';

enum AyahReaderStatus { initial, loading, success, failure }

class AyahReaderState extends Equatable {
  const AyahReaderState({
    this.status = AyahReaderStatus.initial,
    this.surah,
    this.ayahs = const [],
    this.readAyahNumbers = const {},
    this.flaggedAyahNumber,
    this.playingAyahNumber,
    this.isAudioLoading = false,
    this.isAudioPaused = false,
    this.playbackPosition = Duration.zero,
    this.playbackDuration,
    this.audioError,
    this.errorMessage,
    this.isSingleAyahPlayback = false,
  });

  final AyahReaderStatus status;
  final Surah? surah;
  final List<Ayah> ayahs;
  final Set<int> readAyahNumbers;
  final int? flaggedAyahNumber;
  final int? playingAyahNumber;
  final bool isAudioLoading;
  final bool isAudioPaused;
  final Duration playbackPosition;
  final Duration? playbackDuration;
  final String? audioError;
  final String? errorMessage;
  final bool isSingleAyahPlayback;

  bool get isSurahPlaybackActive => playingAyahNumber != null;

  bool get showAudioPlayerBar => isSurahPlaybackActive;

  AyahReaderState copyWith({
    AyahReaderStatus? status,
    Surah? surah,
    List<Ayah>? ayahs,
    Set<int>? readAyahNumbers,
    int? flaggedAyahNumber,
    int? playingAyahNumber,
    bool? isAudioLoading,
    bool? isAudioPaused,
    Duration? playbackPosition,
    Duration? playbackDuration,
    String? audioError,
    String? errorMessage,
    bool? isSingleAyahPlayback,
    bool clearPlayingAyah = false,
    bool clearFlaggedAyah = false,
    bool clearAudioError = false,
    bool clearPlaybackDuration = false,
  }) {
    return AyahReaderState(
      status: status ?? this.status,
      surah: surah ?? this.surah,
      ayahs: ayahs ?? this.ayahs,
      readAyahNumbers: readAyahNumbers ?? this.readAyahNumbers,
      flaggedAyahNumber: clearFlaggedAyah
          ? null
          : (flaggedAyahNumber ?? this.flaggedAyahNumber),
      playingAyahNumber: clearPlayingAyah
          ? null
          : (playingAyahNumber ?? this.playingAyahNumber),
      isAudioLoading: isAudioLoading ?? this.isAudioLoading,
      isAudioPaused: isAudioPaused ?? this.isAudioPaused,
      playbackPosition: playbackPosition ?? this.playbackPosition,
      playbackDuration: clearPlaybackDuration
          ? null
          : (playbackDuration ?? this.playbackDuration),
      audioError: clearAudioError ? null : (audioError ?? this.audioError),
      errorMessage: errorMessage ?? this.errorMessage,
      isSingleAyahPlayback: clearPlayingAyah
          ? false
          : (isSingleAyahPlayback ?? this.isSingleAyahPlayback),
    );
  }

  @override
  List<Object?> get props => [
    status,
    surah,
    ayahs,
    readAyahNumbers,
    flaggedAyahNumber,
    playingAyahNumber,
    isAudioLoading,
    isAudioPaused,
    playbackPosition,
    playbackDuration,
    audioError,
    errorMessage,
    isSingleAyahPlayback,
  ];
}
