import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qareeb/features/quran/domain/usecases/prefetch_surah_audio.dart';
import 'package:qareeb/features/quran/domain/usecases/resolve_ayah_audio_source.dart';
import 'package:qareeb/features/quran/presentation/services/quran_audio_player_service.dart';
import 'package:qareeb/features/quran/presentation/services/quran_surah_playback_service.dart';

class _MockResolveAyahAudioSource extends Mock
    implements ResolveAyahAudioSource {}

class _MockPrefetchSurahAudio extends Mock implements PrefetchSurahAudio {}

class _MockAudioPlayer extends Mock implements QuranAudioPlayerService {}

void main() {
  late _MockResolveAyahAudioSource resolveSource;
  late _MockPrefetchSurahAudio prefetch;
  late _MockAudioPlayer player;
  late StreamController<ProcessingState> processingController;
  late StreamController<PlayerState> playerStateController;
  late StreamController<int?> indexController;
  late QuranSurahPlaybackService service;

  setUp(() {
    resolveSource = _MockResolveAyahAudioSource();
    prefetch = _MockPrefetchSurahAudio();
    player = _MockAudioPlayer();
    processingController = StreamController<ProcessingState>.broadcast();
    playerStateController = StreamController<PlayerState>.broadcast();
    indexController = StreamController<int?>.broadcast();

    when(() => player.processingStateStream)
        .thenAnswer((_) => processingController.stream);
    when(() => player.playerStateStream)
        .thenAnswer((_) => playerStateController.stream);
    when(() => player.currentIndexStream)
        .thenAnswer((_) => indexController.stream);
    when(() => player.positionStream)
        .thenAnswer((_) => const Stream<Duration>.empty());
    when(() => player.durationStream)
        .thenAnswer((_) => const Stream<Duration?>.empty());
    when(() => player.position).thenReturn(Duration.zero);
    when(() => player.duration).thenReturn(const Duration(seconds: 1));
    when(() => player.isPlaying).thenReturn(false);
    when(() => player.hasPlaylist).thenReturn(true);
    when(() => player.hasNext).thenReturn(false);
    when(() => player.hasPrevious).thenReturn(false);
    when(() => player.currentIndex).thenReturn(0);
    when(() => player.playlistLength).thenReturn(2);
    when(() => player.startPlaylist(any())).thenAnswer((_) async {});
    when(() => player.appendToPlaylist(any())).thenAnswer((_) async {});
    when(
      () => player.ensurePlaying(
        replayCurrentIfCompleted: any(named: 'replayCurrentIfCompleted'),
      ),
    ).thenAnswer((_) async {});
    when(() => player.processingState).thenReturn(ProcessingState.ready);
    when(() => player.seekToNextIfStalled()).thenAnswer((_) async {});
    when(() => player.seekToStartOfCurrent()).thenAnswer((_) async {});
    when(() => player.play()).thenAnswer((_) async {});
    when(() => player.resume()).thenAnswer((_) async {});
    when(() => player.seekToNext()).thenAnswer((_) async {});
    when(() => player.stop()).thenAnswer((_) async {});
    when(() => player.dispose()).thenAnswer((_) async {});
    when(() => player.truncatePlaylistAfterCurrent()).thenAnswer((_) async {});

    service = QuranSurahPlaybackService(
      resolveAyahAudioSource: resolveSource,
      prefetchSurahAudio: prefetch,
      audioPlayer: player,
    );

    when(
      () => resolveSource(
        surahNumber: any(named: 'surahNumber'),
        ayahNumber: any(named: 'ayahNumber'),
      ),
    ).thenAnswer((invocation) async {
      final surah = invocation.namedArguments[#surahNumber] as int;
      final ayah = invocation.namedArguments[#ayahNumber] as int;
      return '/tmp/$surah-$ayah.mp3';
    });

    when(
      () => prefetch(
        surahNumber: any(named: 'surahNumber'),
        fromAyah: any(named: 'fromAyah'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() async {
    await processingController.close();
    await playerStateController.close();
    await indexController.close();
    await service.dispose();
  });

  test('starts playlist with first two ayahs preloaded', () async {
    await service.playFromAyah(
      surahNumber: 1,
      startAyah: 1,
      endAyah: 3,
      onTick: ({
        required int surahNumber,
        required int ayahNumber,
        required bool isLoading,
        required bool isPlaying,
        position = Duration.zero,
        duration,
      }) {},
      onError: (_) {},
    );

    await Future<void>.delayed(Duration.zero);

    verify(
      () => player.startPlaylist(['/tmp/1-1.mp3', '/tmp/1-2.mp3']),
    ).called(1);
    verify(() => player.appendToPlaylist('/tmp/1-3.mp3')).called(1);
  });

  test('does not append before playlist is seeded', () async {
    final startCompleter = Completer<void>();
    final positionController = StreamController<Duration>.broadcast();

    when(() => player.positionStream)
        .thenAnswer((_) => positionController.stream);
    when(() => player.hasPlaylist).thenReturn(false);
    when(() => player.startPlaylist(any())).thenAnswer((_) async {
      positionController.add(Duration.zero);
      return startCompleter.future;
    });

    unawaited(
      service.playFromAyah(
        surahNumber: 1,
        startAyah: 1,
        endAyah: 3,
        onTick: ({
          required int surahNumber,
          required int ayahNumber,
          required bool isLoading,
          required bool isPlaying,
          position = Duration.zero,
          duration,
        }) {},
        onError: (_) {},
      ),
    );

    await Future<void>.delayed(Duration.zero);
    verifyNever(() => player.appendToPlaylist(any()));

    startCompleter.complete();
    await Future<void>.delayed(Duration.zero);
    await positionController.close();
  });

  test('updates current ayah when playlist index advances', () async {
    final playedAyahs = <int>[];

    await service.playFromAyah(
      surahNumber: 1,
      startAyah: 1,
      endAyah: 2,
      onTick: ({
        required int surahNumber,
        required int ayahNumber,
        required bool isLoading,
        required bool isPlaying,
        position = Duration.zero,
        duration,
      }) {
        if (!isLoading) playedAyahs.add(ayahNumber);
      },
      onError: (_) {},
    );

    await Future<void>.delayed(Duration.zero);
    expect(playedAyahs, contains(1));

    indexController.add(1);
    await Future<void>.delayed(Duration.zero);

    expect(playedAyahs, contains(2));
  });

  test('does not double-seek when the player already auto-advanced', () async {
    when(() => player.currentIndex).thenReturn(1);
    when(() => player.hasNext).thenReturn(true);
    when(() => player.isPlaying).thenReturn(false);
    when(() => player.duration).thenReturn(const Duration(seconds: 5));
    when(() => player.position).thenReturn(const Duration(seconds: 1));

    await service.playFromAyah(
      surahNumber: 1,
      startAyah: 1,
      endAyah: 3,
      onTick: ({
        required int surahNumber,
        required int ayahNumber,
        required bool isLoading,
        required bool isPlaying,
        position = Duration.zero,
        duration,
      }) {},
      onError: (_) {},
    );

    await Future<void>.delayed(Duration.zero);

    processingController.add(ProcessingState.completed);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    verifyNever(() => player.seekToNext());
    verifyNever(() => player.seekToNextIfStalled());
  });

  test('retries advancing when the next ayah is still downloading', () async {
    var nextAyahReady = false;
    when(() => player.hasNext).thenAnswer((_) => nextAyahReady);
    when(() => player.playlistLength).thenReturn(1);
    when(() => player.appendToPlaylist(any())).thenAnswer((_) async {
      nextAyahReady = true;
    });

    await service.playFromAyah(
      surahNumber: 1,
      startAyah: 1,
      endAyah: 3,
      onTick: ({
        required int surahNumber,
        required int ayahNumber,
        required bool isLoading,
        required bool isPlaying,
        position = Duration.zero,
        duration,
      }) {},
      onError: (_) {},
    );

    await Future<void>.delayed(Duration.zero);

    when(() => player.currentIndex).thenReturn(0);
    processingController.add(ProcessingState.completed);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    verifyNever(() => player.seekToNext());
    verify(() => player.appendToPlaylist(any())).called(greaterThanOrEqualTo(1));
  });

  test('ignores completed events while the ayah is still playing', () async {
    when(() => player.isPlaying).thenReturn(true);
    when(() => player.duration).thenReturn(const Duration(seconds: 5));
    when(() => player.position).thenReturn(const Duration(seconds: 1));

    await service.playFromAyah(
      surahNumber: 1,
      startAyah: 1,
      endAyah: 2,
      onTick: ({
        required int surahNumber,
        required int ayahNumber,
        required bool isLoading,
        required bool isPlaying,
        position = Duration.zero,
        duration,
      }) {},
      onError: (_) {},
    );

    await Future<void>.delayed(Duration.zero);

    processingController.add(ProcessingState.completed);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    verifyNever(() => player.seekToNext());
    verifyNever(() => player.seekToNextIfStalled());
  });

  test(
    'stops single ayah when completed even if position reset to zero',
    () async {
      var stopped = false;
      when(() => player.isPlaying).thenReturn(false);
      when(() => player.duration).thenReturn(const Duration(seconds: 2));
      when(() => player.position).thenReturn(Duration.zero);
      when(() => player.processingState).thenReturn(ProcessingState.completed);

      await service.playFromAyah(
        surahNumber: 1,
        startAyah: 4,
        endAyah: 4,
        onTick: ({
          required int surahNumber,
          required int ayahNumber,
          required bool isLoading,
          required bool isPlaying,
          position = Duration.zero,
          duration,
        }) {},
        onError: (_) {},
        onStopped: () => stopped = true,
      );

      await Future<void>.delayed(Duration.zero);

      processingController.add(ProcessingState.completed);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(stopped, isTrue);
      expect(service.isActive, isFalse);
    },
  );

  test(
    'stops and notifies when the last ayah in range completes',
    () async {
    var stopped = false;
    when(() => player.isPlaying).thenReturn(false);
    when(() => player.duration).thenReturn(const Duration(seconds: 2));
    when(() => player.position).thenReturn(const Duration(seconds: 2));

    await service.playFromAyah(
      surahNumber: 1,
      startAyah: 1,
      endAyah: 1,
      onTick: ({
        required int surahNumber,
        required int ayahNumber,
        required bool isLoading,
        required bool isPlaying,
        position = Duration.zero,
        duration,
      }) {},
      onError: (_) {},
      onStopped: () => stopped = true,
    );

    await Future<void>.delayed(Duration.zero);

    when(() => player.currentIndex).thenReturn(0);
    when(() => player.hasNext).thenReturn(false);

    processingController.add(ProcessingState.completed);
    await Future<void>.delayed(Duration.zero);

    expect(stopped, isTrue);
    expect(service.isActive, isFalse);
    verify(() => player.stop()).called(greaterThanOrEqualTo(1));
  });

  test(
    'does not restart single ayah when player state reports completed',
    () async {
      var stopped = false;
      when(() => player.isPlaying).thenReturn(false);
      when(() => player.duration).thenReturn(const Duration(seconds: 2));
      when(() => player.position).thenReturn(const Duration(seconds: 2));
      when(() => player.processingState).thenReturn(ProcessingState.completed);

      await service.playFromAyah(
        surahNumber: 1,
        startAyah: 3,
        endAyah: 3,
        onTick: ({
          required int surahNumber,
          required int ayahNumber,
          required bool isLoading,
          required bool isPlaying,
          position = Duration.zero,
          duration,
        }) {},
        onError: (_) {},
        onStopped: () => stopped = true,
      );

      await Future<void>.delayed(Duration.zero);

      playerStateController.add(
        PlayerState(false, ProcessingState.completed),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(stopped, isTrue);
      expect(service.isActive, isFalse);
      verifyNever(() => player.seekToStartOfCurrent());
      verifyNever(() => player.play());
    },
  );

  test('switchReciter truncates queue and reloads from next ayah', () async {
    when(() => player.playlistLength).thenReturn(3);

    await service.playFromAyah(
      surahNumber: 1,
      startAyah: 1,
      endAyah: 7,
      onTick: ({
        required int surahNumber,
        required int ayahNumber,
        required bool isLoading,
        required bool isPlaying,
        position = Duration.zero,
        duration,
      }) {},
      onError: (_) {},
    );

    await Future<void>.delayed(Duration.zero);

    indexController.add(4);
    await Future<void>.delayed(Duration.zero);

    expect(await service.switchReciter(onError: (_) {}), isTrue);
    await Future<void>.delayed(Duration.zero);

    verify(() => player.truncatePlaylistAfterCurrent()).called(1);
    verify(
      () => resolveSource(surahNumber: 1, ayahNumber: 6),
    ).called(greaterThanOrEqualTo(1));
    verify(
      () => prefetch(
        surahNumber: 1,
        fromAyah: 6,
        cancelToken: any(named: 'cancelToken'),
      ),
    ).called(greaterThanOrEqualTo(1));
  });

  test('queues reciter switch until playlist seed completes', () async {
    final startCompleter = Completer<void>();

    when(() => player.startPlaylist(any())).thenAnswer((_) async {
      return startCompleter.future;
    });

    unawaited(
      service.playFromAyah(
        surahNumber: 1,
        startAyah: 1,
        endAyah: 3,
        onTick: ({
          required int surahNumber,
          required int ayahNumber,
          required bool isLoading,
          required bool isPlaying,
          position = Duration.zero,
          duration,
        }) {},
        onError: (_) {},
      ),
    );

    await Future<void>.delayed(Duration.zero);
    expect(await service.switchReciter(onError: (_) {}), isTrue);
    verifyNever(() => player.truncatePlaylistAfterCurrent());

    startCompleter.complete();
    await Future<void>.delayed(Duration.zero);

    verify(() => player.truncatePlaylistAfterCurrent()).called(1);
  });
}
