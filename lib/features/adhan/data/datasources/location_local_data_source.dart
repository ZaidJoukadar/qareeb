import 'package:qareeb/core/constants/storage_keys.dart';
import 'package:qareeb/features/adhan/domain/entities/user_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocationLocalDataSource {
  Future<UserLocation?> getSavedLocation();

  Future<void> saveLocation(UserLocation location);
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  LocationLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<UserLocation?> getSavedLocation() async {
    final latitude = _prefs.getDouble(StorageKeys.adhanLatitude);
    final longitude = _prefs.getDouble(StorageKeys.adhanLongitude);
    final city = _prefs.getString(StorageKeys.adhanCity);
    final country = _prefs.getString(StorageKeys.adhanCountry);

    if (latitude == null ||
        longitude == null ||
        city == null ||
        country == null) {
      return null;
    }

    return UserLocation(
      latitude: latitude,
      longitude: longitude,
      city: city,
      country: country,
    );
  }

  @override
  Future<void> saveLocation(UserLocation location) async {
    await _prefs.setDouble(StorageKeys.adhanLatitude, location.latitude);
    await _prefs.setDouble(StorageKeys.adhanLongitude, location.longitude);
    await _prefs.setString(StorageKeys.adhanCity, location.city);
    await _prefs.setString(StorageKeys.adhanCountry, location.country);
  }
}
