import 'package:qareeb/features/hadith/domain/entities/hadith.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith_category.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith_collection.dart';

abstract class HadithRepository {
  List<HadithCategory> getCategories();

  Future<List<HadithCollection>> getCollections();

  Future<HadithPage> getHadithPage({
    required String collectionId,
    required int page,
    int limit,
  });

  Future<Hadith> getHadithByNumber({
    required String collectionId,
    required int number,
  });

  Future<List<Hadith>> searchHadith({
    required String query,
    String? collectionId,
    int limit,
  });

  Future<List<Hadith>> getHadithsForCategory(
    HadithCategory category, {
    int limit,
  });
}
