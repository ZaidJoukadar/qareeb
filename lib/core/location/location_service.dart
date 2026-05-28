import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qareeb/features/adhan/data/datasources/location_local_data_source.dart';
import 'package:qareeb/features/adhan/domain/entities/city_search_result.dart';
import 'package:qareeb/features/adhan/domain/entities/user_location.dart';

class LocationPermissionDeniedException implements Exception {
  const LocationPermissionDeniedException();

  @override
  String toString() => 'Location permission denied';
}

class LocationServiceUnavailableException implements Exception {
  const LocationServiceUnavailableException();

  @override
  String toString() => 'Location services are disabled';
}

class LocationPluginUnavailableException implements Exception {
  const LocationPluginUnavailableException();

  @override
  String toString() => 'Location plugin unavailable';
}

class LocationTimeoutException implements Exception {
  const LocationTimeoutException();

  @override
  String toString() => 'Location request timed out';
}

class LocationService {
  LocationService(this._localDataSource);

  static const Duration _gpsTimeLimit = Duration(seconds: 12);
  static const Duration _geocodingTimeLimit = Duration(seconds: 8);

  final LocationLocalDataSource _localDataSource;

  Future<UserLocation> resolveCurrentLocation() async {
    try {
      return await _resolveViaGps();
    } on MissingPluginException {
      final cached = await _localDataSource.getSavedLocation();
      if (cached != null) {
        return cached;
      }
      throw const LocationPluginUnavailableException();
    }
  }

  Future<UserLocation> _resolveViaGps() async {
    final cached = await _localDataSource.getSavedLocation();

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (cached != null) {
        return cached;
      }
      throw const LocationServiceUnavailableException();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const LocationPermissionDeniedException();
    }

    final position = await _resolvePosition();
    if (position == null) {
      if (cached != null) {
        return cached;
      }
      throw const LocationTimeoutException();
    }

    final label = await _resolvePlaceLabel(
      latitude: position.latitude,
      longitude: position.longitude,
      fallback: cached,
    );

    final location = UserLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      city: label.city,
      country: label.country,
    );

    await _localDataSource.saveLocation(location);
    return location;
  }

  Future<Position?> _resolvePosition() async {
    final lastKnown = await Geolocator.getLastKnownPosition();
    if (lastKnown != null) {
      return lastKnown;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: _gpsTimeLimit,
        ),
      );
    } on TimeoutException {
      return null;
    }
  }

  Future<({String city, String country})> _resolvePlaceLabel({
    required double latitude,
    required double longitude,
    UserLocation? fallback,
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      ).timeout(_geocodingTimeLimit);

      final placemark = placemarks.isNotEmpty ? placemarks.first : null;
      if (placemark != null) {
        return (
          city: _resolveCity(placemark),
          country: placemark.country?.trim().isNotEmpty == true
              ? placemark.country!
              : fallback?.country ?? 'Unknown',
        );
      }
    } on TimeoutException {
      // Fall through to cached labels.
    } catch (_) {
      // Fall through to cached labels.
    }

    if (fallback != null) {
      return (city: fallback.city, country: fallback.country);
    }

    return (city: 'Unknown', country: 'Unknown');
  }

  String _resolveCity(Placemark placemark) {
    return placemark.locality?.trim().isNotEmpty == true
        ? placemark.locality!
        : placemark.subAdministrativeArea?.trim().isNotEmpty == true
        ? placemark.subAdministrativeArea!
        : placemark.administrativeArea?.trim().isNotEmpty == true
        ? placemark.administrativeArea!
        : 'Unknown';
  }

  Future<List<CitySearchResult>> searchCities(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      return const [];
    }

    try {
      final locations = await locationFromAddress(trimmed).timeout(
        _geocodingTimeLimit,
      );

      final state = await locations.take(10).fold<
        Future<({Set<String> seen, List<CitySearchResult> results})>
      >(
        Future.value((seen: <String>{}, results: <CitySearchResult>[])),
        (previousFuture, location) => previousFuture.then((state) async {
          final placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          ).timeout(_geocodingTimeLimit);

          if (placemarks.isEmpty) {
            return state;
          }

          final placemark = placemarks.first;
          final city = _resolveCity(placemark);
          final country = placemark.country?.trim() ?? '';
          if (city == 'Unknown' && country.isEmpty) {
            return state;
          }

          final key = '$city|$country';
          if (state.seen.contains(key)) {
            return state;
          }

          return (
            seen: {...state.seen, key},
            results: [
              ...state.results,
              CitySearchResult(
                city: city,
                country: country.isEmpty ? 'Unknown' : country,
                latitude: location.latitude,
                longitude: location.longitude,
              ),
            ],
          );
        }),
      );

      return state.results;
    } on TimeoutException {
      return const [];
    } catch (_) {
      return const [];
    }
  }
}
