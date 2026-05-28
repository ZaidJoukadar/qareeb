import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qareeb/core/config/environment.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// In-app bug report UI integrated with Sentry ([feedback_sentry]).
abstract final class AppFeedback {
  static Widget wrap(Widget child) {
    return BetterFeedback(
      themeMode: ThemeMode.system,
      theme: FeedbackThemeData(
        feedbackSheetColor: AppColors.cream,
        activeFeedbackModeColor: AppColors.gold,
        brightness: Brightness.light,
      ),
      darkTheme: FeedbackThemeData.dark().copyWith(
        activeFeedbackModeColor: AppColors.gold,
      ),
      child: child,
    );
  }

  /// Opens the feedback overlay and uploads the report to Sentry on submit.
  static void show(BuildContext context) {
    if (!Environment.current.isSentryEnabled) {
      return;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    final l10n = context.l10n;

    BetterFeedback.of(context).show((UserFeedback feedback) async {
      final message = feedback.text.trim();
      if (message.isEmpty) {
        messenger?.showSnackBar(
          SnackBar(content: Text(l10n.settingsReportBugEmptyMessage)),
        );
        return;
      }

      try {
        // Link feedback to an issue so it appears in Sentry Issues and User Feedback.
        final associatedEventId = await Sentry.captureMessage(
          'User bug report',
          level: SentryLevel.info,
          withScope: (scope) {
            scope.setContexts('user_bug_report', {
              'message': message,
              if (feedback.extra != null && feedback.extra!.isNotEmpty)
                ...feedback.extra!,
            });
          },
        );

        Hint? hint;
        if (feedback.screenshot.isNotEmpty) {
          hint = Hint.withScreenshot(
            SentryAttachment.fromUint8List(
              feedback.screenshot,
              'screenshot.png',
              contentType: 'image/png',
            ),
          );
        }

        await Sentry.captureFeedback(
          SentryFeedback(
            message: message,
            associatedEventId: associatedEventId,
          ),
          hint: hint,
          withScope: (scope) {
            if (feedback.extra != null && feedback.extra!.isNotEmpty) {
              scope.setContexts('user_feedback', feedback.extra!);
            }
          },
        );

        if (kDebugMode) {
          debugPrint(
            'Sentry: user feedback sent (eventId=$associatedEventId)',
          );
        }

        messenger?.showSnackBar(
          SnackBar(content: Text(l10n.settingsReportBugSuccess)),
        );
      } catch (error, stackTrace) {
        if (kDebugMode) {
          debugPrint('Sentry: failed to send user feedback: $error');
        }
        await Sentry.captureException(error, stackTrace: stackTrace);
        messenger?.showSnackBar(
          SnackBar(content: Text(l10n.settingsReportBugError)),
        );
      }
    });
  }
}
