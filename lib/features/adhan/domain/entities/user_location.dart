import 'package:equatable/equatable.dart';

class UserLocation extends Equatable {
  const UserLocation({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
  });

  final double latitude;
  final double longitude;
  final String city;
  final String country;

  String get displayLabel => '$city, $country';

  @override
  List<Object?> get props => [latitude, longitude, city, country];
}
