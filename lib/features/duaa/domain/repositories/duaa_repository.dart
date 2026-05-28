import 'package:qareeb/features/duaa/domain/entities/dua.dart';
import 'package:qareeb/features/duaa/domain/entities/dua_category.dart';

abstract class DuaaRepository {
  Future<List<DuaCategory>> getCategories();
  Future<List<Dua>> getDuasByCategory(String categoryId);
}
