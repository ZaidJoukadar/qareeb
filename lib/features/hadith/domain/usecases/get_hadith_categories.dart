import 'package:qareeb/features/hadith/domain/entities/hadith_category.dart';
import 'package:qareeb/features/hadith/domain/repositories/hadith_repository.dart';

class GetHadithCategories {
  const GetHadithCategories(this._repository);

  final HadithRepository _repository;

  List<HadithCategory> call() => _repository.getCategories();
}
