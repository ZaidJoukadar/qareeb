import 'package:qareeb/features/duaa/domain/entities/dua.dart';
import 'package:qareeb/features/duaa/domain/repositories/duaa_repository.dart';

class GetDuasByCategory {
  const GetDuasByCategory(this._repository);

  final DuaaRepository _repository;

  Future<List<Dua>> call(String categoryId) =>
      _repository.getDuasByCategory(categoryId);
}
