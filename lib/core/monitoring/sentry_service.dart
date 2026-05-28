import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qareeb/core/config/environment.dart';
import 'package:qareeb/core/monitoring/app_feedback.dart';
import 'package:qareeb/core/monitoring/sentry_report.dart';
import 'package:qareeb/core/monitoring/sentry_scope_config.dart';
import 'package:sentry_flutter/sentry_flutter.dart' as sentry;

export 'package:qareeb/core/monitoring/sentry_report.dart'
    show SentryReport, ReportLevel;

abstract final class SentryService {
  static PackageInfo? _packageInfo;

  /// Wraps [child] with [SentryWidget] (when enabled) inside [BetterFeedback].
  static Widget wrapApp(Widget child) {
    if (!Environment.current.isSentryEnabled) {
      return AppFeedback.wrap(child);
    }
    return AppFeedback.wrap(sentry.SentryWidget(child: child));
  }

  static Future<void> init({
    required void Function() appRunner,
    required PackageInfo packageInfo,
  }) async {
    _packageInfo = packageInfo;
    final env = Environment.current;

    if (!env.isSentryEnabled) {
      if (kDebugMode) {
        debugPrint(
          'Sentry: disabled (no SENTRY_DSN). Pass --dart-define=SENTRY_DSN=... to enable.',
        );
      }
      appRunner();
      return;
    }

    await sentry.SentryFlutter.init(
      (options) {
        options.dsn = env.sentryDsn;
        options.environment = env.flavor.name;
        options.release =
            '${packageInfo.packageName}@${packageInfo.version}+${packageInfo.buildNumber}';
        options.debug = env.isDevelopment && kDebugMode;
        options.tracesSampleRate = env.isProduction ? 0.2 : 1.0;
        options.attachScreenshot = true;
        options.privacy.maskAllText = false;
        options.privacy.maskAllImages = false;
        options.attachStacktrace = true;
        options.enableAutoSessionTracking = true;
        options.maxBreadcrumbs = 100;
        options.sendDefaultPii = false;
        options.beforeSend = _beforeSend;
        options.beforeSendFeedback = _beforeSendFeedback;
      },
      appRunner: () async {
        await SentryScopeConfig.apply(packageInfo: packageInfo);
        appRunner();
      },
    );
  }

  /// Reports a handled or unhandled error with rich, searchable context.
  static Future<void> captureException(
    Object exception, {
    StackTrace? stackTrace,
    SentryReport? report,
    Map<String, String>? context,
  }) async {
    if (!Environment.current.isSentryEnabled) return;

    await sentry.Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) => _applyReportScope(scope, report, context),
    );
  }

  /// Records a non-fatal message (e.g. degraded API, retry exhausted).
  static Future<void> captureMessage(
    String message, {
    SentryReport? report,
    ReportLevel level = ReportLevel.info,
  }) async {
    if (!Environment.current.isSentryEnabled) return;

    await sentry.Sentry.captureMessage(
      message,
      level: _toSentryLevel(level),
      withScope: (scope) => _applyReportScope(scope, report, null),
    );
  }

  static void addBreadcrumb({
    required String message,
    String category = 'app',
    Map<String, Object?>? data,
    ReportLevel level = ReportLevel.info,
  }) {
    if (!Environment.current.isSentryEnabled) return;

    sentry.Sentry.addBreadcrumb(
      sentry.Breadcrumb(
        message: message,
        category: category,
        level: _toSentryLevel(level),
        data: data,
        timestamp: DateTime.now(),
      ),
    );
  }

  static Future<sentry.SentryEvent?> _beforeSend(
    sentry.SentryEvent event,
    sentry.Hint hint,
  ) async {
    if (event.type == 'feedback') return event;
    return _enrichEvent(event, hint);
  }

  static Future<sentry.SentryEvent?> _beforeSendFeedback(
    sentry.SentryEvent event,
    sentry.Hint hint,
  ) async {
    return _enrichEvent(event, hint);
  }

  static Future<sentry.SentryEvent?> _enrichEvent(
    sentry.SentryEvent event,
    sentry.Hint hint,
  ) async {
    final env = Environment.current;
    final packageInfo = _packageInfo;

    event.tags ??= {};
    event.tags!['app_flavor'] = env.flavor.name;
    if (packageInfo != null) {
      event.tags!['app_version'] = packageInfo.version;
      event.tags!['build_number'] = packageInfo.buildNumber;
    }

    final exception = event.throwable;
    if (exception != null) {
      final message = event.message?.formatted ?? exception.toString();
      event.fingerprint = [
        env.flavor.name,
        exception.runtimeType.toString(),
        message,
      ];
    }

    return event;
  }

  static void _applyReportScope(
    sentry.Scope scope,
    SentryReport? report,
    Map<String, String>? context,
  ) {
    if (report?.feature != null) {
      scope.setTag('feature', report!.feature!);
    }
    if (report?.action != null) {
      scope.setTag('action', report!.action!);
    }
    if (report?.level != null) {
      scope.level = _toSentryLevel(report!.level!);
    }

    final details = <String, Object?>{
      if (context != null) ...context,
      if (report?.extra != null) ...report!.extra!,
    };
    if (details.isNotEmpty) {
      scope.setContexts('error_details', details);
    }
  }

  static sentry.SentryLevel _toSentryLevel(ReportLevel level) {
    return switch (level) {
      ReportLevel.debug => sentry.SentryLevel.debug,
      ReportLevel.info => sentry.SentryLevel.info,
      ReportLevel.warning => sentry.SentryLevel.warning,
      ReportLevel.error => sentry.SentryLevel.error,
      ReportLevel.fatal => sentry.SentryLevel.fatal,
    };
  }
}
