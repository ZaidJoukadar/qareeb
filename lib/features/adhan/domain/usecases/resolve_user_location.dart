import 'package:qareeb/core/location/location_service.dart';
import 'package:qareeb/features/adhan/data/datasources/location_local_data_source.dart';
import 'package:qareeb/features/adhan/domain/entities/user_location.dart';

class ResolveUserLocation {
  const ResolveUserLocation(this._locationService, this._localDataSource);

  final LocationService _locationService;
  final LocationLocalDataSource _localDataSource;

  Future<UserLocation> call({bool useDeviceLocation = false}) async {
    if (!useDeviceLocation) {
      final saved = await _localDataSource.getSavedLocation();
      if (saved != null) {
        return saved;
      }
    }

    return _locationService.resolveCurrentLocation();
  }
}
