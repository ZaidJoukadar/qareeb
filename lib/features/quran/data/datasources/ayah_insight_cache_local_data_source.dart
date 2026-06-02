import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:qareeb/features/quran/domain/entities/ayah_insight.dart';
import 'package:qareeb/features/quran/domain/entities/ayah_word.dart';

abstract class AyahInsightCacheLocalDataSource {
  Future<AyahInsight?> getInsight({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  });

  Future<void> saveInsight(AyahInsight insight, {required String languageCode});

  Future<List<AyahWord>?> getWords({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  });

  Future<void> saveWords({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
    required List<AyahWord> words,
  });

  /// Deletes all cached ayah meanings and word-by-word data on disk.
  Future<void> clearAll();
}

class AyahInsightCacheLocalDataSourceImpl
    implements AyahInsightCacheLocalDataSource {
  AyahInsightCacheLocalDataSourceImpl({Directory? cacheRootOverride})
    : _cacheRootOverride = cacheRootOverride;

  final Directory? _cacheRootOverride;
  Directory? _rootDirectory;

  Future<Directory> _cacheRoot() async {
    if (_cacheRootOverride != null) return _cacheRootOverride;
    if (_rootDirectory != null) return _rootDirectory!;

    final documents = await getApplicationDocumentsDirectory();
    _rootDirectory = Directory(p.join(documents.path, 'qareeb_cache', 'ayah_insights'));
    return _rootDirectory!;
  }

  String _cacheKey({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  }) => '${surahNumber}_${ayahNumber}_$languageCode';

  Future<File> _insightFile({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  }) async {
    final root = await _cacheRoot();
    if (!root.existsSync()) {
      await root.create(recursive: true);
    }
    return File(
      p.join(
        root.path,
        '${_cacheKey(surahNumber: surahNumber, ayahNumber: ayahNumber, languageCode: languageCode)}_insight.json',
      ),
    );
  }

  Future<File> _wordsFile({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  }) async {
    final root = await _cacheRoot();
    if (!root.existsSync()) {
      await root.create(recursive: true);
    }
    return File(
      p.join(
        root.path,
        '${_cacheKey(surahNumber: surahNumber, ayahNumber: ayahNumber, languageCode: languageCode)}_words.json',
      ),
    );
  }

  @override
  Future<AyahInsight?> getInsight({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  }) async {
    final file = await _insightFile(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      languageCode: languageCode,
    );
    if (!file.existsSync()) return null;

    try {
      final decoded = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final meaning = decoded['meaning'] as String?;
      if (meaning == null || meaning.trim().isEmpty) return null;

      return AyahInsight(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        meaning: meaning,
      );
    } on Object {
      await file.delete();
      return null;
    }
  }

  @override
  Future<void> saveInsight(
    AyahInsight insight, {
    required String languageCode,
  }) async {
    final file = await _insightFile(
      surahNumber: insight.surahNumber,
      ayahNumber: insight.ayahNumber,
      languageCode: languageCode,
    );
    await file.writeAsString(
      jsonEncode({
        'surahNumber': insight.surahNumber,
        'ayahNumber': insight.ayahNumber,
        'languageCode': languageCode,
        'meaning': insight.meaning,
      }),
    );
  }

  @override
  Future<List<AyahWord>?> getWords({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  }) async {
    final file = await _wordsFile(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      languageCode: languageCode,
    );
    if (!file.existsSync()) return null;

    try {
      final decoded = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final wordsJson = decoded['words'] as List<dynamic>?;
      if (wordsJson == null || wordsJson.isEmpty) return null;

      return wordsJson
          .cast<Map<String, dynamic>>()
          .map(_wordFromJson)
          .toList();
    } on Object {
      await file.delete();
      return null;
    }
  }

  @override
  Future<void> saveWords({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
    required List<AyahWord> words,
  }) async {
    if (words.isEmpty) return;

    final file = await _wordsFile(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      languageCode: languageCode,
    );
    await file.writeAsString(
      jsonEncode({
        'surahNumber': surahNumber,
        'ayahNumber': ayahNumber,
        'languageCode': languageCode,
        'words': words.map(_wordToJson).toList(),
      }),
    );
  }

  AyahWord _wordFromJson(Map<String, dynamic> json) {
    return AyahWord(
      position: json['position'] as int,
      arabic: json['arabic'] as String,
      translation: json['translation'] as String,
      transliteration: json['transliteration'] as String? ?? '',
    );
  }

  Map<String, dynamic> _wordToJson(AyahWord word) {
    return {
      'position': word.position,
      'arabic': word.arabic,
      'translation': word.translation,
      'transliteration': word.transliteration,
    };
  }

  @override
  Future<void> clearAll() async {
    _rootDirectory = null;

    final cacheRootOverride = _cacheRootOverride;
    if (cacheRootOverride != null) {
      if (cacheRootOverride.existsSync()) {
        await cacheRootOverride.delete(recursive: true);
      }
      return;
    }

    final documents = await getApplicationDocumentsDirectory();
    final cacheRoot = Directory(p.join(documents.path, 'qareeb_cache'));
    if (cacheRoot.existsSync()) {
      await cacheRoot.delete(recursive: true);
    }
  }
}
