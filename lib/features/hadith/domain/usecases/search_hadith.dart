import 'package:qareeb/features/hadith/domain/entities/hadith.dart';
import 'package:qareeb/features/hadith/domain/repositories/hadith_repository.dart';

class SearchHadith {
  const SearchHadith(this._repository);

  final HadithRepository _repository;

  Future<List<Hadith>> call({
    required String query,
    String? collectionId,
    int limit = 25,
  }) {
    return _repository.searchHadith(
      query: query,
      collectionId: collectionId,
      limit: limit,
    );
  }
}
