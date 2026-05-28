import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:qareeb/core/quran/quran_audio_reciter_settings.dart';

abstract class QuranAudioCacheDataSource {
  Future<File?> cachedFile({
    required int surahNumber,
    required int ayahNumber,
  });

  Future<File> downloadToCache({
    required int surahNumber,
    required int ayahNumber,
    required String url,
    CancelToken? cancelToken,
  });

  Future<void> prefetchAyahs({
    required int surahNumber,
    required Map<int, String> urls,
    required int fromAyah,
    CancelToken? cancelToken,
    int maxConcurrent = 3,
  });

  /// Deletes all downloaded Quran recitation audio files on disk.
  Future<void> clearAll();
}

class QuranAudioCacheDataSourceImpl implements QuranAudioCacheDataSource {
  QuranAudioCacheDataSourceImpl(
    this._dio,
    this._audioReciterSettings, {
    Directory? cacheRootOverride,
  }) : _cacheRootOverride = cacheRootOverride;

  final Dio _dio;
  final QuranAudioReciterSettings _audioReciterSettings;
  final Directory? _cacheRootOverride;
  Directory? _rootDirectory;
  String? _rootEdition;
  final Map<String, Future<File>> _inFlightDownloads = {};

  Future<Directory> _cacheRoot() async {
    if (_cacheRootOverride != null) return _cacheRootOverride;

    final edition = _audioReciterSettings.editionIdentifier;
    if (_rootDirectory != null && _rootEdition == edition) {
      return _rootDirectory!;
    }

    final documents = await getApplicationDocumentsDirectory();
    _rootEdition = edition;
    _rootDirectory = Directory(
      p.join(
        documents.path,
        'quran_audio',
        edition,
      ),
    );
    return _rootDirectory!;
  }

  Future<File> _fileFor({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final root = await _cacheRoot();
    final surahDir = Directory(p.join(root.path, '$surahNumber'));
    if (!surahDir.existsSync()) {
      await surahDir.create(recursive: true);
    }
    return File(p.join(surahDir.path, '$ayahNumber.mp3'));
  }

  @override
  Future<File?> cachedFile({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final file = await _fileFor(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    if (file.existsSync() && await file.length() > 0) {
      return file;
    }
    return null;
  }

  String _cacheKey({
    required int surahNumber,
    required int ayahNumber,
  }) => '$surahNumber:$ayahNumber';

  @override
  Future<File> downloadToCache({
    required int surahNumber,
    required int ayahNumber,
    required String url,
    CancelToken? cancelToken,
  }) async {
    final existing = await cachedFile(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    if (existing != null) return existing;

    final key = _cacheKey(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    final inFlight = _inFlightDownloads[key];
    if (inFlight != null) return inFlight;

    final download = _downloadToCache(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      url: url,
      cancelToken: cancelToken,
    );
    _inFlightDownloads[key] = download;
    try {
      return await download;
    } finally {
      if (identical(_inFlightDownloads[key], download)) {
        _inFlightDownloads.remove(key);
      }
    }
  }

  Future<File> _downloadToCache({
    required int surahNumber,
    required int ayahNumber,
    required String url,
    CancelToken? cancelToken,
  }) async {
    final cachedAfterWait = await cachedFile(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    if (cachedAfterWait != null) return cachedAfterWait;

    final file = await _fileFor(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    final tempFile = File('${file.path}.part');

    try {
      await _dio.download(
        url,
        tempFile.path,
        cancelToken: cancelToken,
      );
      return await _finalizeDownload(file: file, tempFile: tempFile);
    } catch (error) {
      final cachedDespiteError = await cachedFile(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
      );
      if (cachedDespiteError != null) return cachedDespiteError;

      if (tempFile.existsSync()) {
        await tempFile.delete();
      }
      rethrow;
    }
  }

  Future<File> _finalizeDownload({
    required File file,
    required File tempFile,
  }) async {
    if (await tempFile.exists()) {
      if (file.existsSync()) {
        await file.delete();
      }
      await tempFile.rename(file.path);
      return file;
    }

    if (file.existsSync() && await file.length() > 0) {
      return file;
    }

    throw StateError('Audio download incomplete for ${file.path}');
  }

  @override
  Future<void> prefetchAyahs({
    required int surahNumber,
    required Map<int, String> urls,
    required int fromAyah,
    CancelToken? cancelToken,
    int maxConcurrent = 3,
  }) async {
    final ayahNumbers = urls.keys.where((n) => n >= fromAyah).toList()..sort();
    if (ayahNumbers.isEmpty) return;

    var index = 0;
    while (index < ayahNumbers.length) {
      if (cancelToken?.isCancelled ?? false) return;

      final batch = ayahNumbers.skip(index).take(maxConcurrent).toList();
      index += batch.length;

      await Future.wait(
        batch.map((ayahNumber) async {
          if (cancelToken?.isCancelled ?? false) return;
          final url = urls[ayahNumber];
          if (url == null) return;
          final cached = await cachedFile(
            surahNumber: surahNumber,
            ayahNumber: ayahNumber,
          );
          if (cached != null) return;
          try {
            await downloadToCache(
              surahNumber: surahNumber,
              ayahNumber: ayahNumber,
              url: url,
              cancelToken: cancelToken,
            );
          } on DioException catch (error) {
            if (CancelToken.isCancel(error)) return;
            rethrow;
          }
        }),
      );
    }
  }

  @override
  Future<void> clearAll() async {
    _inFlightDownloads.clear();
    _rootDirectory = null;
    _rootEdition = null;

    final cacheRootOverride = _cacheRootOverride;
    if (cacheRootOverride != null) {
      if (cacheRootOverride.existsSync()) {
        await cacheRootOverride.delete(recursive: true);
      }
      return;
    }

    final documents = await getApplicationDocumentsDirectory();
    final audioRoot = Directory(p.join(documents.path, 'quran_audio'));
    if (audioRoot.existsSync()) {
      await audioRoot.delete(recursive: true);
    }
  }
}
