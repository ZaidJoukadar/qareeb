import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:qareeb/features/qibla/domain/utils/compass_heading.dart';

enum QiblaCompassAvailability {
  loading,
  live,
  pluginUnavailable,
  noSensor,
}

bool get isNativeCompassPlatform {
  if (kIsWeb) {
    return false;
  }

  return switch (defaultTargetPlatform) {
    TargetPlatform.android || TargetPlatform.iOS => true,
    _ => false,
  };
}

class QiblaCompassReader {
  QiblaCompassReader();

  final StreamController<QiblaCompassReading> _controller =
      StreamController<QiblaCompassReading>.broadcast();

  Stream<QiblaCompassReading> get readings => _controller.stream;

  StreamSubscription<CompassEvent>? _subscription;
  Timer? _startupTimer;
  QiblaCompassAvailability _availability = QiblaCompassAvailability.loading;
  double? _latitude;
  double? _longitude;

  QiblaCompassAvailability get availability => _availability;

  Future<void> start({
    required double latitude,
    required double longitude,
  }) async {
    _latitude = latitude;
    _longitude = longitude;
    if (_subscription != null) {
      return;
    }

    if (!isNativeCompassPlatform) {
      _setAvailability(QiblaCompassAvailability.pluginUnavailable);
      return;
    }

    final stream = FlutterCompass.events;
    if (stream == null) {
      _setAvailability(QiblaCompassAvailability.pluginUnavailable);
      return;
    }

    _startupTimer = Timer(const Duration(seconds: 2), () {
      if (_availability == QiblaCompassAvailability.loading) {
        _setAvailability(QiblaCompassAvailability.pluginUnavailable);
      }
    });

    try {
      _subscription = stream.listen(
        _onCompassEvent,
        onError: _onCompassError,
        cancelOnError: false,
      );
    } on MissingPluginException {
      _startupTimer?.cancel();
      _setAvailability(QiblaCompassAvailability.pluginUnavailable);
    }
  }

  void _onCompassEvent(CompassEvent event) {
    _startupTimer?.cancel();

    final rawHeading = event.heading;
    if (rawHeading == null) {
      _setAvailability(QiblaCompassAvailability.noSensor);
      return;
    }

    final latitude = _latitude;
    final longitude = _longitude;
    final heading = latitude != null && longitude != null
        ? trueNorthHeading(
            compassHeading: rawHeading,
            latitude: latitude,
            longitude: longitude,
          )
        : normalizeHeading(rawHeading);

    _availability = QiblaCompassAvailability.live;
    _controller.add(
      QiblaCompassReading(
        heading: heading,
        availability: QiblaCompassAvailability.live,
      ),
    );
  }

  void _onCompassError(Object error) {
    _startupTimer?.cancel();

    if (error is MissingPluginException) {
      _setAvailability(QiblaCompassAvailability.pluginUnavailable);
      return;
    }

    _setAvailability(QiblaCompassAvailability.noSensor);
  }

  void _setAvailability(QiblaCompassAvailability availability) {
    _availability = availability;
    if (!_controller.isClosed) {
      _controller.add(QiblaCompassReading(availability: availability));
    }
  }

  Future<void> dispose() async {
    _startupTimer?.cancel();
    await _subscription?.cancel();
    _subscription = null;
    await _controller.close();
  }
}

class QiblaCompassReading {
  const QiblaCompassReading({
    this.heading,
    this.availability = QiblaCompassAvailability.live,
  });

  final double? heading;
  final QiblaCompassAvailability availability;
}
