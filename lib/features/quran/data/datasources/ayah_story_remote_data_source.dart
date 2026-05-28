import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:qareeb/features/quran/domain/entities/ayah_story.dart';

abstract class AyahStoryRemoteDataSource {
  Future<AyahStory> fetchAyahStory({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
    required String surahNameArabic,
    required String surahNameEnglish,
    required String ayahTextArabic,
    required String ayahTranslation,
  });
}

class PollinationsAyahStoryRemoteDataSource implements AyahStoryRemoteDataSource {
  PollinationsAyahStoryRemoteDataSource(this._dio);

  final Dio _dio;

  static const _model = 'openai';

  @override
  Future<AyahStory> fetchAyahStory({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
    required String surahNameArabic,
    required String surahNameEnglish,
    required String ayahTextArabic,
    required String ayahTranslation,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/openai',
      data: {
        'model': _model,
        'temperature': 0.7,
        'max_tokens': 2400,
        'messages': [
          {
            'role': 'system',
            'content': AyahStoryPrompts.system(languageCode),
          },
          {
            'role': 'user',
            'content': AyahStoryPrompts.user(
              surahNumber: surahNumber,
              ayahNumber: ayahNumber,
              languageCode: languageCode,
              surahNameArabic: surahNameArabic,
              surahNameEnglish: surahNameEnglish,
              ayahTextArabic: ayahTextArabic,
              ayahTranslation: ayahTranslation,
            ),
          },
        ],
      },
    );

    final body = response.data;
    if (body == null) {
      throw StateError('Empty AI story response');
    }

    return _parseStory(body);
  }

  AyahStory _parseStory(Map<String, dynamic> body) {
    final choices = body['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw StateError('AI returned no story choices');
    }

    final message = choices.first as Map<String, dynamic>;
    final content = (message['message'] as Map<String, dynamic>?)?['content']
        as String?;

    if (content == null || content.trim().isEmpty) {
      throw StateError('AI story content was empty');
    }

    return AyahStoryParser.parse(content.trim());
  }
}

abstract final class AyahStoryParser {
  static AyahStory parse(String raw) {
    final jsonPayload = _extractJsonObject(raw);
    final decoded = jsonDecode(jsonPayload) as Map<String, dynamic>;

    final revelationReason =
        _readField(decoded, 'revelationReason') ??
        _readField(decoded, 'reasonForRevelation');
    final howRevealed =
        _readField(decoded, 'howRevealed') ??
        _readField(decoded, 'mannerOfRevelation');
    final miracle =
        _readField(decoded, 'miracle') ?? _readField(decoded, 'miracleInVerse');

    if (revelationReason == null || howRevealed == null || miracle == null) {
      throw const FormatException('AI story JSON missing required fields');
    }

    return AyahStory(
      revelationReason: revelationReason,
      howRevealed: howRevealed,
      miracle: miracle,
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

  static String? _readField(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}

abstract final class AyahStoryPrompts {
  static String system(String languageCode) {
    if (languageCode == 'ar') {
      return 'أنت عالم مسلم متخصص في القرآن الكريم وعلومه. '
          'أجب فقط بكائن JSON صالح (بدون markdown أو نص إضافي) بالمفاتيح '
          'revelationReason و howRevealed و miracle. '
          'اكتب قيم كل حقل بالعربية الفصحى المبسطة في فقرة أو فقرتين. '
          'كن دقيقاً ومحترماً ولا تختلق أحاديث. '
          'إذا لم يُعرف شيء بثقة، اذكر ذلك بوضوح بدلاً من الاختراع.';
    }

    return 'You are a knowledgeable Muslim scholar of the Quran. '
        'Respond ONLY with valid JSON (no markdown or extra text) using the keys '
        'revelationReason, howRevealed, and miracle. '
        'Write each field value in clear English in one or two paragraphs. '
        'Be accurate, respectful, and do not invent hadith. '
        'If something is not known with confidence, say so clearly instead of inventing.';
  }

  static String user({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
    required String surahNameArabic,
    required String surahNameEnglish,
    required String ayahTextArabic,
    required String ayahTranslation,
  }) {
    final surahLabel = languageCode == 'ar'
        ? surahNameArabic
        : '$surahNameEnglish ($surahNameArabic)';

    return '''
Surah: $surahLabel
Reference: $surahNumber:$ayahNumber

Arabic text:
$ayahTextArabic

Translation:
$ayahTranslation

Return JSON with exactly these three fields:
- revelationReason: What is the reason for the revelation of this Quranic verse (asbab al-nuzul)? Include the historical context when known.
- howRevealed: How was this verse revealed to the Prophet (peace be upon him)? Describe the manner, timing, or circumstances of revelation when known.
- miracle: What is the miracle, sign, or distinctive excellence in this verse? This may include linguistic miracles, legal wisdom, prophecies, or spiritual lessons when no literal miracle is reported.

Use empty string only if truly nothing can be said; prefer a brief honest note when information is limited.
''';
  }
}
