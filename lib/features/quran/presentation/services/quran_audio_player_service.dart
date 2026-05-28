import 'package:just_audio/just_audio.dart';

class QuranAudioPlayerService {
  QuranAudioPlayerService() {
    _player = AudioPlayer();
  }

  AudioPlayer? _player;
  bool _hasActivePlaylist = false;

  AudioPlayer _ensurePlayer() => _player ??= AudioPlayer();

  Stream<PlayerState> get playerStateStream => _ensurePlayer().playerStateStream;

  Stream<Duration> get positionStream => _ensurePlayer().positionStream;

  Stream<Duration?> get durationStream => _ensurePlayer().durationStream;

  Stream<ProcessingState> get processingStateStream =>
      _ensurePlayer().processingStateStream;

  Stream<int?> get currentIndexStream => _ensurePlayer().currentIndexStream;

  bool get isPlaying => _player?.playing ?? false;

  bool get hasPlaylist => _hasActivePlaylist;

  int? get currentIndex => _player?.currentIndex;

  int get playlistLength =>
      _hasActivePlaylist && _player != null ? _player!.audioSources.length : 0;

  bool get hasPrevious => _hasActivePlaylist && _player != null && _player!.hasPrevious;

  bool get hasNext => _hasActivePlaylist && _player != null && _player!.hasNext;

  ProcessingState get processingState =>
      _player?.processingState ?? ProcessingState.idle;

  Duration get position => _player?.position ?? Duration.zero;

  Duration? get duration => _player?.duration;

  Future<void> playUrl(String url) async {
    _hasActivePlaylist = false;
    final player = _ensurePlayer();
    await player.setUrl(url);
    await player.play();
  }

  Future<void> playFile(String path) async {
    _hasActivePlaylist = false;
    final player = _ensurePlayer();
    await player.setFilePath(path);
    await player.play();
  }

  Future<void> startPlaylist(List<String> paths) async {
    _hasActivePlaylist = true;
    final player = _ensurePlayer();
    await player.setAudioSources(
      paths.map(AudioSource.file).toList(),
      preload: true,
    );
    await ensurePlaying();
  }

  Future<void> appendToPlaylist(String path) async {
    if (!_hasActivePlaylist) {
      throw StateError('Playlist not started');
    }
    final player = _ensurePlayer();
    await player.addAudioSource(AudioSource.file(path));
  }

  Future<void> seekToPrevious() => _ensurePlayer().seekToPrevious();

  Future<void> seekToNext() => _ensurePlayer().seekToNext();

  Future<void> pause() => _ensurePlayer().pause();

  Future<void> play() => _ensurePlayer().play();

  Future<void> seekToStartOfCurrent() {
    final player = _ensurePlayer();
    final index = player.currentIndex ?? 0;
    return player.seek(Duration.zero, index: index);
  }

  Future<void> resume() => ensurePlaying();

  /// Starts or resumes playback without skipping ahead in the playlist.
  ///
  /// When [replayCurrentIfCompleted] is false, a completed track with a next
  /// item will not restart the current ayah (used when advancing the queue).
  Future<void> ensurePlaying({bool replayCurrentIfCompleted = true}) async {
    final player = _ensurePlayer();
    if (player.playing) return;

    if (_hasActivePlaylist && player.processingState == ProcessingState.completed) {
      if (!replayCurrentIfCompleted && player.hasNext) {
        await player.play();
        return;
      }
      final index = player.currentIndex ?? 0;
      await player.seek(Duration.zero, index: index);
    }

    await player.play();
  }

  /// Moves to the next playlist item only when still on the completed track.
  Future<void> seekToNextIfStalled() async {
    if (!_hasActivePlaylist || _player == null || !_player!.hasNext) return;
    if (_player!.processingState != ProcessingState.completed) return;
    await _player!.seekToNext();
  }

  Future<void> stop() async {
    _hasActivePlaylist = false;
    final player = _player;
    if (player == null) return;
    await player.stop();
  }

  /// Disposes the underlying [AudioPlayer].
  ///
  /// This service is intentionally restartable: after `dispose()`, the next
  /// playback will lazily create a new `AudioPlayer`.
  Future<void> dispose() async {
    final player = _player;
    if (player == null) return;

    // Force the next caller to create a fresh player.
    _player = null;
    await player.dispose();

    // Only clear playlist state if no new playback started meanwhile.
    if (_player == null) {
      _hasActivePlaylist = false;
    }
  }
}
