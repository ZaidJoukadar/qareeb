import 'package:qareeb/features/adhan/data/datasources/location_local_data_source.dart';
import 'package:qareeb/features/adhan/domain/entities/user_location.dart';

class SaveUserLocation {
  const SaveUserLocation(this._localDataSource);

  final LocationLocalDataSource _localDataSource;

  Future<void> call(UserLocation location) {
    return _localDataSource.saveLocation(location);
  }
}
