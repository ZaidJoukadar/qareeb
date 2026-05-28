import 'package:qareeb/features/asma_ul_husna/data/datasources/asma_ul_husna_local_data_source.dart';
import 'package:qareeb/features/asma_ul_husna/data/datasources/asma_ul_husna_remote_data_source.dart';
import 'package:qareeb/features/asma_ul_husna/domain/entities/allah_name.dart';
import 'package:qareeb/features/asma_ul_husna/domain/repositories/asma_ul_husna_repository.dart';

class AsmaUlHusnaRepositoryImpl implements AsmaUlHusnaRepository {
  AsmaUlHusnaRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final AsmaUlHusnaRemoteDataSource _remoteDataSource;
  final AsmaUlHusnaLocalDataSource _localDataSource;

  @override
  Future<List<AllahName>> getNames() async {
    final names = await _remoteDataSource.fetchNames();
    final arabicByNumber = await _localDataSource.loadArabicByNumber();

    return names
        .map((name) {
          final arabic = arabicByNumber[name.number];
          if (arabic == null) {
            return name;
          }

          return AllahName(
            number: name.number,
            arabic: name.arabic,
            transliteration: name.transliteration,
            english: name.english,
            meaning: name.meaning,
            translationAr: arabic.translationAr,
            meaningAr: arabic.meaningAr,
          );
        })
        .toList();
  }
}
