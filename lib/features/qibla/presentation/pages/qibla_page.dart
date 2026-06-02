import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/location/location_service.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/adhan/domain/entities/user_location.dart';
import 'package:qareeb/features/qibla/presentation/services/qibla_compass_reader.dart';
import 'package:qareeb/features/qibla/presentation/utils/localized_compass_direction.dart';
import 'package:qareeb/features/qibla/presentation/widgets/qibla_compass.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';
import 'package:qibla/qibla.dart' as qibla;

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  UserLocation? _location;
  Object? _locationError;
  bool _loadingLocation = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadLocation());
  }

  Future<void> _loadLocation() async {
    setState(() {
      _loadingLocation = true;
      _locationError = null;
    });

    try {
      final location = await getIt<LocationService>().resolveCurrentLocation();
      if (!mounted) {
        return;
      }
      setState(() {
        _location = location;
        _loadingLocation = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _locationError = error;
        _loadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.qiblaTitle),
      ),
      body: switch (_loadingLocation) {
        true => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.gold),
              const SizedBox(height: 16),
              Text(
                l10n.qiblaLoading,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        ),
        false when _locationError != null => _QiblaLocationErrorView(
          error: _locationError!,
          onRetry: _loadLocation,
        ),
        false when _location == null => _QiblaLocationErrorView(
          error: const LocationServiceUnavailableException(),
          onRetry: _loadLocation,
        ),
        false => _QiblaCompassView(location: _location!),
      },
    );
  }
}

class _QiblaCompassView extends StatefulWidget {
  const _QiblaCompassView({required this.location});

  final UserLocation location;

  @override
  State<_QiblaCompassView> createState() => _QiblaCompassViewState();
}

class _QiblaCompassViewState extends State<_QiblaCompassView> {
  final QiblaCompassReader _compassReader = QiblaCompassReader();
  QiblaCompassAvailability _availability = QiblaCompassAvailability.loading;
  double? _heading;
  StreamSubscription<QiblaCompassReading>? _readingsSubscription;

  @override
  void initState() {
    super.initState();
    unawaited(_startCompass());
  }

  Future<void> _startCompass() async {
    await _compassReader.start(
      latitude: widget.location.latitude,
      longitude: widget.location.longitude,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _availability = _compassReader.availability;
    });

    await _readingsSubscription?.cancel();
    _readingsSubscription = _compassReader.readings.listen((reading) {
      if (!mounted) {
        return;
      }
      setState(() {
        _availability = reading.availability;
        _heading = reading.heading ?? _heading;
      });
    });
  }

  @override
  void dispose() {
    unawaited(_readingsSubscription?.cancel());
    unawaited(_compassReader.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (_availability == QiblaCompassAvailability.loading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.gold),
            const SizedBox(height: 16),
            Text(
              l10n.qiblaLoading,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.navy,
              ),
            ),
          ],
        ),
      );
    }

    final qiblaBearing = qibla.qiblaAngle(
      widget.location.latitude,
      widget.location.longitude,
    );
    final distanceKm = qibla.distanceKm(
      widget.location.latitude,
      widget.location.longitude,
      qibla.kaabaLat,
      qibla.kaabaLng,
    );

    final liveHeading = _heading;
    final isLive = _availability == QiblaCompassAvailability.live &&
        liveHeading != null;
    final heading = isLive ? liveHeading : 0.0;
    final offset = isLive ? _offsetFromQibla(liveHeading, qiblaBearing) : null;
    final isAligned = offset != null && offset.abs() <= 5;

    final statusMessage = switch (_availability) {
      QiblaCompassAvailability.live when isAligned => l10n.qiblaAligned,
      QiblaCompassAvailability.live when offset != null =>
        l10n.qiblaOffset(offset.abs().toStringAsFixed(1)),
      QiblaCompassAvailability.pluginUnavailable =>
        l10n.qiblaCompassPluginUnavailable,
      QiblaCompassAvailability.noSensor => l10n.qiblaNoCompass,
      _ => l10n.qiblaStaticDirectionHint,
    };

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      children: [
        Text(
          l10n.qiblaDescription,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.location.displayLabel,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.navy.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: QiblaCompass(
            heading: heading,
            qiblaBearing: qiblaBearing,
            isAligned: isAligned,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          statusMessage,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isAligned ? AppColors.gold : AppColors.navy,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.qiblaDirection(localizedCompassDirection(l10n, qiblaBearing)),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.qiblaBearing(qiblaBearing.toStringAsFixed(1)),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.navy.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.qiblaDistance(_formatDistanceKm(distanceKm)),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.navy.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          isLive ? l10n.qiblaHint : l10n.qiblaStaticDirectionHint,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.navy.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  static double _offsetFromQibla(double heading, double qiblaBearing) {
    var offset = qiblaBearing - heading;
    offset = (offset + 540) % 360 - 180;
    return offset;
  }

  static String _formatDistanceKm(double distanceKm) {
    if (distanceKm >= 100) {
      return distanceKm.round().toString();
    }
    if (distanceKm >= 10) {
      return distanceKm.toStringAsFixed(0);
    }
    return distanceKm.toStringAsFixed(1);
  }
}

class _QiblaLocationErrorView extends StatelessWidget {
  const _QiblaLocationErrorView({
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final message = switch (error) {
      LocationPermissionDeniedException() => l10n.adhanLocationDenied,
      LocationServiceUnavailableException() => l10n.adhanLocationUnavailable,
      LocationPluginUnavailableException() =>
        l10n.adhanLocationPluginUnavailable,
      LocationTimeoutException() => l10n.adhanLocationTimeout,
      _ => l10n.qiblaError,
    };

    final showOpenSettings = error is LocationPermissionDeniedException;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 48,
              color: AppColors.navy.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 24),
            if (showOpenSettings)
              OutlinedButton(
                onPressed: Geolocator.openAppSettings,
                child: Text(l10n.adhanOpenSettings),
              ),
            if (showOpenSettings) const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(l10n.adhanRetry),
            ),
          ],
        ),
      ),
    );
  }
}
