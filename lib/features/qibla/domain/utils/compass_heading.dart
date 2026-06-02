import 'package:flutter/foundation.dart';
import 'package:geomag/geomag.dart';

/// Normalizes [degrees] to the range [0, 360).
double normalizeHeading(double degrees) {
  return (degrees % 360 + 360) % 360;
}

/// Converts a magnetic compass heading to true north using the World Magnetic Model.
double magneticHeadingToTrueNorth({
  required double magneticHeading,
  required double latitude,
  required double longitude,
}) {
  final declination = GeoMag().calculate(latitude, longitude).dec;
  return normalizeHeading(magneticHeading + declination);
}

/// Whether the platform compass reports magnetic north and needs declination correction.
bool get compassReportsMagneticNorth {
  if (kIsWeb) {
    return false;
  }

  return switch (defaultTargetPlatform) {
    TargetPlatform.android => true,
    _ => false,
  };
}

/// Returns a true-north heading suitable for comparing with [qibla] bearings.
double trueNorthHeading({
  required double compassHeading,
  required double latitude,
  required double longitude,
}) {
  if (!compassReportsMagneticNorth) {
    return normalizeHeading(compassHeading);
  }

  return magneticHeadingToTrueNorth(
    magneticHeading: compassHeading,
    latitude: latitude,
    longitude: longitude,
  );
}
