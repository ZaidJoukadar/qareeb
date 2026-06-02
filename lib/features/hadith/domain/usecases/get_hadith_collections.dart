import 'package:qareeb/features/hadith/domain/entities/hadith_collection.dart';
import 'package:qareeb/features/hadith/domain/repositories/hadith_repository.dart';

class GetHadithCollections {
  const GetHadithCollections(this._repository);

  final HadithRepository _repository;

  Future<List<HadithCollection>> call() => _repository.getCollections();
}
