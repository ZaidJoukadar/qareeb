import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/quran/quran_audio_playback_errors.dart';
import 'package:qareeb/features/quran/domain/entities/ayah.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/domain/usecases/clear_quran_audio_url_cache.dart';
import 'package:qareeb/features/quran/domain/usecases/get_all_read_ayah_keys.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayahs_by_page.dart';
import 'package:qareeb/features/quran/domain/usecases/get_first_page_for_surah.dart';
import 'package:qareeb/features/quran/domain/usecases/get_mushaf_page_count.dart';
import 'package:qareeb/features/quran/domain/usecases/get_surahs.dart';
import 'package:qareeb/features/quran/domain/usecases/mark_surah_as_read.dart';
import 'package:qareeb/features/quran/domain/usecases/toggle_ayah_read.dart';
import 'package:qareeb/features/quran/presentation/services/quran_surah_playback_service.dart';
import 'package:qareeb/features/quran/presentation/utils/ayah_key.dart';

part 'mushaf_book_reader_state.dart';

class MushafBookReaderCubit extends Cubit<MushafBookReaderState> {
  MushafBookReaderCubit({
    required GetAyahsByPage getAyahsByPage,
    required GetMushafPageCount getMushafPageCount,
    required GetFirstPageForSurah getFirstPageForSurah,
    required GetSurahs getSurahs,
    required GetAllReadAyahKeys getAllReadAyahKeys,
    required ToggleAyahRead toggleAyahRead,
    required MarkSurahAsRead markSurahAsRead,
    required ClearQuranAudioUrlCache clearAudioUrlCache,
    required QuranSurahPlaybackService playback,
    required bool showTranslation,
    int? initialPage,
    int? initialSurahNumber,
  }) : _getAyahsByPage = getAyahsByPage,
       _getMushafPageCount = getMushafPageCount,
       _getFirstPageForSurah = getFirstPageForSurah,
       _getSurahs = getSurahs,
       _getAllReadAyahKeys = getAllReadAyahKeys,
       _toggleAyahRead = toggleAyahRead,
       _markSurahAsRead = markSurahAsRead,
       _clearAudioUrlCache = clearAudioUrlCache,
       _playback = playback,
       _initialPage = initialPage,
       _initialSurahNumber = initialSurahNumber,
       super(MushafBookReaderState(showTranslation: showTranslation));

  final GetAyahsByPage _getAyahsByPage;
  final GetMushafPageCount _getMushafPageCount;
  final GetFirstPageForSurah _getFirstPageForSurah;
  final GetSurahs _getSurahs;
  final GetAllReadAyahKeys _getAllReadAyahKeys;
  final ToggleAyahRead _toggleAyahRead;
  final MarkSurahAsRead _markSurahAsRead;
  final ClearQuranAudioUrlCache _clearAudioUrlCache;
  final QuranSurahPlaybackService _playback;
  final int? _initialPage;
  final int? _initialSurahNumber;

  void setShowTranslation(bool showTranslation) {
    if (state.showTranslation == showTranslation) return;
    emit(state.copyWith(showTranslation: showTranslation));
  }

  Future<void> load() async {
    emit(state.copyWith(status: MushafBookReaderStatus.loading));
    try {
      final surahs = await _getSurahs();
      final maxPage = await _getMushafPageCount();
      final readAyahKeys = await _getAllReadAyahKeys();
      final startPage = await _resolveStartPage(maxPage);

      final surahsByNumber = Map.fromEntries(
        surahs.map((surah) => MapEntry(surah.number, surah)),
      );

      final pagesCache = await _loadPagesAround(startPage, maxPage);

      emit(
        state.copyWith(
          status: MushafBookReaderStatus.ready,
          maxPage: maxPage,
          startPage: startPage,
          currentPage: startPage,
          surahsByNumber: surahsByNumber,
          readAyahKeys: readAyahKeys,
          pagesCache: pagesCache,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: MushafBookReaderStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<int> _resolveStartPage(int maxPage) async {
    if (_initialPage != null) {
      return _initialPage.clamp(1, maxPage);
    }

    if (_initialSurahNumber != null) {
      final page = await _getFirstPageForSurah(_initialSurahNumber);
      if (page != null) {
        return page.clamp(1, maxPage);
      }
    }

    return 1;
  }

  Future<Map<int, List<Ayah>>> _loadPagesAround(int page, int maxPage) async {
    final pages = <int, List<Ayah>>{};
    await {
      page - 1,
      page,
      page + 1,
    }.where((value) => value >= 1 && value <= maxPage).fold(
      Future<void>.value(),
      (previous, pageNumber) => previous.then((_) async {
        pages[pageNumber] = await _getAyahsByPage(pageNumber);
      }),
    );
    return pages;
  }

  Future<void> onPageChanged(int page) async {
    if (page == state.currentPage) return;

    emit(state.copyWith(currentPage: page, clearJumpToPage: true));
    await _ensurePagesCachedAround(page);
  }

  Future<void> navigateToSurah(int surahNumber) async {
    if (state.status != MushafBookReaderStatus.ready) return;

    final page = await _getFirstPageForSurah(surahNumber);
    if (page == null) return;

    final targetPage = page.clamp(1, state.maxPage);
    await _ensurePagesCachedAround(targetPage);
    emit(
      state.copyWith(
        currentPage: targetPage,
        jumpToPage: targetPage,
      ),
    );
  }

  void clearJumpToPage() {
    if (state.jumpToPage == null) return;
    emit(state.copyWith(clearJumpToPage: true));
  }

  Future<void> ensurePageLoaded(int page) async {
    if (state.pagesCache.containsKey(page)) return;
    await _ensurePagesCachedAround(page);
  }

  Future<void> _ensurePagesCachedAround(int page) async {
    final missingPages = {
      page - 1,
      page,
      page + 1,
    }.where((value) => value >= 1 && value <= state.maxPage);

    final updatedCache = Map<int, List<Ayah>>.from(state.pagesCache);
    var changed = false;

    await missingPages.fold(Future<void>.value(), (previous, pageNumber) {
      return previous.then((_) async {
        if (updatedCache.containsKey(pageNumber)) return;
        updatedCache[pageNumber] = await _getAyahsByPage(pageNumber);
        changed = true;
      });
    });

    if (changed) {
      emit(state.copyWith(pagesCache: updatedCache, currentPage: page));
    }
  }

  Future<void> toggleAyahRead({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final isRead = await _toggleAyahRead(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );

    final updated = Set<String>.from(state.readAyahKeys);
    final key = AyahKey.of(surahNumber, ayahNumber);
    if (isRead) {
      updated.add(key);
    } else {
      updated.remove(key);
    }

    emit(state.copyWith(readAyahKeys: updated));
  }

  void flagAyah({
    required int surahNumber,
    required int ayahNumber,
  }) {
    final current = state.flaggedAyah;
    if (current?.surahNumber == surahNumber &&
        current?.ayahNumber == ayahNumber) {
      emit(state.copyWith(clearFlaggedAyah: true));
      return;
    }

    final page = _pageForAyah(surahNumber, ayahNumber);
    emit(
      state.copyWith(
        flaggedAyah: FlaggedAyahBookmark(
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          page: page,
        ),
      ),
    );
  }

  void removeFlaggedAyah() {
    if (state.flaggedAyah == null) return;
    emit(state.copyWith(clearFlaggedAyah: true));
  }

  int _pageForAyah(int surahNumber, int ayahNumber) {
    return state.pagesCache.values
            .expand((ayahs) => ayahs)
            .where(
              (ayah) =>
                  ayah.surahNumber == surahNumber &&
                  ayah.ayahNumber == ayahNumber,
            )
            .map((ayah) => ayah.page)
            .firstOrNull ??
        state.currentPage;
  }

  Future<void> markSurahAsRead(int surahNumber) async {
    final surah = state.surahsByNumber[surahNumber];
    if (surah == null) return;

    await _markSurahAsRead(
      surahNumber: surahNumber,
      ayahCount: surah.ayahCount,
    );

    final updated = Set<String>.from(state.readAyahKeys)
      ..addAll(
        Iterable.generate(
          surah.ayahCount,
          (index) => AyahKey.of(surahNumber, index + 1),
        ),
      );

    final firstPage =
        await _getFirstPageForSurah(surahNumber) ?? _pageForAyah(surahNumber, 1);

    emit(
      state.copyWith(
        readAyahKeys: updated,
        flaggedAyah: FlaggedAyahBookmark(
          surahNumber: surahNumber,
          ayahNumber: 1,
          page: firstPage,
        ),
      ),
    );
  }

  Future<int?> pageForFlaggedAyah() async {
    final page = state.flaggedAyah?.page;
    if (page == null) return null;

    if (!state.pagesCache.containsKey(page)) {
      await _ensurePagesCachedAround(page);
    }

    return page;
  }

  bool isSurahFullyRead(int surahNumber) {
    final surah = state.surahsByNumber[surahNumber];
    if (surah == null) return false;
    return state.readAyahNumbersForSurah(surahNumber).length >= surah.ayahCount;
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
        playingSurahNumber: surahNumber,
        playingAyahNumber: ayahNumber,
        isAudioLoading: isLoading,
        isAudioPaused: !isLoading && !isPlaying,
        playbackPosition: position,
        playbackDuration: duration,
        clearAudioError: true,
      ),
    );
  }

  void _onPlaybackError(Object error) {
    emit(
      state.copyWith(
        isAudioLoading: false,
        audioError: error is String
            ? error
            : QuranAudioPlaybackErrors.keyFor(error),
      ),
    );
  }

  Future<void> playSurahFromPageStart({
    required int surahNumber,
    required int firstAyahOnPage,
  }) async {
    final surah = state.surahsByNumber[surahNumber];
    if (surah == null) return;

    if (state.isSurahPlaybackActive &&
        state.playingSurahNumber == surahNumber &&
        !state.isAudioPaused &&
        !state.isAudioLoading) {
      await pauseAudio();
      return;
    }

    await _startPlayback(
      surahNumber: surahNumber,
      startAyah: firstAyahOnPage,
      endAyah: surah.ayahCount,
    );
  }

  Future<void> playFromAyah({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final surah = state.surahsByNumber[surahNumber];
    if (surah == null) return;

    if (state.isPlayingAyah(surahNumber, ayahNumber) && !state.isAudioLoading) {
      await stopAudio();
      return;
    }

    await _startPlayback(
      surahNumber: surahNumber,
      startAyah: ayahNumber,
      endAyah: ayahNumber,
    );
  }

  Future<void> _startPlayback({
    required int surahNumber,
    required int startAyah,
    required int endAyah,
  }) async {
    final isSingleAyah = startAyah == endAyah;

    emit(
      state.copyWith(
        playingSurahNumber: surahNumber,
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
      surahNumber: surahNumber,
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

        // For double-tap (single ayah) dispose fully after the track ends.
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

  Future<void> onReciterChanged() async {
    if (state.isSingleAyahPlayback || !_playback.isActive) return;

    _clearAudioUrlCache();
    emit(state.copyWith(clearAudioError: true));

    if (await _playback.switchReciter(onError: _onPlaybackError)) {
      return;
    }

    // Retry while the playlist is still starting up.
    for (var attempt = 0; attempt < 20; attempt++) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (!_playback.isActive || isClosed) return;
      if (await _playback.switchReciter(onError: _onPlaybackError)) {
        return;
      }
    }
  }

  Future<void> skipToPreviousAyah() async {
    if (state.isSingleAyahPlayback) return;

    final surahNumber = state.playingSurahNumber;
    final current = state.playingAyahNumber;
    final surah = surahNumber == null
        ? null
        : state.surahsByNumber[surahNumber];
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

    await _startPlayback(
      surahNumber: surah.number,
      startAyah: current - 1,
      endAyah: surah.ayahCount,
    );
  }

  Future<void> skipToNextAyah() async {
    if (state.isSingleAyahPlayback) return;

    final surahNumber = state.playingSurahNumber;
    final current = state.playingAyahNumber;
    final surah = surahNumber == null
        ? null
        : state.surahsByNumber[surahNumber];
    if (surah == null || current == null) return;

    final handled = await _playback.skipToNextAyah(
      onError: _onPlaybackError,
      onTick: _onPlaybackTick,
    );
    if (handled) return;

    if (current >= surah.ayahCount) {
      await stopAudio();
      return;
    }

    if (current < surah.ayahCount) {
      await _startPlayback(
        surahNumber: surah.number,
        startAyah: current + 1,
        endAyah: surah.ayahCount,
      );
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
