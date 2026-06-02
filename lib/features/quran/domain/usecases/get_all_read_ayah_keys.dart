import 'package:qareeb/features/quran/domain/repositories/reading_progress_repository.dart';

class GetAllReadAyahKeys {
  const GetAllReadAyahKeys(this._repository);

  final ReadingProgressRepository _repository;

  Future<Set<String>> call() => _repository.getAllReadAyahKeys();
}
