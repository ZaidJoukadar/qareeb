import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';

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

  QiblaCompassAvailability get availability => _availability;

  Future<void> start() async {
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

    final heading = event.heading;
    if (heading == null) {
      _setAvailability(QiblaCompassAvailability.noSensor);
      return;
    }

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
