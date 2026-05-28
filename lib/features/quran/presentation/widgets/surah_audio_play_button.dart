import 'package:flutter/material.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class SurahAudioPlayButton extends StatelessWidget {
  const SurahAudioPlayButton({
    required this.isPlaying,
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return IconButton(
      tooltip: isPlaying ? l10n.pauseAudio : l10n.playSurah,
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
              color: QuranReaderTheme.ornamentGoldOf(context),
            ),
    );
  }
}
