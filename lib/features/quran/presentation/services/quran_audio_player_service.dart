import 'package:just_audio/just_audio.dart';

class QuranAudioPlayerService {
  QuranAudioPlayerService() : _player = AudioPlayer();

  final AudioPlayer _player;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Future<void> playUrl(String url) async {
    await _player.setUrl(url);
    await _player.play();
  }

  Future<void> pause() => _player.pause();

  Future<void> stop() => _player.stop();

  Future<void> dispose() => _player.dispose();
}
