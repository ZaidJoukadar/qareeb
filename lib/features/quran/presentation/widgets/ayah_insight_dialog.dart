import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/bottom_sheets/app_bar_modal_bottom_sheet.dart';
import 'package:qareeb/features/quran/domain/entities/ayah_insight.dart';
import 'package:qareeb/features/quran/domain/entities/ayah_story.dart';
import 'package:qareeb/features/quran/domain/entities/ayah_word.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayah_insight.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayah_story.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayah_words.dart';
import 'package:qareeb/features/quran/presentation/cubit/mushaf_book_reader_cubit.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';
import 'package:qareeb/l10n/generated/app_localizations.dart';

Future<void> showAyahInsightDialog({
  required BuildContext context,
  required Surah surah,
  required int ayahNumber,
  MushafBookReaderCubit? audioCubit,
}) {
  final languageCode = Localizations.localeOf(context).languageCode;
  final isArabic = languageCode == 'ar';
  final parentContext = context;

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      Widget dialog = Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: _AyahInsightDialogBody(
          dialogContext: dialogContext,
          parentContext: parentContext,
          surah: surah,
          ayahNumber: ayahNumber,
          languageCode: languageCode,
          isArabic: isArabic,
          audioCubit: audioCubit,
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

enum _AyahInsightView { meaning, wordByWord }

class _AyahInsightDialogBody extends StatefulWidget {
  const _AyahInsightDialogBody({
    required this.dialogContext,
    required this.parentContext,
    required this.surah,
    required this.ayahNumber,
    required this.languageCode,
    required this.isArabic,
    this.audioCubit,
  });

  final BuildContext dialogContext;
  final BuildContext parentContext;
  final Surah surah;
  final int ayahNumber;
  final String languageCode;
  final bool isArabic;
  final MushafBookReaderCubit? audioCubit;

  @override
  State<_AyahInsightDialogBody> createState() => _AyahInsightDialogBodyState();
}

class _AyahInsightDialogBodyState extends State<_AyahInsightDialogBody> {
  _AyahInsightView _view = _AyahInsightView.meaning;
  late Future<AyahInsight> _insightFuture;
  Future<List<AyahWord>>? _wordsFuture;

  @override
  void initState() {
    super.initState();
    _insightFuture = _loadInsight();
  }

  Future<AyahInsight> _loadInsight() {
    return getIt<GetAyahInsight>()(
      surahNumber: widget.surah.number,
      ayahNumber: widget.ayahNumber,
      languageCode: widget.languageCode,
    );
  }

  Future<List<AyahWord>> _loadWords() {
    return getIt<GetAyahWords>()(
      surahNumber: widget.surah.number,
      ayahNumber: widget.ayahNumber,
      languageCode: widget.languageCode,
    );
  }

  void _selectView(_AyahInsightView view) {
    if (_view == view) return;
    setState(() {
      _view = view;
      if (view == _AyahInsightView.wordByWord) {
        _wordsFuture ??= _loadWords();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabic = widget.isArabic;
    final title = isArabic
        ? '${widget.surah.nameArabic} · ${l10n.ayahInsightAyahLabel(widget.ayahNumber)}'
        : '${widget.surah.nameEnglish} · ${l10n.ayahInsightAyahLabel(widget.ayahNumber)}';

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
                    title,
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: QuranReaderTheme.ornamentGoldOf(context),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (widget.audioCubit != null)
                  _DialogPlayButton(
                    audioCubit: widget.audioCubit!,
                    surahNumber: widget.surah.number,
                    ayahNumber: widget.ayahNumber,
                  ),
                IconButton(
                  onPressed: () => Navigator.of(widget.dialogContext).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: SegmentedButton<_AyahInsightView>(
              segments: [
                ButtonSegment(
                  value: _AyahInsightView.meaning,
                  label: Text(l10n.ayahInsightMeaning),
                ),
                ButtonSegment(
                  value: _AyahInsightView.wordByWord,
                  label: Text(l10n.ayahInsightWordByWord),
                ),
              ],
              selected: {_view},
              onSelectionChanged: (selection) {
                _selectView(selection.first);
              },
            ),
          ),
          Flexible(
            child: _view == _AyahInsightView.meaning
                ? _AyahMeaningContent(
                    future: _insightFuture,
                    isArabic: isArabic,
                    onDismiss: () => Navigator.of(widget.dialogContext).pop(),
                  )
                : _AyahWordByWordContent(
                    future: _wordsFuture!,
                    isArabic: isArabic,
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
                    Navigator.of(widget.dialogContext).pop();
                    _showStoryBottomSheet(
                      context: widget.parentContext,
                      surah: widget.surah,
                      ayahNumber: widget.ayahNumber,
                      languageCode: widget.languageCode,
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
  }
}

class _AyahMeaningContent extends StatelessWidget {
  const _AyahMeaningContent({
    required this.future,
    required this.isArabic,
    required this.onDismiss,
  });

  final Future<AyahInsight> future;
  final bool isArabic;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FutureBuilder<AyahInsight>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.ayahInsightError, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: onDismiss,
                  child: Text(l10n.dismiss),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text(
            snapshot.data!.meaning,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        );
      },
    );
  }
}

class _AyahWordByWordContent extends StatelessWidget {
  const _AyahWordByWordContent({
    required this.future,
    required this.isArabic,
  });

  final Future<List<AyahWord>> future;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FutureBuilder<List<AyahWord>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.ayahInsightWordsError,
              textAlign: TextAlign.center,
            ),
          );
        }

        final words = snapshot.data!;
        final bodyStyle = Theme.of(context).textTheme.bodyMedium;
        final mutedStyle = bodyStyle?.copyWith(
          color: QuranReaderTheme.translationTextOf(context),
        );

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          itemCount: words.length,
          separatorBuilder: (context, index) => const Divider(height: 20),
          itemBuilder: (context, index) {
            final word = words[index];
            final meaningDirection =
                isArabic ? TextDirection.rtl : TextDirection.ltr;
            final showTransliteration =
                !isArabic && word.transliteration.isNotEmpty;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    word.arabic,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: isArabic
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (showTransliteration)
                        Text(
                          word.transliteration,
                          textDirection: TextDirection.ltr,
                          style: mutedStyle?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      if (showTransliteration) const SizedBox(height: 4),
                      Text(
                        word.translation,
                        textDirection: meaningDirection,
                        textAlign: isArabic ? TextAlign.end : TextAlign.start,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
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
  AyahStory? _story;
  Object? _error;
  var _isLoading = true;
  var _requestId = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_loadStory());
  }

  Future<void> _loadStory() async {
    final requestId = ++_requestId;

    setState(() {
      _isLoading = true;
      _error = null;
      _story = null;
    });

    try {
      final story = await getIt<GetAyahStory>()(
        surahNumber: widget.surah.number,
        ayahNumber: widget.ayahNumber,
        languageCode: widget.languageCode,
      );
      if (!mounted || requestId != _requestId) return;

      setState(() {
        _story = story;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted || requestId != _requestId) return;

      setState(() {
        _error = error;
        _isLoading = false;
      });
    }
  }

  void _retry() {
    unawaited(_loadStory());
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
              _buildStoryContent(
                context: context,
                l10n: l10n,
                textDirection: textDirection,
              ),
        ],
      ),
    );
  }

  Widget _buildStoryContent({
    required BuildContext context,
    required AppLocalizations l10n,
    required TextDirection textDirection,
  }) {
    if (_isLoading) {
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

    if (_error != null || _story == null) {
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
      story: _story!,
      isArabic: widget.isArabic,
      revelationReasonTitle: l10n.ayahInsightStoryRevelationReason,
      howRevealedTitle: l10n.ayahInsightStoryHowRevealed,
      miracleTitle: l10n.ayahInsightStoryMiracle,
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
