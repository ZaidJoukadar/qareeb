import 'package:qareeb/l10n/generated/app_localizations.dart';
import 'package:qibla/qibla.dart' as qibla;

String localizedCompassDirection(AppLocalizations l10n, double bearing) {
  return switch (qibla.compassDir(bearing)) {
    'N' => l10n.compassNorth,
    'NE' => l10n.compassNortheast,
    'E' => l10n.compassEast,
    'SE' => l10n.compassSoutheast,
    'S' => l10n.compassSouth,
    'SW' => l10n.compassSouthwest,
    'W' => l10n.compassWest,
    'NW' => l10n.compassNorthwest,
    _ => qibla.compassName(bearing),
  };
}
