import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:qareeb/features/quran/domain/entities/ayah_word.dart';

abstract class AyahWordArabicMeaningRemoteDataSource {
  Future<List<AyahWord>> enrichWithArabicMeanings({
    required int surahNumber,
    required int ayahNumber,
    required List<AyahWord> words,
  });
}

class PollinationsAyahWordArabicMeaningRemoteDataSource
    implements AyahWordArabicMeaningRemoteDataSource {
  PollinationsAyahWordArabicMeaningRemoteDataSource(this._dio);

  final Dio _dio;

  static const _model = 'openai';

  @override
  Future<List<AyahWord>> enrichWithArabicMeanings({
    required int surahNumber,
    required int ayahNumber,
    required List<AyahWord> words,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/openai',
      data: {
        'model': _model,
        'temperature': 0.2,
        'max_tokens': 1200,
        'messages': [
          {
            'role': 'system',
            'content':
                'أنت متخصص في معاني مفردات القرآن الكريم. '
                'أعد JSON صالحاً فقط (بدون markdown) بالشكل: '
                '{"words":[{"position":1,"meaning":"..."}]}. '
                'اكتب معنى كل كلمة بالعربية الفصحى المبسطة (شرح المعنى)، '
                'ولا تترجم إلى الإنجليزية. '
                'اجعل المعنى مختصراً (عبارة قصيرة بعدة كلمات، وليس حرفاً واحداً).',
          },
          {
            'role': 'user',
            'content': _buildUserPrompt(
              surahNumber: surahNumber,
              ayahNumber: ayahNumber,
              words: words,
            ),
          },
        ],
      },
    );

    final body = response.data;
    if (body == null) {
      throw StateError('Empty AI word-meaning response');
    }

    final meaningsByPosition = _parseMeanings(body);
    if (!_coversAllWords(words, meaningsByPosition)) {
      throw StateError('AI returned incomplete Arabic word meanings');
    }

    return words
        .map(
          (word) => AyahWord(
            position: word.position,
            arabic: word.arabic,
            transliteration: word.transliteration,
            translation: meaningsByPosition[word.position]!,
          ),
        )
        .toList();
  }

  bool _coversAllWords(
    List<AyahWord> words,
    Map<int, String> meaningsByPosition,
  ) {
    return words.every((word) {
      final meaning = meaningsByPosition[word.position];
      return meaning != null && _isValidArabicMeaning(meaning);
    });
  }

  bool _isValidArabicMeaning(String meaning) {
    final trimmed = meaning.trim();
    if (trimmed.runes.length < 2) return false;

    final arabicLetters =
        RegExp(r'[\u0600-\u06FF]').allMatches(trimmed).length;
    if (arabicLetters < 2) return false;

    final latinLetters = RegExp('[A-Za-z]').allMatches(trimmed).length;
    return latinLetters < arabicLetters;
  }

  String _buildUserPrompt({
    required int surahNumber,
    required int ayahNumber,
    required List<AyahWord> words,
  }) {
    final wordsLines = words
        .map(
          (word) =>
              '${word.position}. ${word.arabic} (مرجع إنجليزي: ${word.translation})',
        )
        .join('\n');

    final buffer = StringBuffer()
      ..writeln('السورة: $surahNumber')
      ..writeln('الآية: $ayahNumber')
      ..writeln('الكلمات:')
      ..writeln(wordsLines)
      ..writeln(
        '\nأعطِ معنى عربياً لكل موضع (position) في JSON كما طُلب.',
      );
    return buffer.toString();
  }

  Map<int, String> _parseMeanings(Map<String, dynamic> body) {
    final choices = body['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      return {};
    }

    final message = choices.first as Map<String, dynamic>;
    final content = (message['message'] as Map<String, dynamic>?)?['content']
        as String?;
    if (content == null || content.trim().isEmpty) {
      return {};
    }

    final jsonPayload = _extractJsonObject(content.trim());
    final decoded = jsonDecode(jsonPayload) as Map<String, dynamic>;
    final wordsJson = decoded['words'] as List<dynamic>? ?? [];

    return Map.fromEntries(
      wordsJson
          .whereType<Map<String, dynamic>>()
          .map((entry) {
            final position = entry['position'];
            final meaning = entry['meaning'] ?? entry['translation'];
            if (position is! int || meaning is! String) return null;
            final trimmed = meaning.trim();
            if (trimmed.isEmpty || !_isValidArabicMeaning(trimmed)) {
              return null;
            }
            return MapEntry(position, trimmed);
          })
          .whereType<MapEntry<int, String>>(),
    );
  }

  static String _extractJsonObject(String raw) {
    final fenceMatch = RegExp(
      r'```(?:json)?\s*(\{[\s\S]*\})\s*```',
      caseSensitive: false,
    ).firstMatch(raw);
    if (fenceMatch != null) {
      return fenceMatch.group(1)!;
    }

    final start = raw.indexOf('{');
    final end = raw.lastIndexOf('}');
    if (start != -1 && end > start) {
      return raw.substring(start, end + 1);
    }

    return raw;
  }
}
