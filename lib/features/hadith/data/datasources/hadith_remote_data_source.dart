import 'package:dio/dio.dart';
import 'package:qareeb/features/hadith/data/models/hadith_collection_dto.dart';
import 'package:qareeb/features/hadith/data/models/hadith_dto.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith_collection.dart';

abstract class HadithRemoteDataSource {
  Future<List<HadithCollection>> fetchCollections();

  Future<HadithPage> fetchPage({
    required String collectionId,
    required int page,
    int limit = 50,
  });

  Future<Hadith> fetchByNumber({
    required String collectionId,
    required int number,
  });

  Future<List<Hadith>> search({
    required String query,
    String? collectionId,
    int limit = 25,
  });
}

class HadithRemoteDataSourceImpl implements HadithRemoteDataSource {
  HadithRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  static const _defaultPageSize = 50;

  @override
  Future<List<HadithCollection>> fetchCollections() async {
    final response = await _dio.get<Map<String, dynamic>>('/hadith/collections');

    final body = response.data;
    if (body == null) {
      throw StateError('Empty response from UmmahAPI');
    }

    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw StateError('UmmahAPI hadith collections request failed');
    }

    final data = body['data'] as Map<String, dynamic>?;
    final collectionsJson = data?['collections'] as List<dynamic>?;
    if (collectionsJson == null) {
      throw StateError('UmmahAPI response missing collections');
    }

    return collectionsJson
        .map(
          (item) => HadithCollectionDto.fromJson(item as Map<String, dynamic>)
              .toEntity(),
        )
        .toList();
  }

  @override
  Future<HadithPage> fetchPage({
    required String collectionId,
    required int page,
    int limit = _defaultPageSize,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/hadith/$collectionId',
      queryParameters: {'page': page, 'limit': limit},
    );

    final body = response.data;
    if (body == null) {
      throw StateError('Empty response from UmmahAPI');
    }

    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw StateError('UmmahAPI hadith collection request failed');
    }

    final data = body['data'] as Map<String, dynamic>?;
    final hadithsJson = data?['hadiths'] as List<dynamic>?;
    if (hadithsJson == null) {
      throw StateError('UmmahAPI response missing hadiths');
    }

    return HadithPage(
      hadiths: HadithDto.entitiesFromJsonList(hadithsJson),
      page: data?['page'] as int? ?? page,
      totalPages: data?['total_pages'] as int? ?? page,
      total: data?['total'] as int? ?? hadithsJson.length,
    );
  }

  @override
  Future<Hadith> fetchByNumber({
    required String collectionId,
    required int number,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/hadith/$collectionId/$number',
    );

    final body = response.data;
    if (body == null) {
      throw StateError('Empty response from UmmahAPI');
    }

    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw StateError('UmmahAPI hadith request failed');
    }

    final data = body['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw StateError('UmmahAPI response missing hadith');
    }

    return HadithDto.fromJson(data).toEntity();
  }

  @override
  Future<List<Hadith>> search({
    required String query,
    String? collectionId,
    int limit = 25,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/hadith/search',
      queryParameters: {
        'q': query,
        'collection': ?collectionId,
        'limit': limit,
      },
    );

    final body = response.data;
    if (body == null) {
      throw StateError('Empty response from UmmahAPI');
    }

    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw StateError('UmmahAPI hadith search failed');
    }

    final data = body['data'] as Map<String, dynamic>?;
    final hadithsJson = data?['hadiths'] as List<dynamic>?;
    if (hadithsJson == null) {
      return const [];
    }

    return HadithDto.entitiesFromJsonList(hadithsJson);
  }
}
