import 'dart:async';

import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:qareeb/features/quran/domain/usecases/prefetch_surah_audio.dart';
import 'package:qareeb/features/quran/domain/usecases/resolve_ayah_audio_source.dart';
import 'package:qareeb/features/quran/presentation/services/quran_audio_player_service.dart';

typedef SurahPlaybackTick = void Function({
  required int surahNumber,
  required int ayahNumber,
  required bool isLoading,
  required bool isPlaying,
  Duration position,
  Duration? duration,
});

typedef SurahPlaybackError = void Function(String message);

typedef SurahPlaybackStopped = void Function();

class QuranSurahPlaybackService {
  QuranSurahPlaybackService({
    required ResolveAyahAudioSource resolveAyahAudioSource,
    required PrefetchSurahAudio prefetchSurahAudio,
    required QuranAudioPlayerService audioPlayer,
  }) : _resolveAyahAudioSource = resolveAyahAudioSource,
       _prefetchSurahAudio = prefetchSurahAudio,
       _audioPlayer = audioPlayer;

  final ResolveAyahAudioSource _resolveAyahAudioSource;
  final PrefetchSurahAudio _prefetchSurahAudio;
  final QuranAudioPlayerService _audioPlayer;

  StreamSubscription<ProcessingState>? _processingSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<int?>? _indexSubscription;
  CancelToken? _prefetchCancelToken;
  SurahPlaybackStopped? _onStopped;

  int? _surahNumber;
  int? _startAyah;
  int? _currentAyah;
  int? _endAyah;
  int _nextAyahToAppend = 0;
  int _playbackSessionId = 0;
  bool _isPaused = false;
  bool _isActive = false;
  bool _playlistSeeded = false;
  bool _handlingTrackCompletion = false;
  bool _kickstartInFlight = false;
  Future<void>? _playlistExtensionTask;

  static const int _resolveMaxAttempts = 6;
  static const int _advanceMaxAttempts = 20;
  static const Duration _advanceRetryDelay = Duration(milliseconds: 400);
  static const Duration _minAyahPlaybackDuration = Duration(milliseconds: 300);
  static const Duration _nearEndTolerance = Duration(milliseconds: 450);
  static const Duration _staleCompletionPositionThreshold =
      Duration(milliseconds: 800);

  bool get isActive => _isActive;

  bool get isPaused => _isPaused;

  int? get currentSurahNumber => _surahNumber;

  int? get currentAyahNumber => _currentAyah;

  bool get _isSingleAyahPlayback =>
      _startAyah != null && _endAyah != null && _startAyah == _endAyah;

  Future<void> playFromAyah({
    required int surahNumber,
    required int startAyah,
    required int endAyah,
    required SurahPlaybackTick onTick,
    required SurahPlaybackError onError,
    SurahPlaybackStopped? onStopped,
  }) async {
    _onStopped = onStopped;
    await stop();
    final sessionId = ++_playbackSessionId;
    _surahNumber = surahNumber;
    _startAyah = startAyah;
    _currentAyah = startAyah;
    _endAyah = endAyah;
    _nextAyahToAppend = startAyah;
    _isActive = true;
    _isPaused = false;

    _listenToPlayer(onTick: onTick, onError: onError);
    _startPrefetch(surahNumber: surahNumber, fromAyah: startAyah);
    unawaited(
      _seedAndExtendPlaylist(
        sessionId: sessionId,
        onTick: onTick,
        onError: onError,
      ),
    );
  }

  void _emitPlaybackTick(
    SurahPlaybackTick onTick, {
    required int surahNumber,
    required int ayahNumber,
    bool isLoading = false,
    Duration position = Duration.zero,
    Duration? duration,
  }) {
    onTick(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      isLoading: isLoading,
      isPlaying: !_isPaused && !isLoading && _audioPlayer.isPlaying,
      position: position,
      duration: duration,
    );
  }

  /// Starts audio when the UI/index moved but playback stayed idle.
  Future<void> _kickstartPlaybackIfStalled() async {
    if (!_isActive || _isPaused || _handlingTrackCompletion || _kickstartInFlight) {
      return;
    }
    if (_audioPlayer.isPlaying) return;

    _kickstartInFlight = true;
    try {
      final processing = _audioPlayer.processingState;
      if (processing == ProcessingState.loading) return;

      if (processing == ProcessingState.completed) {
        if (_isSingleAyahPlayback) {
          if (_hasFinishedCurrentTrackNaturally()) {
            await stop(notify: true);
          }
          return;
        }

        if (_audioPlayer.hasNext) {
          await _audioPlayer.seekToNextIfStalled();
        } else {
          await _audioPlayer.seekToStartOfCurrent();
        }
      }

      await _audioPlayer.play();

      await Future<void>.delayed(const Duration(milliseconds: 80));
      if (!_isActive || _isPaused || _audioPlayer.isPlaying) return;

      await _audioPlayer.ensurePlaying(replayCurrentIfCompleted: false);
    } finally {
      _kickstartInFlight = false;
    }
  }

  void _listenToPlayer({
    required SurahPlaybackTick onTick,
    required SurahPlaybackError onError,
  }) {
    _processingSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _indexSubscription?.cancel();

    _indexSubscription = _audioPlayer.currentIndexStream.listen((index) {
      final start = _startAyah;
      final surah = _surahNumber;
      if (!_isActive || index == null || start == null || surah == null) {
        return;
      }

      _currentAyah = start + index;
      _emitPlaybackTick(
        onTick,
        surahNumber: surah,
        ayahNumber: _currentAyah!,
        position: _audioPlayer.position,
        duration: _audioPlayer.duration,
      );
      if (_isSingleAyahPlayback) {
        unawaited(_finishSingleAyahPlaybackIfNearEnd());
      } else {
        unawaited(_kickstartPlaybackIfStalled());
      }
    });

    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      final surah = _surahNumber;
      final ayah = _currentAyah;
      if (surah == null || ayah == null || !_isActive) return;
      _emitPlaybackTick(
        onTick,
        surahNumber: surah,
        ayahNumber: ayah,
        position: position,
        duration: _audioPlayer.duration,
      );
      if (_isSingleAyahPlayback) {
        unawaited(_finishSingleAyahPlaybackIfNearEnd());
      } else {
        unawaited(_ensureQueueBuffer(onError: onError));
      }
    });

    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      final surah = _surahNumber;
      final ayah = _currentAyah;
      if (surah == null || ayah == null || !_isActive) return;
      _emitPlaybackTick(
        onTick,
        surahNumber: surah,
        ayahNumber: ayah,
        position: _audioPlayer.position,
        duration: duration,
      );
    });

    _playerStateSubscription = _audioPlayer.playerStateStream.listen(
      (playerState) {
        final surah = _surahNumber;
        final ayah = _currentAyah;
        if (!_isActive || surah == null || ayah == null) return;

        _emitPlaybackTick(
          onTick,
          surahNumber: surah,
          ayahNumber: ayah,
          position: _audioPlayer.position,
          duration: _audioPlayer.duration,
        );

        if (_isPaused || _handlingTrackCompletion || playerState.playing) {
          return;
        }

        if (playerState.processingState == ProcessingState.completed &&
            _isSingleAyahPlayback) {
          unawaited(_finishSingleAyahPlayback());
          return;
        }

        if (playerState.processingState == ProcessingState.ready ||
            playerState.processingState == ProcessingState.completed) {
          unawaited(_kickstartPlaybackIfStalled());
        }
      },
    );

    _processingSubscription = _audioPlayer.processingStateStream.listen(
      (state) async {
        if (!_isActive || _isPaused || _handlingTrackCompletion) return;
        if (state != ProcessingState.completed) return;
        if (!_hasFinishedCurrentTrackNaturally()) return;

        if (_isSingleAyahPlayback) {
          await _finishSingleAyahPlayback();
          return;
        }

        _handlingTrackCompletion = true;
        try {
          await _advanceToNextAyah(onTick: onTick, onError: onError);
        } finally {
          _handlingTrackCompletion = false;
        }
      },
    );
  }

  /// Stops double-tap (single ayah) playback and hides the player bar.
  Future<void> _finishSingleAyahPlayback() async {
    if (!_isActive || !_isSingleAyahPlayback || _handlingTrackCompletion) {
      return;
    }
    if (!_hasFinishedCurrentTrackNaturally()) return;

    _handlingTrackCompletion = true;
    try {
      await stop(notify: true);
    } finally {
      _handlingTrackCompletion = false;
    }
  }

  Future<void> _finishSingleAyahPlaybackIfNearEnd() async {
    if (!_isActive || !_isSingleAyahPlayback || _handlingTrackCompletion) {
      return;
    }

    final duration = _audioPlayer.duration;
    if (duration == null || duration < _minAyahPlaybackDuration) return;

    final position = _audioPlayer.position;
    if (position < duration - _nearEndTolerance) return;

    await _finishSingleAyahPlayback();
  }

  /// True when the current track actually reached the end (not a load glitch).
  bool _hasFinishedCurrentTrackNaturally() {
    if (_audioPlayer.isPlaying) return false;

    // just_audio often reports [ProcessingState.completed] with position reset
    // to zero; for a one-ayah (double-tap) session that still means finished.
    if (_isSingleAyahPlayback &&
        _audioPlayer.processingState == ProcessingState.completed) {
      return true;
    }

    final duration = _audioPlayer.duration;
    if (duration == null || duration < _minAyahPlaybackDuration) {
      return true;
    }

    final position = _audioPlayer.position;
    return position >= duration - _nearEndTolerance;
  }

  /// Ignores a late [ProcessingState.completed] after the player already moved on.
  bool _shouldIgnoreStaleCompletion({
    required int startAyah,
    required int currentAyah,
    required int playerIndex,
  }) {
    final ayahForIndex = startAyah + playerIndex;
    if (currentAyah > ayahForIndex) return true;

    if (currentAyah == ayahForIndex &&
        playerIndex > 0 &&
        _audioPlayer.position < _staleCompletionPositionThreshold) {
      return true;
    }

    return false;
  }

  /// Continues to the next queued ayah without replaying the one that finished.
  Future<void> _continueToQueuedNextAyah() async {
    if (_audioPlayer.processingState == ProcessingState.completed &&
        _audioPlayer.hasNext) {
      await _audioPlayer.seekToNextIfStalled();
      if (!_audioPlayer.isPlaying) {
        await _audioPlayer.ensurePlaying(replayCurrentIfCompleted: false);
      }
      return;
    }

    final indexBefore = _audioPlayer.currentIndex ?? 0;

    if (!_audioPlayer.isPlaying) {
      await _audioPlayer.ensurePlaying(replayCurrentIfCompleted: false);
    }

    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (!_isActive) return;

    final indexAfter = _audioPlayer.currentIndex ?? 0;
    if (indexAfter == indexBefore &&
        _audioPlayer.processingState == ProcessingState.completed &&
        _audioPlayer.hasNext) {
      await _audioPlayer.seekToNextIfStalled();
    }

    await _kickstartPlaybackIfStalled();
  }

  Future<void> _waitForPlaylistExtension() async {
    final task = _playlistExtensionTask;
    if (task != null) {
      await task;
    }
  }

  Future<void> _runPlaylistExtension({
    required SurahPlaybackError onError,
  }) {
    final existing = _playlistExtensionTask;
    if (existing != null) return existing;

    final task = _extendPlaylist();
    _playlistExtensionTask = task;
    return task.whenComplete(() {
      if (identical(_playlistExtensionTask, task)) {
        _playlistExtensionTask = null;
      }
    });
  }

  Future<String> _resolveAyahAudioSourceWithRetry({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    Object? lastError;
    var attempt = 0;
    while (attempt < _resolveMaxAttempts && _isActive) {
      try {
        return await _resolveAyahAudioSource(
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
        );
      } catch (error) {
        lastError = error;
        if (attempt < _resolveMaxAttempts - 1) {
          await Future<void>.delayed(
            Duration(milliseconds: 300 + (attempt * 200)),
          );
        }
        attempt++;
      }
    }
    throw lastError ?? StateError('Failed to resolve ayah audio');
  }

  Future<bool> _tryAppendOneNextAyah() async {
    await _waitForPlaylistExtension();

    final surah = _surahNumber;
    final end = _endAyah;
    if (!_isActive || !_playlistSeeded || surah == null || end == null) {
      return false;
    }
    if (_nextAyahToAppend > end) return false;

    final ayah = _nextAyahToAppend;
    try {
      final path = await _resolveAyahAudioSourceWithRetry(
        surahNumber: surah,
        ayahNumber: ayah,
      );
      if (!_isActive) return false;

      await _audioPlayer.appendToPlaylist(path);
      _nextAyahToAppend++;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _advanceToNextAyah({
    required SurahPlaybackTick onTick,
    required SurahPlaybackError onError,
  }) async {
    final surah = _surahNumber;
    final end = _endAyah;
    final current = _currentAyah;
    if (!_isActive || surah == null || end == null || current == null) return;

    if (current >= end) {
      await stop(notify: true);
      return;
    }

    final start = _startAyah!;
    final playerIndex = _audioPlayer.currentIndex ?? 0;

    if (_shouldIgnoreStaleCompletion(
      startAyah: start,
      currentAyah: current,
      playerIndex: playerIndex,
    )) {
      await _kickstartPlaybackIfStalled();
      _emitPlaybackTick(
        onTick,
        surahNumber: surah,
        ayahNumber: current,
        position: _audioPlayer.position,
        duration: _audioPlayer.duration,
      );
      return;
    }

    final nextAyah = current + 1;
    _emitPlaybackTick(
      onTick,
      surahNumber: surah,
      ayahNumber: nextAyah,
      isLoading: true,
    );

    if (_audioPlayer.hasNext) {
      await _continueToQueuedNextAyah();
      await _kickstartPlaybackIfStalled();
      _emitPlaybackTick(
        onTick,
        surahNumber: surah,
        ayahNumber: _currentAyah ?? nextAyah,
        position: _audioPlayer.position,
        duration: _audioPlayer.duration,
      );
      return;
    }

    var attempt = 0;
    while (attempt < _advanceMaxAttempts && _isActive && !_isPaused) {
      await _waitForPlaylistExtension();
      await _runPlaylistExtension(onError: onError);
      await _waitForPlaylistExtension();

      if (_audioPlayer.hasNext) {
        await _continueToQueuedNextAyah();
        await _kickstartPlaybackIfStalled();
        _emitPlaybackTick(
          onTick,
          surahNumber: surah,
          ayahNumber: _currentAyah ?? nextAyah,
          position: _audioPlayer.position,
          duration: _audioPlayer.duration,
        );
        return;
      }

      final appended = await _tryAppendOneNextAyah();
      if (appended && _audioPlayer.hasNext) {
        await _continueToQueuedNextAyah();
        await _kickstartPlaybackIfStalled();
        _emitPlaybackTick(
          onTick,
          surahNumber: surah,
          ayahNumber: _currentAyah ?? nextAyah,
          position: _audioPlayer.position,
          duration: _audioPlayer.duration,
        );
        return;
      }

      await Future<void>.delayed(_advanceRetryDelay);
      attempt++;
    }

    if (!_isActive) return;

    onError(
      'The next ayah is still downloading. Check your connection and tap play.',
    );
    _emitPlaybackTick(
      onTick,
      surahNumber: surah,
      ayahNumber: current,
      position: _audioPlayer.position,
      duration: _audioPlayer.duration,
    );
  }

  Future<void> _seedAndExtendPlaylist({
    required int sessionId,
    required SurahPlaybackTick onTick,
    required SurahPlaybackError onError,
  }) async {
    final surah = _surahNumber;
    final start = _startAyah;
    final end = _endAyah;
    if (surah == null || start == null || end == null) return;
    if (sessionId != _playbackSessionId) return;

    _emitPlaybackTick(
      onTick,
      surahNumber: surah,
      ayahNumber: start,
      isLoading: true,
    );

    try {
      final preloadEnd = start + 1 <= end ? start + 1 : start;
      final initialPaths = await Iterable.generate(
        preloadEnd - start + 1,
        (index) => start + index,
      ).fold<Future<List<String>?>>(
        Future.value(<String>[]),
        (previousFuture, ayah) => previousFuture.then((paths) async {
          if (paths == null || !_isActive || sessionId != _playbackSessionId) {
            return null;
          }
          return [
            ...paths,
            await _resolveAyahAudioSource(
              surahNumber: surah,
              ayahNumber: ayah,
            ),
          ];
        }),
      );

      if (initialPaths == null ||
          !_isActive ||
          sessionId != _playbackSessionId) {
        return;
      }

      await _audioPlayer.startPlaylist(initialPaths);
      if (sessionId != _playbackSessionId || !_isActive) return;

      _playlistSeeded = true;
      _nextAyahToAppend = preloadEnd + 1;

      _emitPlaybackTick(
        onTick,
        surahNumber: surah,
        ayahNumber: start,
        position: Duration.zero,
        duration: _audioPlayer.duration,
      );

      await _runPlaylistExtension(onError: onError);
      if (sessionId != _playbackSessionId || !_isActive) return;

      await _kickstartPlaybackIfStalled();
      _emitPlaybackTick(
        onTick,
        surahNumber: surah,
        ayahNumber: start,
        position: _audioPlayer.position,
        duration: _audioPlayer.duration,
      );
    } catch (error) {
      if (!_isActive || sessionId != _playbackSessionId) return;
      onError(error.toString());
      await stop(notify: true);
    }
  }

  Future<void> _ensureQueueBuffer({
    required SurahPlaybackError onError,
    bool force = false,
  }) async {
    if (!_isActive) return;

    final end = _endAyah;
    if (end == null || _nextAyahToAppend > end) return;

    final index = _audioPlayer.currentIndex ?? 0;
    final remaining = _audioPlayer.playlistLength - index - 1;
    if (!force && remaining >= 2) return;

    await _runPlaylistExtension(onError: onError);
  }

  Future<void> _extendPlaylist() async {
    if (!_playlistSeeded) return;

    final surah = _surahNumber;
    final end = _endAyah;
    if (!_isActive || surah == null || end == null) return;
    if (_nextAyahToAppend > end) return;

    while (_nextAyahToAppend <= end && _isActive) {
      try {
        final path = await _resolveAyahAudioSourceWithRetry(
          surahNumber: surah,
          ayahNumber: _nextAyahToAppend,
        );
        if (!_isActive) return;

        await _audioPlayer.appendToPlaylist(path);
        _nextAyahToAppend++;
      } catch (_) {
        // Stop batch append; [_advanceToNextAyah] retries the next ayah.
        break;
      }
    }
  }

  void _startPrefetch({required int surahNumber, required int fromAyah}) {
    _prefetchCancelToken?.cancel();
    _prefetchCancelToken = CancelToken();
    final token = _prefetchCancelToken;
    unawaited(
      _prefetchSurahAudio(
        surahNumber: surahNumber,
        fromAyah: fromAyah,
        cancelToken: token,
      ).catchError((_) {}),
    );
  }

  Future<void> pause() async {
    if (!_isActive) return;
    _isPaused = true;
    await _audioPlayer.pause();
  }

  /// Moves to the next ayah in the active playlist, extending it when needed.
  Future<bool> skipToNextAyah({
    required SurahPlaybackError onError,
    SurahPlaybackTick? onTick,
  }) async {
    if (!_isActive || !_playlistSeeded) return false;

    if (_audioPlayer.hasNext) {
      await _audioPlayer.seekToNext();
      await _audioPlayer.ensurePlaying(replayCurrentIfCompleted: false);
      return true;
    }

    final surah = _surahNumber;
    final current = _currentAyah;
    if (surah != null && current != null && onTick != null) {
      _emitPlaybackTick(
        onTick,
        surahNumber: surah,
        ayahNumber: current + 1,
        isLoading: true,
      );
    }

    await _waitForPlaylistExtension();
    await _runPlaylistExtension(onError: onError);
    await _waitForPlaylistExtension();

    if (_audioPlayer.hasNext) {
      await _audioPlayer.seekToNext();
      await _audioPlayer.ensurePlaying(replayCurrentIfCompleted: false);
      return true;
    }

    final appended = await _tryAppendOneNextAyah();
    if (appended && _audioPlayer.hasNext) {
      await _audioPlayer.seekToNext();
      await _audioPlayer.ensurePlaying(replayCurrentIfCompleted: false);
      return true;
    }

    return false;
  }

  /// Moves to the previous ayah in the playlist, or restarts one ayah earlier.
  Future<bool> skipToPreviousAyah({
    required SurahPlaybackTick onTick,
    required SurahPlaybackError onError,
    SurahPlaybackStopped? onStopped,
  }) async {
    if (!_isActive || !_playlistSeeded) return false;

    if (_audioPlayer.hasPrevious) {
      await _audioPlayer.seekToPrevious();
      return true;
    }

    final surah = _surahNumber;
    final current = _currentAyah;
    final start = _startAyah;
    final end = _endAyah;
    if (surah == null ||
        current == null ||
        start == null ||
        end == null ||
        current <= start) {
      return false;
    }

    await playFromAyah(
      surahNumber: surah,
      startAyah: current - 1,
      endAyah: end,
      onTick: onTick,
      onError: onError,
      onStopped: onStopped,
    );
    return true;
  }

  Future<void> resume({
    required SurahPlaybackTick onTick,
    required SurahPlaybackError onError,
  }) async {
    if (!_isActive) return;
    _isPaused = false;

    if (_playlistSeeded) {
      await _audioPlayer.ensurePlaying();
      return;
    }

    final sessionId = _playbackSessionId;
    unawaited(
      _seedAndExtendPlaylist(
        sessionId: sessionId,
        onTick: onTick,
        onError: onError,
      ),
    );
  }

  Future<void> stop({bool notify = false}) async {
    final wasActive = _isActive;
    _playbackSessionId++;
    _isActive = false;
    _isPaused = false;
    _playlistSeeded = false;
    _handlingTrackCompletion = false;
    _playlistExtensionTask = null;
    _prefetchCancelToken?.cancel();
    _prefetchCancelToken = null;
    _surahNumber = null;
    _startAyah = null;
    _currentAyah = null;
    _endAyah = null;
    _nextAyahToAppend = 0;

    await _processingSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _indexSubscription?.cancel();
    _processingSubscription = null;
    _playerStateSubscription = null;
    _positionSubscription = null;
    _durationSubscription = null;
    _indexSubscription = null;

    await _audioPlayer.stop();

    if (notify && wasActive) {
      _onStopped?.call();
    }
  }

  Future<void> dispose() async {
    await stop();
    await _audioPlayer.dispose();
  }
}
