import 'package:dio/dio.dart';
import 'package:qareeb/core/constants/quran_editions.dart';
import 'package:qareeb/core/constants/ummah_quran_mappings.dart';
import 'package:qareeb/core/network/ummah_api_response.dart';
import 'package:qareeb/core/quran/quran_audio_reciter_settings.dart';
import 'package:qareeb/features/quran/data/datasources/quran_ayah_metadata_index.dart';
import 'package:qareeb/features/quran/data/models/audio_edition_dto.dart';
import 'package:qareeb/features/quran/data/models/ayah_dto.dart';
import 'package:qareeb/features/quran/data/models/surah_detail_dto.dart';
import 'package:qareeb/features/quran/data/models/surah_summary_dto.dart';
import 'package:qareeb/features/quran/domain/entities/ayah_insight.dart';

abstract class QuranRemoteDataSource {
  Future<List<SurahSummaryDto>> fetchSurahList();

  Future<({SurahDetailDto arabic, SurahDetailDto translation})>
  fetchSurahTextEditions({
    required int surahNumber,
    required String translationEdition,
  });

  Future<List<AyahDto>> fetchSurahAudioAyahs(int surahNumber);

  Future<String?> fetchAyahAudioUrl({
    required int surahNumber,
    required int ayahNumber,
  });

  Future<List<AudioEditionDto>> fetchAudioEditions();

  Future<AyahInsight> fetchAyahInsight({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  });
}

class QuranRemoteDataSourceImpl implements QuranRemoteDataSource {
  QuranRemoteDataSourceImpl(
    this._dio,
    this._audioReciterSettings,
    this._metadataIndex,
  );

  final Dio _dio;
  final QuranAudioReciterSettings _audioReciterSettings;
  final QuranAyahMetadataIndex _metadataIndex;

  Map<int, int>? _surahAyahCounts;

  @override
  Future<List<SurahSummaryDto>> fetchSurahList() async {
    final response = await _dio.get<Map<String, dynamic>>('/quran/surahs');
    final parsed = _parseResponse(
      response.data,
      (data) => data as Map<String, dynamic>,
    );

    final surahsJson = parsed.data['surahs'] as List<dynamic>? ?? [];
    _surahAyahCounts = Map.fromEntries(
      surahsJson.cast<Map<String, dynamic>>().map(
        (item) => MapEntry(
          item['number'] as int,
          item['verses_count'] as int,
        ),
      ),
    );

    return surahsJson
        .map(
          (item) => _surahSummaryFromUmmah(item as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<({SurahDetailDto arabic, SurahDetailDto translation})>
  fetchSurahTextEditions({
    required int surahNumber,
    required String translationEdition,
  }) async {
    await _ensureSurahAyahCounts();
    await _metadataIndex.ensureLoaded();

    final response = await _dio.get<Map<String, dynamic>>(
      '/quran/surah/$surahNumber',
    );
    final parsed = _parseResponse(
      response.data,
      (data) => data as Map<String, dynamic>,
    );

    final surahMeta = parsed.data['surah'] as Map<String, dynamic>;
    final verses = parsed.data['verses'] as List<dynamic>;
    final surahSummary = _surahSummaryFieldsFromUmmah(surahMeta);

    final arabicAyahs = await _ayahsFromVerses(
      surahNumber: surahNumber,
      verses: verses,
      textSelector: (verse) => verse['arabic'] as String,
    );
    final translationKey = UmmahQuranMappings.translationKeyForEdition(
      translationEdition,
    );
    final translationAyahs = await _ayahsFromVerses(
      surahNumber: surahNumber,
      verses: verses,
      textSelector: (verse) {
        final translations =
            verse['translations'] as Map<String, dynamic>? ?? {};
        return translations[translationKey] as String? ?? '';
      },
    );

    return (
      arabic: SurahDetailDto(
        number: surahNumber,
        name: surahSummary.name,
        englishName: surahSummary.englishName,
        englishNameTranslation: surahSummary.englishNameTranslation,
        revelationType: surahSummary.revelationType,
        numberOfAyahs: surahSummary.numberOfAyahs,
        ayahs: arabicAyahs,
        editionIdentifier: QuranEditions.arabicText,
      ),
      translation: SurahDetailDto(
        number: surahNumber,
        name: surahSummary.name,
        englishName: surahSummary.englishName,
        englishNameTranslation: surahSummary.englishNameTranslation,
        revelationType: surahSummary.revelationType,
        numberOfAyahs: surahSummary.numberOfAyahs,
        ayahs: translationAyahs,
        editionIdentifier: translationEdition,
      ),
    );
  }

  @override
  Future<List<AyahDto>> fetchSurahAudioAyahs(int surahNumber) async {
    final reciterId = UmmahQuranMappings.reciterIdForEdition(
      _audioReciterSettings.editionIdentifier,
    );

    final response = await _dio.get<Map<String, dynamic>>(
      '/quran/surah/$surahNumber',
      queryParameters: {'reciter': reciterId},
    );
    final parsed = _parseResponse(
      response.data,
      (data) => data as Map<String, dynamic>,
    );

    final verses = parsed.data['verses'] as List<dynamic>;
    await _metadataIndex.ensureLoaded();

    return _ayahsFromVerses(
      surahNumber: surahNumber,
      verses: verses,
      textSelector: (verse) => verse['arabic'] as String,
      audioSelector: _ayahAudioFromVerse,
    );
  }

  @override
  Future<String?> fetchAyahAudioUrl({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final reciterId = UmmahQuranMappings.reciterIdForEdition(
      _audioReciterSettings.editionIdentifier,
    );

    final response = await _dio.get<Map<String, dynamic>>(
      '/quran/surah/$surahNumber/ayah/$ayahNumber',
      queryParameters: {'reciter': reciterId},
    );
    final parsed = _parseResponse(
      response.data,
      (data) => data as Map<String, dynamic>,
    );

    final audioList = parsed.data['audio'] as List<dynamic>? ?? [];
    final audioMaps = audioList.cast<Map<String, dynamic>>();
    final preferredReciter = audioMaps
        .where((audioJson) => audioJson['reciter_id'] == reciterId)
        .toList();
    if (preferredReciter.isNotEmpty) {
      return preferredReciter.first['ayah_audio'] as String?;
    }

    if (audioMaps.isEmpty) return null;
    return audioMaps.first['ayah_audio'] as String?;
  }

  @override
  Future<List<AudioEditionDto>> fetchAudioEditions() async {
    final response = await _dio.get<Map<String, dynamic>>('/quran/reciters');
    final parsed = _parseResponse(
      response.data,
      (data) => data as Map<String, dynamic>,
    );

    final reciters = parsed.data['reciters'] as List<dynamic>? ?? [];
    return reciters.map((item) {
      final reciter = item as Map<String, dynamic>;
      final reciterId = reciter['id'] as int;
      return AudioEditionDto(
        identifier: UmmahQuranMappings.editionForReciterId(reciterId),
        language: 'ar',
        name: reciter['name_arabic'] as String? ?? reciter['name'] as String,
        englishName: reciter['name'] as String,
      );
    }).toList();
  }

  @override
  Future<AyahInsight> fetchAyahInsight({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  }) async {
    if (languageCode == 'ar') {
      return _fetchArabicTafsirInsight(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
      );
    }

    return _fetchTranslationInsight(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      translationEdition: QuranEditions.insightTranslationForLocale(
        languageCode,
      ),
    );
  }

  Future<AyahInsight> _fetchArabicTafsirInsight({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/tafsir/muyassar/surah/$surahNumber/ayah/$ayahNumber',
    );
    final parsed = _parseResponse(
      response.data,
      (data) => data as Map<String, dynamic>,
    );

    final tafsir = parsed.data['tafsir'] as Map<String, dynamic>?;
    final text = tafsir?['text'] as String? ?? '';
    if (text.trim().isEmpty) {
      throw StateError(
        'Missing ayah meaning for $surahNumber:$ayahNumber',
      );
    }

    return AyahInsight(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      meaning: text.trim(),
    );
  }

  Future<AyahInsight> _fetchTranslationInsight({
    required int surahNumber,
    required int ayahNumber,
    required String translationEdition,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/quran/surah/$surahNumber/ayah/$ayahNumber',
    );
    final parsed = _parseResponse(
      response.data,
      (data) => data as Map<String, dynamic>,
    );

    final verse = parsed.data['verse'] as Map<String, dynamic>;
    final translationKey = UmmahQuranMappings.translationKeyForEdition(
      translationEdition,
    );
    final translations = verse['translations'] as Map<String, dynamic>? ?? {};
    final text = translations[translationKey] as String? ?? '';
    if (text.trim().isEmpty) {
      throw StateError(
        'Missing ayah meaning for $surahNumber:$ayahNumber',
      );
    }

    return AyahInsight(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      meaning: text.trim(),
    );
  }

  Future<void> _ensureSurahAyahCounts() async {
    if (_surahAyahCounts != null) return;
    await fetchSurahList();
  }

  UmmahApiResponse<T> _parseResponse<T>(
    Map<String, dynamic>? body,
    T Function(Object? json) fromJsonT,
  ) {
    if (body == null) {
      throw StateError('Empty response from UmmahAPI');
    }

    final parsed = UmmahApiResponse.fromJson(body, fromJsonT);
    ensureUmmahSuccess(parsed.success);
    return parsed;
  }

  SurahSummaryDto _surahSummaryFromUmmah(Map<String, dynamic> json) {
    final fields = _surahSummaryFieldsFromUmmah(json);
    return SurahSummaryDto(
      number: json['number'] as int,
      name: fields.name,
      englishName: fields.englishName,
      englishNameTranslation: fields.englishNameTranslation,
      numberOfAyahs: fields.numberOfAyahs,
      revelationType: fields.revelationType,
    );
  }

  ({
    String name,
    String englishName,
    String englishNameTranslation,
    int numberOfAyahs,
    String revelationType,
  })
  _surahSummaryFieldsFromUmmah(Map<String, dynamic> json) {
    return (
      name: json['name_arabic'] as String,
      englishName: json['name_english'] as String,
      englishNameTranslation: json['name_translation'] as String? ?? '',
      numberOfAyahs: json['verses_count'] as int,
      revelationType: UmmahQuranMappings.revelationTypeFromPlace(
        json['revelation_place'] as String? ?? '',
      ),
    );
  }

  Future<List<AyahDto>> _ayahsFromVerses({
    required int surahNumber,
    required List<dynamic> verses,
    required String Function(Map<String, dynamic> verse) textSelector,
    String? Function(Map<String, dynamic> verse)? audioSelector,
  }) async {
    final ayahs = <AyahDto>[];
    await verses.cast<Map<String, dynamic>>().fold(
      Future<void>.value(),
      (previous, verseJson) => previous.then((_) async {
        ayahs.add(
          await _ayahFromVerse(
            surahNumber: surahNumber,
            verse: verseJson,
            text: textSelector(verseJson),
            audio: audioSelector?.call(verseJson),
          ),
        );
      }),
    );
    return ayahs;
  }

  Future<AyahDto> _ayahFromVerse({
    required int surahNumber,
    required Map<String, dynamic> verse,
    required String text,
    String? audio,
  }) async {
    final ayahNumber = verse['ayah'] as int;
    final page = await _metadataIndex.pageFor(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );

    return AyahDto(
      number: _globalAyahNumber(surahNumber: surahNumber, ayahNumber: ayahNumber),
      text: text,
      numberInSurah: ayahNumber,
      page: page,
      juz: UmmahQuranMappings.juzForAyah(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
      ),
      hizbQuarter: 0,
      ruku: 0,
      sajda: false,
      audio: audio,
    );
  }

  String? _ayahAudioFromVerse(Map<String, dynamic> verse) {
    final audio = verse['audio'];
    if (audio is Map<String, dynamic>) {
      return audio['ayah_audio'] as String?;
    }
    return null;
  }

  int _globalAyahNumber({
    required int surahNumber,
    required int ayahNumber,
  }) {
    final counts = _surahAyahCounts;
    if (counts == null) {
      return ayahNumber;
    }

    final precedingAyahs = List.generate(
      surahNumber - 1,
      (index) => index + 1,
    ).fold<int>(0, (total, surah) => total + (counts[surah] ?? 0));
    return precedingAyahs + ayahNumber;
  }
}
