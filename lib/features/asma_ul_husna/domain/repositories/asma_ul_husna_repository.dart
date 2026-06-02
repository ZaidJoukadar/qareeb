import 'package:qareeb/features/asma_ul_husna/domain/entities/allah_name.dart';

abstract class AsmaUlHusnaRepository {
  Future<List<AllahName>> getNames();
}
