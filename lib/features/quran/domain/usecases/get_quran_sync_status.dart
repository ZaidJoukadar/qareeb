import 'package:qareeb/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';

class GetQuranSyncStatus {
  const GetQuranSyncStatus(this._repository);

  final QuranRepository _repository;

  Future<QuranSyncStatus> call() => _repository.getSyncStatus();
}
