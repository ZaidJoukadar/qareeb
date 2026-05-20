import 'package:flutter/material.dart';
import 'package:qareeb/core/monitoring/sentry_scope_config.dart';
import 'package:qareeb/core/monitoring/sentry_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Tracks navigation for Sentry breadcrumbs and the `current_route` tag.
final class SentryNavigationObserver extends SentryNavigatorObserver {
  SentryNavigationObserver() : super(enableAutoTransactions: true);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _onRouteChanged(route, 'push');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _onRouteChanged(previousRoute, 'pop');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _onRouteChanged(newRoute, 'replace');
  }

  void _onRouteChanged(Route<dynamic>? route, String action) {
    final name = route?.settings.name ?? route?.runtimeType.toString() ?? 'unknown';

    SentryScopeConfig.setCurrentRoute(name);
    SentryService.addBreadcrumb(
      message: 'Navigation $action: $name',
      category: 'navigation',
      data: {'route': name, 'action': action},
    );
  }
}
