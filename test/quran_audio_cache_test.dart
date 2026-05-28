import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/core/quran/quran_audio_reciter_settings.dart';
import 'package:qareeb/features/quran/data/datasources/quran_audio_cache_data_source.dart';

void main() {
  late Directory tempDir;
  late QuranAudioCacheDataSourceImpl cache;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('qareeb_audio_test_');
    cache = QuranAudioCacheDataSourceImpl(
      Dio(),
      QuranAudioReciterSettings(),
      cacheRootOverride: tempDir,
    );
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('cachedFile returns null when file is missing', () async {
    final file = await cache.cachedFile(surahNumber: 1, ayahNumber: 1);
    expect(file, isNull);
  });

  test('deduplicates concurrent downloads for the same ayah', () async {
    var requestCount = 0;
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));

    server.listen((request) async {
      requestCount++;
      await Future<void>.delayed(const Duration(milliseconds: 50));
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType('audio', 'mpeg')
        ..add([1, 2, 3, 4])
        ..close();
    });

    final cacheWithNetwork = QuranAudioCacheDataSourceImpl(
      Dio(),
      QuranAudioReciterSettings(),
      cacheRootOverride: tempDir,
    );
    final url =
        'http://${InternetAddress.loopbackIPv4.address}:${server.port}/83.mp3';

    final results = await Future.wait([
      cacheWithNetwork.downloadToCache(
        surahNumber: 2,
        ayahNumber: 83,
        url: url,
      ),
      cacheWithNetwork.downloadToCache(
        surahNumber: 2,
        ayahNumber: 83,
        url: url,
      ),
    ]);

    expect(requestCount, 1);
    expect(results[0].path, results[1].path);
    expect(results[0].existsSync(), isTrue);
  });

  test('downloadToCache returns existing file without network', () async {
    final surahDir = Directory('${tempDir.path}/1');
    await surahDir.create(recursive: true);
    final existing = File('${surahDir.path}/1.mp3');
    await existing.writeAsBytes([1, 2, 3]);

    final file = await cache.downloadToCache(
      surahNumber: 1,
      ayahNumber: 1,
      url: 'https://invalid.example/should-not-fetch.mp3',
    );

    expect(file.path, existing.path);
    expect(await file.length(), 3);
  });

  test('clearAll removes cached audio files', () async {
    final surahDir = Directory('${tempDir.path}/1');
    await surahDir.create(recursive: true);
    await File('${surahDir.path}/1.mp3').writeAsBytes([1, 2, 3]);

    expect(await cache.cachedFile(surahNumber: 1, ayahNumber: 1), isNotNull);

    await cache.clearAll();

    expect(tempDir.existsSync(), isFalse);
    expect(await cache.cachedFile(surahNumber: 1, ayahNumber: 1), isNull);
  });
}
