import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/quran/quran_audio_playback_errors.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/features/quran/presentation/cubit/mushaf_book_reader_cubit.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qareeb/features/quran/presentation/widgets/ayah_insight_dialog.dart';
import 'package:qareeb/core/quran/quran_reader_locale.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_page_body.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_reader_locale_listener.dart';
import 'package:qareeb/features/quran/presentation/widgets/audio_reciter_picker_sheet.dart';
import 'package:qareeb/features/quran/presentation/widgets/quran_audio_player_bar.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class MushafBookReader extends StatelessWidget {
  const MushafBookReader({
    this.initialPage,
    this.initialSurahNumber,
    super.key,
  });

  final int? initialPage;
  final int? initialSurahNumber;

  @override
  Widget build(BuildContext context) {
    final showTranslation = QuranReaderLocale.showTranslationFor(
      Localizations.localeOf(context).languageCode,
    );

    return BlocProvider(
      create: (_) => getIt<MushafBookReaderCubit>(
        param1: MushafBookReaderParams(
          initialPage: initialPage,
          initialSurahNumber: initialSurahNumber,
          showTranslation: showTranslation,
        ),
      )..load(),
      child: const MushafReaderLocaleListener(
        child: MushafBookReaderContent(),
      ),
    );
  }
}

class MushafBookReaderContent extends StatefulWidget {
  const MushafBookReaderContent({super.key});

  @override
  State<MushafBookReaderContent> createState() =>
      _MushafBookReaderContentState();
}

class _MushafBookReaderContentState extends State<MushafBookReaderContent> {
  PageController? _pageController;
  int? _controllerStartPage;
  double _lastKnownPageOffset = 0;

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  /// Reads the fractional page offset without triggering Flutter's
  /// `PageController.page` assertion when multiple views are attached.
  double _pageOffsetForAnimation(
    PageController controller, {
    required int fallbackPageIndex,
  }) {
    if (!controller.hasClients) {
      return fallbackPageIndex.toDouble();
    }

    final positions = controller.positions;
    if (positions.length == 1) {
      final position = positions.single;
      if (position.hasContentDimensions && position.viewportDimension > 0) {
        return position.pixels / position.viewportDimension;
      }
    }

    return fallbackPageIndex.toDouble();
  }

  Widget _buildAnimatedPage({
    required PageController controller,
    required int index,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, animatedChild) {
        final currentPage = _pageOffsetForAnimation(
          controller,
          fallbackPageIndex: _lastKnownPageOffset.round(),
        );
        _lastKnownPageOffset = currentPage;
        final distance = (index - currentPage).abs().clamp(0.0, 1.0);
        final easedDistance = Curves.easeOut.transform(distance);
        final opacity = 0.55 + ((1 - easedDistance) * 0.45);
        final scale = 0.97 + ((1 - easedDistance) * 0.03);
        final offsetX = (index - currentPage) * 18;

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(offsetX, 0),
            child: Transform.scale(
              scale: scale,
              child: animatedChild,
            ),
          ),
        );
      },
    );
  }

  PageController _controllerFor(int startPage) {
    if (_pageController == null || _controllerStartPage != startPage) {
      _pageController?.dispose();
      _controllerStartPage = startPage;
      _lastKnownPageOffset = (startPage - 1).toDouble();
      _pageController = PageController(initialPage: startPage - 1);
    }
    return _pageController!;
  }

  bool _shouldRebuildReader(MushafBookReaderState previous, MushafBookReaderState current) {
    return previous.status != current.status ||
        previous.errorMessage != current.errorMessage ||
        previous.maxPage != current.maxPage ||
        previous.startPage != current.startPage ||
        previous.currentPage != current.currentPage ||
        previous.surahsByNumber != current.surahsByNumber ||
        previous.readAyahKeys != current.readAyahKeys ||
        previous.pagesCache != current.pagesCache ||
        previous.showTranslation != current.showTranslation ||
        previous.flaggedAyah != current.flaggedAyah ||
        previous.playingSurahNumber != current.playingSurahNumber ||
        previous.playingAyahNumber != current.playingAyahNumber ||
        previous.isAudioLoading != current.isAudioLoading ||
        previous.isAudioPaused != current.isAudioPaused ||
        previous.audioError != current.audioError ||
        previous.isSingleAyahPlayback != current.isSingleAyahPlayback ||
        previous.jumpToPage != current.jumpToPage;
  }

  Future<void> _goToFlaggedPage(
    PageController controller,
    MushafBookReaderCubit cubit,
    int page,
  ) async {
    if (!controller.hasClients) return;

    await controller.animateToPage(
      page - 1,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    await cubit.onPageChanged(page);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<MushafBookReaderCubit, MushafBookReaderState>(
      buildWhen: _shouldRebuildReader,
      listenWhen: (previous, current) =>
          previous.jumpToPage != current.jumpToPage &&
          current.jumpToPage != null,
      listener: (context, state) {
        final targetPage = state.jumpToPage;
        final controller = _pageController;
        if (targetPage == null || controller == null || !controller.hasClients) {
          return;
        }

        final cubit = context.read<MushafBookReaderCubit>();
        controller
            .animateToPage(
              targetPage - 1,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
            )
            .then((_) {
          cubit.clearJumpToPage();
        });
      },
      builder: (context, state) {
        switch (state.status) {
          case MushafBookReaderStatus.initial:
          case MushafBookReaderStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case MushafBookReaderStatus.failure:
            return Center(
              child: Text(state.errorMessage ?? l10n.surahListError),
            );
          case MushafBookReaderStatus.ready:
            final controller = _controllerFor(state.startPage);
            final cubit = context.read<MushafBookReaderCubit>();

            return Stack(
              children: [
                Column(
                  children: [
                    if (state.audioError != null)
                      MaterialBanner(
                        content: Text(
                          QuranAudioPlaybackErrors.message(
                            l10n,
                            state.audioError!,
                          ),
                        ),
                        backgroundColor: Colors.red.shade50,
                        actions: [
                          TextButton(
                            onPressed: cubit.stopAudio,
                            child: Text(l10n.dismiss),
                          ),
                        ],
                      ),
                    Expanded(
                      child: PageView.builder(
                        controller: controller,
                        itemCount: state.maxPage,
                        onPageChanged: (index) {
                          cubit.onPageChanged(index + 1);
                        },
                        itemBuilder: (context, index) {
                          final pageNumber = index + 1;
                          final ayahs = state.ayahsForPage(pageNumber);

                          if (ayahs.isEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              cubit.ensurePageLoaded(pageNumber);
                            });
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return _buildAnimatedPage(
                            controller: controller,
                            index: index,
                            child: MushafPageBody(
                              ayahs: ayahs,
                              surahsByNumber: state.surahsByNumber,
                              showTranslation: state.showTranslation,
                              readAyahNumbersForSurah:
                                  state.readAyahNumbersForSurah,
                              flaggedAyahNumberForSurah:
                                  state.flaggedAyahNumberForSurah,
                              isPlayingAyah: state.isPlayingAyah,
                              isLoadingAyah: state.isLoadingAyah,
                              isSurahPlaybackActive: (surahNumber) =>
                                  state.playingSurahNumber == surahNumber &&
                                  !state.isAudioPaused &&
                                  !state.isAudioLoading,
                              isSurahAudioLoading: (surahNumber) =>
                                  state.playingSurahNumber == surahNumber &&
                                  state.isAudioLoading,
                              onAyahTap: (surahNumber, ayahNumber) {
                                final surah = state.surahsByNumber[surahNumber];
                                if (surah == null) return;
                                showAyahInsightDialog(
                                  context: context,
                                  surah: surah,
                                  ayahNumber: ayahNumber,
                                  audioCubit: cubit,
                                );
                              },
                              onAyahDoubleTap: (surahNumber, ayahNumber) {
                                cubit.playFromAyah(
                                  surahNumber: surahNumber,
                                  ayahNumber: ayahNumber,
                                );
                              },
                              onAyahLongPress: (surahNumber, ayahNumber) {
                                cubit.flagAyah(
                                  surahNumber: surahNumber,
                                  ayahNumber: ayahNumber,
                                );
                              },
                              onSurahPlay: (surahNumber, firstAyahOnPage) {
                                cubit.playSurahFromPageStart(
                                  surahNumber: surahNumber,
                                  firstAyahOnPage: firstAyahOnPage,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    if (state.showAudioPlayerBar)
                      BlocBuilder<MushafBookReaderCubit, MushafBookReaderState>(
                        buildWhen: (previous, current) =>
                            previous.playingSurahNumber !=
                                current.playingSurahNumber ||
                            previous.playingAyahNumber !=
                                current.playingAyahNumber ||
                            previous.isAudioLoading != current.isAudioLoading ||
                            previous.isAudioPaused != current.isAudioPaused ||
                            previous.playbackPosition !=
                                current.playbackPosition ||
                            previous.playbackDuration !=
                                current.playbackDuration ||
                            previous.isSingleAyahPlayback !=
                                current.isSingleAyahPlayback ||
                            previous.showTranslation != current.showTranslation,
                        builder: (context, state) => _AudioPlayerBarForState(
                          state: state,
                          cubit: cubit,
                        ),
                      ),
                    Padding(
                      padding: Responsive.pagePadding(context).copyWith(
                        top: 8,
                        bottom: 12,
                      ),
                      child: Text(
                        l10n.mushafPageNumber(state.currentPage),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: QuranReaderTheme.ornamentGoldOf(context),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                if (state.showFlagNavigationFab)
                  PositionedDirectional(
                    end: Responsive.horizontalPadding(context),
                    bottom: Responsive.spacing(context, 56),
                    child: FloatingActionButton(
                      heroTag: 'go-to-flagged-ayah',
                      tooltip: l10n.goToFlaggedAyah,
                      backgroundColor: QuranReaderTheme.readFlagOf(context),
                      foregroundColor: Colors.white,
                      onPressed: () async {
                        final page = await cubit.pageForFlaggedAyah();
                        if (page == null) return;
                        await _goToFlaggedPage(controller, cubit, page);
                      },
                      child: const Icon(Icons.flag),
                    ),
                  ),
                if (state.hasFlaggedAyah)
                  PositionedDirectional(
                    end: Responsive.horizontalPadding(context),
                    bottom: Responsive.spacing(
                      context,
                      state.showFlagNavigationFab ? 120 : 56,
                    ),
                    child: FloatingActionButton.extended(
                      heroTag: 'remove-flagged-ayah',
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      onPressed: cubit.removeFlaggedAyah,
                      label: Text(l10n.removeFlag),
                    ),
                  ),
              ],
            );
        }
      },
    );
  }
}

class _AudioPlayerBarForState extends StatelessWidget {
  const _AudioPlayerBarForState({
    required this.state,
    required this.cubit,
  });

  final MushafBookReaderState state;
  final MushafBookReaderCubit cubit;

  @override
  Widget build(BuildContext context) {
    final playingSurah = state.surahsByNumber[state.playingSurahNumber];
    if (playingSurah == null) return const SizedBox.shrink();

    final currentAyah = state.playingAyahNumber ?? 1;

    return QuranAudioPlayerBar(
      surahName: state.showTranslation
          ? playingSurah.nameEnglish
          : playingSurah.nameArabic,
      currentAyah: currentAyah,
      totalAyahs: playingSurah.ayahCount,
      isLoading: state.isAudioLoading,
      isPaused: state.isAudioPaused,
      position: state.playbackPosition,
      duration: state.playbackDuration,
      showAyahNavigation: !state.isSingleAyahPlayback,
      canGoToPreviousAyah: currentAyah > 1,
      canGoToNextAyah: currentAyah < playingSurah.ayahCount,
      onTogglePlayPause: cubit.togglePlayPause,
      onStop: cubit.stopAudio,
      onPreviousAyah: cubit.skipToPreviousAyah,
      onNextAyah: cubit.skipToNextAyah,
      onSelectReciter: () => showAudioReciterPickerSheet(
        context,
        onReciterApplied: cubit.onReciterChanged,
      ),
    );
  }
}

class MushafBookReaderParams {
  const MushafBookReaderParams({
    required this.showTranslation,
    this.initialPage,
    this.initialSurahNumber,
  });

  final bool showTranslation;
  final int? initialPage;
  final int? initialSurahNumber;
}
