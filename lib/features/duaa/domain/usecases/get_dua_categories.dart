import 'package:qareeb/features/duaa/domain/entities/dua_category.dart';
import 'package:qareeb/features/duaa/domain/repositories/duaa_repository.dart';

class GetDuaCategories {
  const GetDuaCategories(this._repository);

  final DuaaRepository _repository;

  Future<List<DuaCategory>> call() => _repository.getCategories();
}
