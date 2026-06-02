import 'package:equatable/equatable.dart';
import 'package:qareeb/features/adhan/domain/entities/user_location.dart';

class CitySearchResult extends Equatable {
  const CitySearchResult({
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  final String city;
  final String country;
  final double latitude;
  final double longitude;

  String get displayLabel => country.isEmpty ? city : '$city, $country';

  UserLocation toUserLocation() {
    return UserLocation(
      latitude: latitude,
      longitude: longitude,
      city: city,
      country: country,
    );
  }

  @override
  List<Object?> get props => [city, country, latitude, longitude];
}
