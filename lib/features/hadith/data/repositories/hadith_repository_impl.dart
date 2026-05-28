import 'package:qareeb/features/hadith/core/hadith_categories_catalog.dart';
import 'package:qareeb/features/hadith/core/hadith_collections_catalog.dart';
import 'package:qareeb/features/hadith/data/datasources/hadith_remote_data_source.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith_category.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith_collection.dart';
import 'package:qareeb/features/hadith/domain/repositories/hadith_repository.dart';

class HadithRepositoryImpl implements HadithRepository {
  HadithRepositoryImpl(this._remoteDataSource);

  final HadithRemoteDataSource _remoteDataSource;

  @override
  List<HadithCategory> getCategories() => HadithCategoriesCatalog.topics;

  @override
  Future<List<HadithCollection>> getCollections() async {
    try {
      return await _remoteDataSource.fetchCollections();
    } catch (_) {
      return HadithCollectionsCatalog.all;
    }
  }

  @override
  Future<HadithPage> getHadithPage({
    required String collectionId,
    required int page,
    int limit = 50,
  }) {
    return _remoteDataSource.fetchPage(
      collectionId: collectionId,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<Hadith> getHadithByNumber({
    required String collectionId,
    required int number,
  }) {
    return _remoteDataSource.fetchByNumber(
      collectionId: collectionId,
      number: number,
    );
  }

  @override
  Future<List<Hadith>> searchHadith({
    required String query,
    String? collectionId,
    int limit = 25,
  }) {
    return _remoteDataSource.search(
      query: query,
      collectionId: collectionId,
      limit: limit,
    );
  }

  @override
  Future<List<Hadith>> getHadithsForCategory(
    HadithCategory category, {
    int limit = 50,
  }) async {
    final query = category.searchQuery;
    if (query == null || query.isEmpty) {
      return const [];
    }

    var results = await searchHadith(
      query: query,
      collectionId: category.collectionId,
      limit: limit,
    );

    if (category.sahihOnly) {
      results = results
          .where(
            (hadith) =>
                hadith.grade?.toLowerCase().contains('sahih') ?? false,
          )
          .toList();
    }

    return results;
  }
}
