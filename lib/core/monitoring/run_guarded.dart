import 'package:qareeb/core/monitoring/sentry_service.dart';

/// Runs [action] and reports unexpected errors to Sentry with [report] context.
///
/// - Rethrows after reporting so callers can still show UI errors.
/// - Use in repositories / use cases where you catch errors intentionally.
Future<T> runGuarded<T>(
  Future<T> Function() action, {
  SentryReport? report,
}) async {
  try {
    return await action();
  } catch (error, stackTrace) {
    await SentryService.captureException(
      error,
      stackTrace: stackTrace,
      report: report,
    );
    rethrow;
  }
}

/// Sync variant for non-async code paths.
T runGuardedSync<T>(
  T Function() action, {
  SentryReport? report,
}) {
  try {
    return action();
  } catch (error, stackTrace) {
    SentryService.captureException(
      error,
      stackTrace: stackTrace,
      report: report,
    );
    rethrow;
  }
}
