import 'package:dio/dio.dart';
import 'package:qareeb/features/asma_ul_husna/data/models/allah_name_dto.dart';
import 'package:qareeb/features/asma_ul_husna/domain/entities/allah_name.dart';

abstract class AsmaUlHusnaRemoteDataSource {
  Future<List<AllahName>> fetchNames();
}

class AsmaUlHusnaRemoteDataSourceImpl implements AsmaUlHusnaRemoteDataSource {
  AsmaUlHusnaRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<AllahName>> fetchNames() async {
    final response = await _dio.get<Map<String, dynamic>>('/asma-ul-husna');

    final body = response.data;
    if (body == null) {
      throw StateError('Empty response from UmmahAPI');
    }

    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw StateError('UmmahAPI asma-ul-husna request failed');
    }

    final data = body['data'] as Map<String, dynamic>?;
    final namesJson = data?['names'] as List<dynamic>?;
    if (namesJson == null) {
      throw StateError('UmmahAPI response missing names');
    }

    return namesJson
        .map(
          (item) => AllahNameDto.fromJson(item as Map<String, dynamic>)
              .toEntity(),
        )
        .toList();
  }
}
