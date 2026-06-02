import 'package:qareeb/features/asma_ul_husna/domain/entities/allah_name.dart';
import 'package:qareeb/features/asma_ul_husna/domain/repositories/asma_ul_husna_repository.dart';

class GetAsmaUlHusna {
  const GetAsmaUlHusna(this._repository);

  final AsmaUlHusnaRepository _repository;

  Future<List<AllahName>> call() => _repository.getNames();
}
