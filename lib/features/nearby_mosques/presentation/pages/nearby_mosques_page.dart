import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/location/location_service.dart';
import 'package:qareeb/features/adhan/domain/entities/user_location.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';
import 'package:qareeb/l10n/generated/app_localizations.dart';

class NearbyMosquesPage extends StatefulWidget {
  const NearbyMosquesPage({super.key});

  @override
  State<NearbyMosquesPage> createState() => _NearbyMosquesPageState();
}

class _NearbyMosquesPageState extends State<NearbyMosquesPage> {
  static const int _searchRadiusMeters = 6000;
  static const List<String> _overpassEndpoints = [
    'https://overpass-api.de/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
    'https://overpass.openstreetmap.ru/api/interpreter',
  ];
  static const String _requestUserAgent = 'Qareeb/1.0 (nearby-mosques)';
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  bool _isLoading = true;
  bool _isRouteLoading = false;
  String? _errorMessage;
  String? _routeErrorMessage;
  UserLocation? _userLocation;
  List<_NearbyMosque> _mosques = const [];
  _NearbyMosque? _selectedMosque;
  List<LatLng> _routePoints = const [];
  double? _routeDistanceMeters;
  double? _routeDurationSeconds;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    unawaited(_loadNearbyMosques());
  }

  Future<void> _loadNearbyMosques() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final location = await getIt<LocationService>().resolveCurrentLocation();
      final mosques = await _fetchNearbyMosques(location);
      if (!mounted) {
        return;
      }
      setState(() {
        _userLocation = location;
        _mosques = mosques;
        _selectedMosque = mosques.isNotEmpty ? mosques.first : null;
        _routePoints = const [];
        _routeDistanceMeters = null;
        _routeDurationSeconds = null;
        _routeErrorMessage = null;
        _isLoading = false;
      });
      if (mosques.isNotEmpty) {
        unawaited(_selectMosque(mosques.first));
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = context.l10n.nearbyMosquesError;
      });
    }
  }

  Future<List<_NearbyMosque>> _fetchNearbyMosques(UserLocation location) async {
    final query =
        '''
[out:json][timeout:25];
(
  node["amenity"="mosque"](around:$_searchRadiusMeters,${location.latitude},${location.longitude});
  way["amenity"="mosque"](around:$_searchRadiusMeters,${location.latitude},${location.longitude});
  relation["amenity"="mosque"](around:$_searchRadiusMeters,${location.latitude},${location.longitude});
  node["amenity"="place_of_worship"]["religion"="muslim"](around:$_searchRadiusMeters,${location.latitude},${location.longitude});
  way["amenity"="place_of_worship"]["religion"="muslim"](around:$_searchRadiusMeters,${location.latitude},${location.longitude});
  relation["amenity"="place_of_worship"]["religion"="muslim"](around:$_searchRadiusMeters,${location.latitude},${location.longitude});
);
out center;
''';

    try {
      final responseData = await _fetchOverpassJson(query);
      final elements =
          (responseData['elements'] as List<dynamic>? ?? const <dynamic>[]);
      return _buildMosqueListFromOverpass(elements, location);
    } catch (error) {
      debugPrint('Nearby mosques: Overpass failed, falling back: $error');
      final fallback = await _fetchViaNominatim(location);
      return fallback;
    }
  }

  Future<Map<String, dynamic>> _fetchOverpassJson(String query) async {
    Object? lastError;
    final requests = _overpassEndpoints.map((endpoint) async {
      try {
        final response = await _dio.post<String>(
          endpoint,
          data: 'data=${Uri.encodeQueryComponent(query)}',
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            responseType: ResponseType.plain,
            headers: {
              'Accept': 'application/json',
              'User-Agent': _requestUserAgent,
            },
            validateStatus: (status) =>
                status != null && status >= 200 && status < 300,
          ),
        );

        final body = response.data;
        if (body == null || body.isEmpty) {
          throw const FormatException('Empty Overpass response');
        }

        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        throw const FormatException('Unexpected Overpass response format');
      } catch (error) {
        lastError = error;
        debugPrint('Nearby mosques request failed on $endpoint: $error');
        return null;
      }
    });
    final responses = await Future.wait(requests);
    final success = responses.whereType<Map<String, dynamic>>().firstOrNull;
    if (success != null) {
      return success;
    }

    throw Exception('Failed to fetch nearby mosques: $lastError');
  }

  List<_NearbyMosque> _buildMosqueListFromOverpass(
    List<dynamic> elements,
    UserLocation location,
  ) {
    final byKey = elements
        .whereType<Map<String, dynamic>>()
        .map((element) {
          final tags =
              (element['tags'] as Map?)?.cast<String, dynamic>() ?? const {};
          final lat =
              (element['lat'] as num?)?.toDouble() ??
              ((element['center'] as Map?)?['lat'] as num?)?.toDouble();
          final lon =
              (element['lon'] as num?)?.toDouble() ??
              ((element['center'] as Map?)?['lon'] as num?)?.toDouble();
          if (lat == null || lon == null) {
            return null;
          }
          return _toMosqueItem(
            name: (tags['name'] as String?)?.trim(),
            latitude: lat,
            longitude: lon,
            userLocation: location,
          );
        })
        .whereType<_NearbyMosque>()
        .fold<Map<String, _NearbyMosque>>({}, (map, item) {
          map['${item.latitude},${item.longitude},${item.name}'] = item;
          return map;
        });

    final items = byKey.values.toList()
      ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    return items.take(40).toList(growable: false);
  }

  Future<List<_NearbyMosque>> _fetchViaNominatim(UserLocation location) async {
    final latitudeDelta = _searchRadiusMeters / 111320;
    final latitudeRadians = location.latitude * math.pi / 180;
    final longitudeDelta =
        _searchRadiusMeters /
        (111320 * math.cos(latitudeRadians).abs().clamp(0.1, 1.0));
    final left = (location.longitude - longitudeDelta).toStringAsFixed(6);
    final right = (location.longitude + longitudeDelta).toStringAsFixed(6);
    final top = (location.latitude + latitudeDelta).toStringAsFixed(6);
    final bottom = (location.latitude - latitudeDelta).toStringAsFixed(6);

    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': 'mosque',
      'format': 'jsonv2',
      'limit': '50',
      'bounded': '1',
      'viewbox': '$left,$top,$right,$bottom',
      'addressdetails': '1',
    });

    final response = await _dio.get<List<dynamic>>(
      uri.toString(),
      options: Options(
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
          'User-Agent': _requestUserAgent,
        },
        validateStatus: (status) =>
            status != null && status >= 200 && status < 300,
      ),
    );
    final rawList = response.data ?? const <dynamic>[];
    final byKey = rawList
        .whereType<Map<String, dynamic>>()
        .map((item) {
          final lat = double.tryParse('${item['lat'] ?? ''}');
          final lon = double.tryParse('${item['lon'] ?? ''}');
          if (lat == null || lon == null) {
            return null;
          }
          final displayName = (item['display_name'] as String?)?.trim();
          final name = (item['name'] as String?)?.trim();
          return _toMosqueItem(
            name: name ?? displayName,
            latitude: lat,
            longitude: lon,
            userLocation: location,
          );
        })
        .whereType<_NearbyMosque>()
        .fold<Map<String, _NearbyMosque>>({}, (map, mosque) {
          map['${mosque.latitude},${mosque.longitude},${mosque.name}'] = mosque;
          return map;
        });

    final items = byKey.values.toList()
      ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    return items.take(40).toList(growable: false);
  }

  _NearbyMosque _toMosqueItem({
    required String? name,
    required double latitude,
    required double longitude,
    required UserLocation userLocation,
  }) {
    final displayName = (name != null && name.isNotEmpty) ? name : 'Mosque';
    final distanceMeters = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      latitude,
      longitude,
    );
    return _NearbyMosque(
      name: displayName,
      latitude: latitude,
      longitude: longitude,
      distanceMeters: distanceMeters,
    );
  }

  Future<void> _selectMosque(_NearbyMosque mosque) async {
    final userLocation = _userLocation;
    if (userLocation == null) {
      return;
    }
    if (mounted) {
      setState(() {
        _selectedMosque = mosque;
        _isRouteLoading = true;
        _routeErrorMessage = null;
      });
    }

    try {
      final route = await _fetchRoute(
        userLat: userLocation.latitude,
        userLon: userLocation.longitude,
        mosqueLat: mosque.latitude,
        mosqueLon: mosque.longitude,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _routePoints = route.points;
        _routeDistanceMeters = route.distanceMeters;
        _routeDurationSeconds = route.durationSeconds;
        _isRouteLoading = false;
      });
      _moveMapToRoute(
        userLocation: userLocation,
        mosque: mosque,
        points: route.points,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _routePoints = [
          LatLng(userLocation.latitude, userLocation.longitude),
          LatLng(mosque.latitude, mosque.longitude),
        ];
        _routeDistanceMeters = mosque.distanceMeters;
        _routeDurationSeconds = null;
        _isRouteLoading = false;
        _routeErrorMessage = context.l10n.nearbyMosquesRouteFallbackHint;
      });
      _moveMapToRoute(
        userLocation: userLocation,
        mosque: mosque,
        points: _routePoints,
      );
    }
  }

  Future<_RouteResult> _fetchRoute({
    required double userLat,
    required double userLon,
    required double mosqueLat,
    required double mosqueLon,
  }) async {
    final uri = Uri.https(
      'router.project-osrm.org',
      '/route/v1/driving/$userLon,$userLat;$mosqueLon,$mosqueLat',
      {'overview': 'full', 'geometries': 'geojson'},
    );

    final response = await _dio.get<Map<String, dynamic>>(
      uri.toString(),
      options: Options(
        responseType: ResponseType.json,
        headers: const {
          'Accept': 'application/json',
          'User-Agent': _requestUserAgent,
        },
        validateStatus: (status) =>
            status != null && status >= 200 && status < 300,
      ),
    );

    final routes = response.data?['routes'] as List<dynamic>? ?? const [];
    if (routes.isEmpty || routes.first is! Map<String, dynamic>) {
      throw const FormatException('No route found');
    }
    final route = routes.first as Map<String, dynamic>;
    final geometry = route['geometry'] as Map<String, dynamic>?;
    final coordinates = geometry?['coordinates'] as List<dynamic>? ?? const [];
    final points = coordinates
        .whereType<List>()
        .where((coordinate) => coordinate.length >= 2)
        .map((coordinate) {
          final lon = (coordinate[0] as num?)?.toDouble();
          final lat = (coordinate[1] as num?)?.toDouble();
          if (lat == null || lon == null) {
            return null;
          }
          return LatLng(lat, lon);
        })
        .whereType<LatLng>()
        .toList(growable: false);
    if (points.length < 2) {
      throw const FormatException('Invalid route geometry');
    }
    return _RouteResult(
      points: points,
      distanceMeters: (route['distance'] as num?)?.toDouble() ?? 0,
      durationSeconds: (route['duration'] as num?)?.toDouble() ?? 0,
    );
  }

  void _moveMapToRoute({
    required UserLocation userLocation,
    required _NearbyMosque mosque,
    required List<LatLng> points,
  }) {
    final routeBounds = LatLngBounds.fromPoints(
      points.isNotEmpty
          ? points
          : [
              LatLng(userLocation.latitude, userLocation.longitude),
              LatLng(mosque.latitude, mosque.longitude),
            ],
    );
    _mapController.fitCamera(
      CameraFit.bounds(bounds: routeBounds, padding: const EdgeInsets.all(48)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nearbyMosquesTitle)),
      body: switch (_isLoading) {
        true => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text(l10n.nearbyMosquesLoading),
            ],
          ),
        ),
        false when _errorMessage != null => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _loadNearbyMosques,
                  child: Text(l10n.nearbyMosquesRetry),
                ),
              ],
            ),
          ),
        ),
        false when _userLocation == null => const SizedBox.shrink(),
        false => _NearbyMosquesContent(
          mapController: _mapController,
          userLocation: _userLocation!,
          mosques: _mosques,
          selectedMosque: _selectedMosque,
          routePoints: _routePoints,
          isRouteLoading: _isRouteLoading,
          routeErrorMessage: _routeErrorMessage,
          routeDistanceMeters: _routeDistanceMeters,
          routeDurationSeconds: _routeDurationSeconds,
          onMosqueTap: _selectMosque,
        ),
      },
    );
  }
}

class _NearbyMosquesContent extends StatelessWidget {
  const _NearbyMosquesContent({
    required this.mapController,
    required this.userLocation,
    required this.mosques,
    required this.selectedMosque,
    required this.routePoints,
    required this.isRouteLoading,
    required this.routeErrorMessage,
    required this.routeDistanceMeters,
    required this.routeDurationSeconds,
    required this.onMosqueTap,
  });

  final MapController mapController;
  final UserLocation userLocation;
  final List<_NearbyMosque> mosques;
  final _NearbyMosque? selectedMosque;
  final List<LatLng> routePoints;
  final bool isRouteLoading;
  final String? routeErrorMessage;
  final double? routeDistanceMeters;
  final double? routeDurationSeconds;
  final Future<void> Function(_NearbyMosque mosque) onMosqueTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final userPoint = LatLng(userLocation.latitude, userLocation.longitude);

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(initialCenter: userPoint, initialZoom: 13),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.qareeb.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: userPoint,
                    width: 44,
                    height: 44,
                    child: const Icon(
                      Icons.my_location_rounded,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  ...mosques
                      .take(30)
                      .map(
                        (mosque) => Marker(
                          point: LatLng(mosque.latitude, mosque.longitude),
                          width: 42,
                          height: 42,
                          child: Icon(
                            Icons.mosque_rounded,
                            color: selectedMosque == mosque
                                ? Colors.red
                                : Colors.green,
                            size: 28,
                          ),
                        ),
                      ),
                ],
              ),
              if (routePoints.length >= 2)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 5,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: mosques.isEmpty
              ? Center(child: Text(l10n.nearbyMosquesEmpty))
              : Column(
                  children: [
                    if (selectedMosque != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                        child: _RouteSummaryCard(
                          mosque: selectedMosque!,
                          isRouteLoading: isRouteLoading,
                          routeErrorMessage: routeErrorMessage,
                          routeDistanceMeters: routeDistanceMeters,
                          routeDurationSeconds: routeDurationSeconds,
                        ),
                      ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: mosques.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final mosque = mosques[index];
                          final isSelected = selectedMosque == mosque;
                          return ListTile(
                            leading: Icon(
                              Icons.mosque_rounded,
                              color: isSelected ? Colors.red : null,
                            ),
                            title: Text(
                              mosque.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(mosque.distanceLabel(l10n)),
                            trailing: isSelected
                                ? const Icon(Icons.alt_route_rounded)
                                : null,
                            onTap: () => onMosqueTap(mosque),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _RouteSummaryCard extends StatelessWidget {
  const _RouteSummaryCard({
    required this.mosque,
    required this.isRouteLoading,
    required this.routeErrorMessage,
    required this.routeDistanceMeters,
    required this.routeDurationSeconds,
  });

  final _NearbyMosque mosque;
  final bool isRouteLoading;
  final String? routeErrorMessage;
  final double? routeDistanceMeters;
  final double? routeDurationSeconds;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (isRouteLoading) {
      return const LinearProgressIndicator(minHeight: 3);
    }

    final distanceMeters = routeDistanceMeters ?? mosque.distanceMeters;
    final distanceText = distanceMeters < 1000
        ? l10n.nearbyMosquesDistanceMeters(distanceMeters.round())
        : l10n.nearbyMosquesDistanceKm(
            (distanceMeters / 1000).toStringAsFixed(1),
          );
    final durationText = routeDurationSeconds == null
        ? l10n.nearbyMosquesRouteDurationUnknown
        : l10n.nearbyMosquesRouteDurationMinutes(
            math.max(1, (routeDurationSeconds! / 60).round()),
          );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.nearbyMosquesRouteTo(mosque.name),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              '$distanceText • $durationText',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              routeErrorMessage ?? l10n.nearbyMosquesRouteHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _NearbyMosque {
  const _NearbyMosque({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
  });

  final String name;
  final double latitude;
  final double longitude;
  final double distanceMeters;

  String distanceLabel(AppLocalizations l10n) {
    if (distanceMeters < 1000) {
      return l10n.nearbyMosquesDistanceMeters(distanceMeters.round());
    }
    final km = (distanceMeters / 1000).toStringAsFixed(1);
    return l10n.nearbyMosquesDistanceKm(km);
  }
}

class _RouteResult {
  const _RouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;
}
