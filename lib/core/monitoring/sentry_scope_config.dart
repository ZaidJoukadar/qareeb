import 'package:package_info_plus/package_info_plus.dart';
import 'package:qareeb/core/config/environment.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract final class SentryScopeConfig {
  static Future<void> apply({
    required PackageInfo packageInfo,
  }) async {
    final env = Environment.current;

    await Sentry.configureScope((scope) {
      scope
        ..setTag('app_flavor', env.flavor.name)
        ..setTag('app_name', packageInfo.appName)
        // "app" is reserved by Sentry for device/app metadata — use app_info.
        ..setContexts('app_info', {
          'name': packageInfo.appName,
          'version': packageInfo.version,
          'build_number': packageInfo.buildNumber,
          'package_name': packageInfo.packageName,
          'flavor': env.flavor.name,
        })
        ..setContexts('environment_config', {
          'api_base_url': env.apiBaseUrl,
          'quran_api_base_url': env.quranApiBaseUrl,
          'sentry_enabled': env.isSentryEnabled,
        });
    });
  }

  static Future<void> setLocaleTag(String languageCode) async {
    await Sentry.configureScope((scope) {
      scope.setTag('locale', languageCode);
    });
  }

  static Future<void> setCurrentRoute(String? routeName) async {
    await Sentry.configureScope((scope) {
      if (routeName == null || routeName.isEmpty) {
        scope.removeTag('current_route');
      } else {
        scope.setTag('current_route', routeName);
      }
    });
  }
}
