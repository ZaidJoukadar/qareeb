part of 'mushaf_book_reader_cubit.dart';

enum MushafBookReaderStatus { initial, loading, ready, failure }

class FlaggedAyahBookmark extends Equatable {
  const FlaggedAyahBookmark({
    required this.surahNumber,
    required this.ayahNumber,
    required this.page,
  });

  final int surahNumber;
  final int ayahNumber;
  final int page;

  @override
  List<Object?> get props => [surahNumber, ayahNumber, page];
}

class MushafBookReaderState extends Equatable {
  const MushafBookReaderState({
    this.status = MushafBookReaderStatus.initial,
    this.errorMessage,
    this.maxPage = 604,
    this.startPage = 1,
    this.currentPage = 1,
    this.surahsByNumber = const {},
    this.readAyahKeys = const {},
    this.pagesCache = const {},
    this.showTranslation = false,
    this.flaggedAyah,
    this.playingSurahNumber,
    this.playingAyahNumber,
    this.isAudioLoading = false,
    this.isAudioPaused = false,
    this.playbackPosition = Duration.zero,
    this.playbackDuration,
    this.audioError,
    this.isSingleAyahPlayback = false,
    this.jumpToPage,
  });

  final MushafBookReaderStatus status;
  final String? errorMessage;
  final int maxPage;
  final int startPage;
  final int currentPage;
  final Map<int, Surah> surahsByNumber;
  final Set<String> readAyahKeys;
  final Map<int, List<Ayah>> pagesCache;
  final bool showTranslation;
  final FlaggedAyahBookmark? flaggedAyah;
  final int? playingSurahNumber;
  final int? playingAyahNumber;
  final bool isAudioLoading;
  final bool isAudioPaused;
  final Duration playbackPosition;
  final Duration? playbackDuration;
  final String? audioError;
  final bool isSingleAyahPlayback;
  final int? jumpToPage;

  bool get isSurahPlaybackActive =>
      playingSurahNumber != null && playingAyahNumber != null;

  bool get showAudioPlayerBar => isSurahPlaybackActive;

  List<Ayah> ayahsForPage(int page) => pagesCache[page] ?? const [];

  bool isAyahRead(int surahNumber, int ayahNumber) {
    return readAyahKeys.contains(AyahKey.of(surahNumber, ayahNumber));
  }

  Set<int> readAyahNumbersForSurah(int surahNumber) {
    return readAyahKeys
        .where((key) => key.startsWith('$surahNumber-'))
        .map((key) => int.parse(key.split('-').last))
        .toSet();
  }

  int? flaggedAyahNumberForSurah(int surahNumber) {
    final bookmark = flaggedAyah;
    if (bookmark == null || bookmark.surahNumber != surahNumber) {
      return null;
    }
    return bookmark.ayahNumber;
  }

  bool isPlayingAyah(int surahNumber, int ayahNumber) {
    return playingSurahNumber == surahNumber &&
        playingAyahNumber == ayahNumber &&
        !isAudioLoading;
  }

  bool isLoadingAyah(int surahNumber, int ayahNumber) {
    return playingSurahNumber == surahNumber &&
        playingAyahNumber == ayahNumber &&
        isAudioLoading;
  }

  bool get showFlagNavigationFab {
    final bookmark = flaggedAyah;
    if (bookmark == null) return false;
    return bookmark.page != currentPage;
  }

  MushafBookReaderState copyWith({
    MushafBookReaderStatus? status,
    String? errorMessage,
    int? maxPage,
    int? startPage,
    int? currentPage,
    Map<int, Surah>? surahsByNumber,
    Set<String>? readAyahKeys,
    Map<int, List<Ayah>>? pagesCache,
    bool? showTranslation,
    FlaggedAyahBookmark? flaggedAyah,
    int? playingSurahNumber,
    int? playingAyahNumber,
    bool? isAudioLoading,
    bool? isAudioPaused,
    Duration? playbackPosition,
    Duration? playbackDuration,
    String? audioError,
    bool? isSingleAyahPlayback,
    bool clearPlayingAyah = false,
    bool clearPlaybackDuration = false,
    bool clearAudioError = false,
    bool clearFlaggedAyah = false,
    int? jumpToPage,
    bool clearJumpToPage = false,
  }) {
    return MushafBookReaderState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      maxPage: maxPage ?? this.maxPage,
      startPage: startPage ?? this.startPage,
      currentPage: currentPage ?? this.currentPage,
      surahsByNumber: surahsByNumber ?? this.surahsByNumber,
      readAyahKeys: readAyahKeys ?? this.readAyahKeys,
      pagesCache: pagesCache ?? this.pagesCache,
      showTranslation: showTranslation ?? this.showTranslation,
      flaggedAyah: clearFlaggedAyah ? null : (flaggedAyah ?? this.flaggedAyah),
      playingSurahNumber: clearPlayingAyah
          ? null
          : (playingSurahNumber ?? this.playingSurahNumber),
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
      isSingleAyahPlayback: clearPlayingAyah
          ? false
          : (isSingleAyahPlayback ?? this.isSingleAyahPlayback),
      jumpToPage: clearJumpToPage ? null : (jumpToPage ?? this.jumpToPage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    maxPage,
    startPage,
    currentPage,
    surahsByNumber,
    readAyahKeys,
    pagesCache,
    showTranslation,
    flaggedAyah,
    playingSurahNumber,
    playingAyahNumber,
    isAudioLoading,
    isAudioPaused,
    playbackPosition,
    playbackDuration,
    audioError,
    isSingleAyahPlayback,
    jumpToPage,
  ];
}
