/// Optional metadata attached to a Sentry error report.
class SentryReport {
  const SentryReport({
    this.feature,
    this.action,
    this.extra,
    this.level,
  });

  /// Feature area, e.g. `onboarding`, `home`, `quran_reader`.
  final String? feature;

  /// What was running, e.g. `complete_onboarding`, `fetch_surah`.
  final String? action;

  /// Any extra key-value details (IDs, params — no secrets).
  final Map<String, Object?>? extra;

  final ReportLevel? level;
}

enum ReportLevel { debug, info, warning, error, fatal }
