import 'package:qareeb/features/duaa/core/duaa_category_labels.dart';
import 'package:qareeb/features/duaa/data/datasources/duaa_local_data_source.dart';
import 'package:qareeb/features/duaa/data/datasources/duaa_remote_data_source.dart';
import 'package:qareeb/features/duaa/domain/entities/dua.dart';
import 'package:qareeb/features/duaa/domain/entities/dua_category.dart';
import 'package:qareeb/features/duaa/domain/repositories/duaa_repository.dart';

class DuaaRepositoryImpl implements DuaaRepository {
  DuaaRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final DuaaRemoteDataSource _remoteDataSource;
  final DuaaLocalDataSource _localDataSource;

  @override
  Future<List<DuaCategory>> getCategories() async {
    final categories = await _remoteDataSource.fetchCategories();

    return categories
        .map((category) {
          final label = DuaCategoryLabels.forId(category.id);
          if (label == null) {
            return category;
          }

          return DuaCategory(
            id: category.id,
            name: category.name,
            description: category.description,
            count: category.count,
            nameAr: label.nameAr,
            descriptionAr: label.descriptionAr,
          );
        })
        .toList();
  }

  @override
  Future<List<Dua>> getDuasByCategory(String categoryId) async {
    final duas = await _remoteDataSource.fetchDuasByCategory(categoryId);
    final arabicById = await _localDataSource.loadArabicById();

    return duas
        .map((dua) {
          final arabic = arabicById[dua.id];
          if (arabic == null) {
            return dua;
          }

          return Dua(
            id: dua.id,
            categoryId: dua.categoryId,
            title: dua.title,
            arabic: dua.arabic,
            transliteration: dua.transliteration,
            translation: dua.translation,
            source: dua.source,
            repeat: dua.repeat,
            titleAr: arabic.titleAr,
            translationAr: arabic.translationAr,
          );
        })
        .toList();
  }
}
