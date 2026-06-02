import 'package:dio/dio.dart';
import 'package:qareeb/features/duaa/data/models/dua_category_dto.dart';
import 'package:qareeb/features/duaa/data/models/dua_dto.dart';
import 'package:qareeb/features/duaa/domain/entities/dua.dart';
import 'package:qareeb/features/duaa/domain/entities/dua_category.dart';

abstract class DuaaRemoteDataSource {
  Future<List<DuaCategory>> fetchCategories();
  Future<List<Dua>> fetchDuasByCategory(String categoryId);
}

class DuaaRemoteDataSourceImpl implements DuaaRemoteDataSource {
  DuaaRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<DuaCategory>> fetchCategories() async {
    final response = await _dio.get<Map<String, dynamic>>('/duas');

    final body = response.data;
    if (body == null) {
      throw StateError('Empty response from UmmahAPI');
    }

    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw StateError('UmmahAPI duas request failed');
    }

    final data = body['data'] as Map<String, dynamic>?;
    final categoriesJson = data?['categories'] as List<dynamic>?;
    if (categoriesJson == null) {
      throw StateError('UmmahAPI response missing categories');
    }

    return categoriesJson
        .map(
          (item) => DuaCategoryDto.fromJson(item as Map<String, dynamic>)
              .toEntity(),
        )
        .toList();
  }

  @override
  Future<List<Dua>> fetchDuasByCategory(String categoryId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/duas/category/$categoryId',
    );

    final body = response.data;
    if (body == null) {
      throw StateError('Empty response from UmmahAPI');
    }

    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw StateError('UmmahAPI duas category request failed');
    }

    final data = body['data'] as Map<String, dynamic>?;
    final duasJson = data?['duas'] as List<dynamic>?;
    if (duasJson == null) {
      throw StateError('UmmahAPI response missing duas');
    }

    return duasJson
        .map((item) => DuaDto.fromJson(item as Map<String, dynamic>).toEntity())
        .toList();
  }
}
