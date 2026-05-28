import 'package:qareeb/core/config/app_flavor.dart';

class Environment {
  Environment._({
    required this.flavor,
    required this.sentryDsn,
    required this.apiBaseUrl,
    required this.ummahApiBaseUrl,
    required this.tafsirApiBaseUrl,
    required this.privacyPolicyUrl,
    required this.termsOfServiceUrl,
    required this.supportUrl,
  });

  static late final Environment current;

  static void init() {
    final flavor = AppFlavor.fromName(
      const String.fromEnvironment('APP_ENV', defaultValue: 'dev'),
    );

    final defaults = _defaultsFor(flavor);

    current = Environment._(
      flavor: flavor,
      sentryDsn: const String.fromEnvironment('SENTRY_DSN').isNotEmpty
          ? const String.fromEnvironment('SENTRY_DSN')
          : defaults.sentryDsn,
      apiBaseUrl: _defineOrDefault('API_BASE_URL', defaults.apiBaseUrl),
      ummahApiBaseUrl: _defineOrDefault(
        'UMMAH_API_BASE_URL',
        defaults.ummahApiBaseUrl,
      ),
      tafsirApiBaseUrl: _defineOrDefault(
        'TAFSIR_API_BASE_URL',
        defaults.tafsirApiBaseUrl,
      ),
      privacyPolicyUrl: _defineOrDefault(
        'PRIVACY_POLICY_URL',
        defaults.privacyPolicyUrl,
      ),
      termsOfServiceUrl: _defineOrDefault(
        'TERMS_URL',
        defaults.termsOfServiceUrl,
      ),
      supportUrl: _defineOrDefault('SUPPORT_URL', defaults.supportUrl),
    );
  }

  final AppFlavor flavor;
  final String sentryDsn;
  final String apiBaseUrl;
  final String ummahApiBaseUrl;
  final String tafsirApiBaseUrl;
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  final String supportUrl;

  bool get isSentryEnabled => sentryDsn.isNotEmpty;
  bool get isDevelopment => flavor.isDev;
  bool get isProduction => flavor.isProduction;

  static String _defineOrDefault(String key, String fallback) {
    final value = String.fromEnvironment(key);
    return value.isNotEmpty ? value : fallback;
  }

  static _EnvironmentDefaults _defaultsFor(AppFlavor flavor) {
    return switch (flavor) {
      AppFlavor.dev => const _EnvironmentDefaults(
        sentryDsn: 'https://e64b56d1c6412ecd5a11c8431383b5b9@o4511421715775488.ingest.us.sentry.io/4511421733208064',
        apiBaseUrl: 'https://api.dev.qareeb.app',
        ummahApiBaseUrl: 'https://ummahapi.com/api',
        tafsirApiBaseUrl: 'https://api.dev.qareeb.app/tafsir',
        privacyPolicyUrl: 'https://dev.qareeb.app/privacy',
        termsOfServiceUrl: 'https://dev.qareeb.app/terms',
        supportUrl: 'https://dev.qareeb.app/support',
      ),
      AppFlavor.staging => const _EnvironmentDefaults(
        sentryDsn: 'https://e64b56d1c6412ecd5a11c8431383b5b9@o4511421715775488.ingest.us.sentry.io/4511421733208064',
        apiBaseUrl: 'https://api.staging.qareeb.app',
        ummahApiBaseUrl: 'https://ummahapi.com/api',
        tafsirApiBaseUrl: 'https://api.staging.qareeb.app/tafsir',
        privacyPolicyUrl: 'https://staging.qareeb.app/privacy',
        termsOfServiceUrl: 'https://staging.qareeb.app/terms',
        supportUrl: 'https://staging.qareeb.app/support',
      ),
      AppFlavor.production => const _EnvironmentDefaults(
        sentryDsn: 'https://e64b56d1c6412ecd5a11c8431383b5b9@o4511421715775488.ingest.us.sentry.io/4511421733208064',
        apiBaseUrl: 'https://api.qareeb.app',
        ummahApiBaseUrl: 'https://ummahapi.com/api',
        tafsirApiBaseUrl: 'https://api.qareeb.app/tafsir',
        privacyPolicyUrl: 'https://qareeb.app/privacy',
        termsOfServiceUrl: 'https://qareeb.app/terms',
        supportUrl: 'https://qareeb.app/support',
      ),
    };
  }
}

class _EnvironmentDefaults {
  const _EnvironmentDefaults({
    required this.sentryDsn,
    required this.apiBaseUrl,
    required this.ummahApiBaseUrl,
    required this.tafsirApiBaseUrl,
    required this.privacyPolicyUrl,
    required this.termsOfServiceUrl,
    required this.supportUrl,
  });

  final String sentryDsn;
  final String apiBaseUrl;
  final String ummahApiBaseUrl;
  final String tafsirApiBaseUrl;
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  final String supportUrl;
}
