import 'package:qareeb/features/hadith/domain/entities/hadith.dart';
import 'package:qareeb/features/hadith/domain/repositories/hadith_repository.dart';

class GetHadithPage {
  const GetHadithPage(this._repository);

  final HadithRepository _repository;

  Future<HadithPage> call({
    required String collectionId,
    required int page,
    int limit = 50,
  }) {
    return _repository.getHadithPage(
      collectionId: collectionId,
      page: page,
      limit: limit,
    );
  }
}
