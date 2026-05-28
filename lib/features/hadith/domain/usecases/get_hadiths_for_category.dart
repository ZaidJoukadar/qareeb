import 'package:qareeb/features/hadith/domain/entities/hadith.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith_category.dart';
import 'package:qareeb/features/hadith/domain/repositories/hadith_repository.dart';

class GetHadithsForCategory {
  const GetHadithsForCategory(this._repository);

  final HadithRepository _repository;

  Future<List<Hadith>> call(HadithCategory category, {int limit = 50}) {
    return _repository.getHadithsForCategory(category, limit: limit);
  }
}
