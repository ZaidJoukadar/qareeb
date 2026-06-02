import 'package:flutter/material.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qareeb/features/quran/presentation/utils/surah_playback_progress.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class QuranAudioPlayerBar extends StatelessWidget {
  const QuranAudioPlayerBar({
    required this.surahName,
    required this.currentAyah,
    required this.totalAyahs,
    required this.isLoading,
    required this.isPaused,
    required this.position,
    required this.duration,
    required this.onTogglePlayPause,
    required this.onStop,
    required this.onPreviousAyah,
    required this.onNextAyah,
    required this.onSelectReciter,
    this.showAyahNavigation = true,
    this.canGoToPreviousAyah = true,
    this.canGoToNextAyah = true,
    super.key,
  });

  final String surahName;
  final int currentAyah;
  final int totalAyahs;
  final bool isLoading;
  final bool isPaused;
  final Duration position;
  final Duration? duration;
  final bool canGoToPreviousAyah;
  final bool canGoToNextAyah;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onStop;
  final VoidCallback onPreviousAyah;
  final VoidCallback onNextAyah;
  final VoidCallback onSelectReciter;
  final bool showAyahNavigation;

  static const double _controlSize = 44;
  static const double _playControlSize = 52;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final progress = showAyahNavigation
        ? surahPlaybackProgress(
            currentAyah: currentAyah,
            totalAyahs: totalAyahs,
            position: position,
            currentAyahDuration: duration,
          )
        : _singleAyahProgress(position: position, duration: duration);

    return Material(
      elevation: 8,
      color: QuranReaderTheme.markerFillOf(context),
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 12, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: IconButton(
                        tooltip: l10n.stopAudio,
                        onPressed: onStop,
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 52),
                      child: _ReciterButton(
                        label: l10n.drawerSelectReciter,
                        onPressed: onSelectReciter,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 140),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              surahName,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              l10n.audioAyahProgress(currentAyah, totalAyahs),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color: QuranReaderTheme.translationTextOf(
                                  context,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showAyahNavigation) ...[
                    _CircularControlButton(
                      size: _controlSize,
                      tooltip: l10n.previousAyah,
                      onPressed: canGoToPreviousAyah && !isLoading
                          ? onPreviousAyah
                          : null,
                      icon: const Icon(Icons.skip_previous_rounded, size: 26),
                    ),
                    const SizedBox(width: 16),
                  ],
                  _CircularControlButton(
                    size: _playControlSize,
                    tooltip: isPaused ? l10n.playSurah : l10n.pauseAudio,
                    onPressed: isLoading ? null : onTogglePlayPause,
                    emphasized: true,
                    icon: isLoading
                        ? SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: QuranReaderTheme.headerBrownOf(context),
                            ),
                          )
                        : Icon(
                            isPaused
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                            size: 30,
                          ),
                  ),
                  if (showAyahNavigation) ...[
                    const SizedBox(width: 16),
                    _CircularControlButton(
                      size: _controlSize,
                      tooltip: l10n.nextAyah,
                      onPressed:
                          canGoToNextAyah && !isLoading ? onNextAyah : null,
                      icon: const Icon(Icons.skip_next_rounded, size: 26),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: QuranReaderTheme.ornamentBorderOf(context)
                    .withValues(alpha: 0.35),
                color: QuranReaderTheme.ornamentGoldOf(context),
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double _singleAyahProgress({
  required Duration position,
  Duration? duration,
}) {
  final total = duration;
  if (total == null || total.inMilliseconds <= 0) return 0;
  return (position.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
}

class _ReciterButton extends StatelessWidget {
  const _ReciterButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final gold = QuranReaderTheme.ornamentGoldOf(context);
    final border = QuranReaderTheme.ornamentBorderOf(context);

    return Material(
      color: QuranReaderTheme.headerBrownOf(context).withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: border.withValues(alpha: 0.85)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.record_voice_over_outlined, size: 20, color: gold),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: QuranReaderTheme.headerBrownOf(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, size: 22, color: gold),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularControlButton extends StatelessWidget {
  const _CircularControlButton({
    required this.size,
    required this.tooltip,
    required this.icon,
    this.onPressed,
    this.emphasized = false,
  });

  final double size;
  final String tooltip;
  final Widget icon;
  final VoidCallback? onPressed;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final borderColor = QuranReaderTheme.ornamentBorderOf(context);
    final fillColor = emphasized
        ? QuranReaderTheme.headerBrownOf(context).withValues(alpha: 0.14)
        : QuranReaderTheme.headerBrownOf(context).withValues(alpha: 0.08);
    final iconColor = enabled
        ? QuranReaderTheme.headerBrownOf(context)
        : QuranReaderTheme.translationTextOf(context).withValues(alpha: 0.45);

    return Tooltip(
      message: tooltip,
      child: Material(
        color: enabled ? fillColor : fillColor.withValues(alpha: 0.5),
        shape: CircleBorder(
          side: BorderSide(
            color: enabled
                ? borderColor
                : borderColor.withValues(alpha: 0.45),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: IconTheme(
              data: IconThemeData(color: iconColor),
              child: Center(child: icon),
            ),
          ),
        ),
      ),
    );
  }
}
