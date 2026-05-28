import 'package:flutter/material.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/quran/presentation/cubit/quran_sync_state.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class QuranSyncProgressPanel extends StatelessWidget {
  const QuranSyncProgressPanel({
    super.key,
    required this.state,
    required this.showRetry,
    this.onRetry,
  });

  final QuranSyncState state;
  final bool showRetry;
  final VoidCallback? onRetry;

  static const _progressBarHeight = 6.0;
  static const _progressTrackColor = Color(0xFFE8D9A8);
  static const _progressFillColor = AppColors.gold;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final percentLabel = l10n.quranSyncProgressPercent(state.progressPercent);

    return Semantics(
      label: percentLabel,
      value: '${state.progressPercent}%',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.quranSyncTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.quranSyncDescription,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),
          ClipRRect(
            borderRadius: BorderRadius.circular(_progressBarHeight / 2),
            child: LinearProgressIndicator(
              value: state.progress,
              minHeight: _progressBarHeight,
              backgroundColor: _progressTrackColor,
              valueColor: const AlwaysStoppedAnimation<Color>(
                _progressFillColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            percentLabel,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (showRetry) ...[
            const SizedBox(height: 24),
            if (state.errorMessage != null) ...[
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.error),
              ),
              const SizedBox(height: 16),
            ],
            FilledButton(
              onPressed: onRetry,
              child: Text(l10n.quranSyncRetry),
            ),
          ],
        ],
      ),
    );
  }
}
