import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/bottom_sheets/app_bar_modal_bottom_sheet.dart';
import 'package:qareeb/features/quran/domain/entities/ayah_insight.dart';
import 'package:qareeb/features/quran/domain/entities/ayah_story.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayah_insight.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayah_story.dart';
import 'package:qareeb/features/quran/presentation/cubit/mushaf_book_reader_cubit.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

Future<void> showAyahInsightDialog({
  required BuildContext context,
  required Surah surah,
  required int ayahNumber,
  MushafBookReaderCubit? audioCubit,
}) {
  final languageCode = Localizations.localeOf(context).languageCode;
  final l10n = context.l10n;
  final isArabic = languageCode == 'ar';
  final parentContext = context;

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      Widget dialog = Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: FutureBuilder<AyahInsight>(
          future: getIt<GetAyahInsight>()(
            surahNumber: surah.number,
            ayahNumber: ayahNumber,
            languageCode: languageCode,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.ayahInsightError),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text(l10n.dismiss),
                    ),
                  ],
                ),
              );
            }

            final insight = snapshot.data!;
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.75,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 8, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            isArabic
                                ? '${surah.nameArabic} · ${l10n.ayahInsightAyahLabel(ayahNumber)}'
                                : '${surah.nameEnglish} · ${l10n.ayahInsightAyahLabel(ayahNumber)}',
                            textDirection:
                                isArabic ? TextDirection.rtl : TextDirection.ltr,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: QuranReaderTheme.ornamentGoldOf(context),
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        if (audioCubit != null)
                          _DialogPlayButton(
                            audioCubit: audioCubit,
                            surahNumber: surah.number,
                            ayahNumber: ayahNumber,
                          ),
                        IconButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SectionTitle(title: l10n.ayahInsightMeaning),
                          const SizedBox(height: 8),
                          Text(
                            insight.meaning,
                            textDirection:
                                isArabic ? TextDirection.rtl : TextDirection.ltr,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            _showStoryBottomSheet(
                              context: parentContext,
                              surah: surah,
                              ayahNumber: ayahNumber,
                              languageCode: languageCode,
                              isArabic: isArabic,
                            );
                          },
                          child: Text(l10n.ayahInsightStory),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      if (audioCubit != null) {
        dialog = BlocProvider.value(
          value: audioCubit,
          child: dialog,
        );
      }

      return dialog;
    },
  );
}

Future<void> _showStoryBottomSheet({
  required BuildContext context,
  required Surah surah,
  required int ayahNumber,
  required String languageCode,
  required bool isArabic,
}) {
  return showAppBarModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) {
      return AppBarModalScrollBody(
        child: _AyahStoryBottomSheet(
          surah: surah,
          ayahNumber: ayahNumber,
          languageCode: languageCode,
          isArabic: isArabic,
        ),
      );
    },
  );
}

class _AyahStoryBottomSheet extends StatefulWidget {
  const _AyahStoryBottomSheet({
    required this.surah,
    required this.ayahNumber,
    required this.languageCode,
    required this.isArabic,
  });

  final Surah surah;
  final int ayahNumber;
  final String languageCode;
  final bool isArabic;

  @override
  State<_AyahStoryBottomSheet> createState() => _AyahStoryBottomSheetState();
}

class _AyahStoryBottomSheetState extends State<_AyahStoryBottomSheet> {
  late Future<AyahStory> _storyFuture;

  @override
  void initState() {
    super.initState();
    _storyFuture = _loadStory();
  }

  Future<AyahStory> _loadStory() {
    return getIt<GetAyahStory>()(
      surahNumber: widget.surah.number,
      ayahNumber: widget.ayahNumber,
      languageCode: widget.languageCode,
    );
  }

  void _retry() {
    setState(() {
      _storyFuture = _loadStory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabic = widget.isArabic;
    final textDirection = isArabic ? TextDirection.rtl : TextDirection.ltr;
    const bottomPadding = 24.0;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
              Text(
                isArabic
                    ? '${widget.surah.nameArabic} · ${l10n.ayahInsightStory}'
                    : '${widget.surah.nameEnglish} · ${l10n.ayahInsightStory}',
                textDirection: textDirection,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: QuranReaderTheme.ornamentGoldOf(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.ayahInsightStoryAiHint,
                textDirection: textDirection,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: QuranReaderTheme.translationTextOf(context),
                ),
              ),
              const SizedBox(height: 16),
              FutureBuilder<AyahStory>(
                future: _storyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            l10n.ayahInsightStoryLoading,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.ayahInsightStoryError,
                            textAlign: TextAlign.center,
                            textDirection: textDirection,
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: _retry,
                            child: Text(l10n.quranSyncRetry),
                          ),
                        ],
                      ),
                    );
                  }

                  return _AyahStorySections(
                    story: snapshot.data!,
                    isArabic: isArabic,
                    revelationReasonTitle:
                        l10n.ayahInsightStoryRevelationReason,
                    howRevealedTitle: l10n.ayahInsightStoryHowRevealed,
                    miracleTitle: l10n.ayahInsightStoryMiracle,
                  );
                },
              ),
        ],
      ),
    );
  }
}

class _DialogPlayButton extends StatelessWidget {
  const _DialogPlayButton({
    required this.audioCubit,
    required this.surahNumber,
    required this.ayahNumber,
  });

  final MushafBookReaderCubit audioCubit;
  final int surahNumber;
  final int ayahNumber;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<MushafBookReaderCubit, MushafBookReaderState>(
      builder: (context, state) {
        final isPlaying = state.isPlayingAyah(surahNumber, ayahNumber);
        final isLoading = state.isLoadingAyah(surahNumber, ayahNumber);

        return IconButton(
          tooltip: l10n.ayahInsightPlayAudio,
          onPressed: () {
            if (isPlaying) {
              audioCubit.stopAudio();
            } else {
              audioCubit.playFromAyah(
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
              );
            }
          },
          icon: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(isPlaying ? Icons.stop_circle_outlined : Icons.play_arrow),
        );
      },
    );
  }
}

class _AyahStorySections extends StatelessWidget {
  const _AyahStorySections({
    required this.story,
    required this.isArabic,
    required this.revelationReasonTitle,
    required this.howRevealedTitle,
    required this.miracleTitle,
  });

  final AyahStory story;
  final bool isArabic;
  final String revelationReasonTitle;
  final String howRevealedTitle;
  final String miracleTitle;

  @override
  Widget build(BuildContext context) {
    final textDirection = isArabic ? TextDirection.rtl : TextDirection.ltr;
    final bodyStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      height: 1.6,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StorySection(
          title: revelationReasonTitle,
          body: story.revelationReason,
          textDirection: textDirection,
          bodyStyle: bodyStyle,
        ),
        const SizedBox(height: 20),
        _StorySection(
          title: howRevealedTitle,
          body: story.howRevealed,
          textDirection: textDirection,
          bodyStyle: bodyStyle,
        ),
        const SizedBox(height: 20),
        _StorySection(
          title: miracleTitle,
          body: story.miracle,
          textDirection: textDirection,
          bodyStyle: bodyStyle,
        ),
      ],
    );
  }
}

class _StorySection extends StatelessWidget {
  const _StorySection({
    required this.title,
    required this.body,
    required this.textDirection,
    required this.bodyStyle,
  });

  final String title;
  final String body;
  final TextDirection textDirection;
  final TextStyle? bodyStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(title: title),
        const SizedBox(height: 8),
        Text(
          body,
          textDirection: textDirection,
          textAlign: TextAlign.justify,
          style: bodyStyle,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: QuranReaderTheme.ornamentGoldOf(context),
      ),
    );
  }
}
