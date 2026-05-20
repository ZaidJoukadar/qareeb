import 'package:dio/dio.dart';
import 'package:qareeb/core/constants/quran_editions.dart';
import 'package:qareeb/features/quran/data/models/alquran_api_response.dart';
import 'package:qareeb/features/quran/data/models/ayah_dto.dart';
import 'package:qareeb/features/quran/data/models/surah_detail_dto.dart';
import 'package:qareeb/features/quran/data/models/surah_summary_dto.dart';

abstract class QuranRemoteDataSource {
  Future<List<SurahSummaryDto>> fetchSurahList();

  Future<({SurahDetailDto arabic, SurahDetailDto translation})>
  fetchSurahTextEditions({
    required int surahNumber,
    required String translationEdition,
  });

  Future<List<AyahDto>> fetchSurahAudioAyahs(int surahNumber);
}

class QuranRemoteDataSourceImpl implements QuranRemoteDataSource {
  QuranRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<SurahSummaryDto>> fetchSurahList() async {
    final response = await _dio.get<Map<String, dynamic>>('/surah');
    final parsed = AlQuranApiResponse.fromJson(
      response.data!,
      (data) => (data as List<dynamic>)
          .map((e) => SurahSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    _ensureSuccess(parsed.code);
    return parsed.data;
  }

  @override
  Future<({SurahDetailDto arabic, SurahDetailDto translation})>
  fetchSurahTextEditions({
    required int surahNumber,
    required String translationEdition,
  }) async {
    final editions = '${QuranEditions.arabicText},$translationEdition';
    final response = await _dio.get<Map<String, dynamic>>(
      '/surah/$surahNumber/editions/$editions',
    );
    final parsed = AlQuranApiResponse.fromJson(
      response.data!,
      (data) => (data as List<dynamic>)
          .map((e) => SurahDetailDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    _ensureSuccess(parsed.code);

    return _splitArabicAndTranslation(
      surahs: parsed.data,
      surahNumber: surahNumber,
    );
  }

  ({SurahDetailDto arabic, SurahDetailDto translation}) _splitArabicAndTranslation({
    required List<SurahDetailDto> surahs,
    required int surahNumber,
  }) {
    final arabic = _lastMatching(
      surahs,
      (surah) => surah.editionIdentifier == QuranEditions.arabicText,
    );
    final translation = _lastMatching(
      surahs,
      (surah) => surah.editionIdentifier != QuranEditions.arabicText,
    );

    if (arabic == null || translation == null) {
      throw StateError(
        'Expected Arabic and translation editions for surah $surahNumber',
      );
    }

    return (arabic: arabic, translation: translation);
  }

  SurahDetailDto? _lastMatching(
    List<SurahDetailDto> surahs,
    bool Function(SurahDetailDto) test,
  ) {
    final matches = surahs.where(test).toList();
    return matches.isEmpty ? null : matches.last;
  }

  @override
  Future<List<AyahDto>> fetchSurahAudioAyahs(int surahNumber) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/surah/$surahNumber/${QuranEditions.audioRecitation}',
    );
    final parsed = AlQuranApiResponse.fromJson(
      response.data!,
      (data) => SurahDetailDto.fromJson(data as Map<String, dynamic>),
    );
    _ensureSuccess(parsed.code);
    return parsed.data.ayahs;
  }

  void _ensureSuccess(int code) {
    if (code != 200) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        message: 'alquran.cloud returned code $code',
      );
    }
  }
}
