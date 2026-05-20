import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/constants/onboarding_content.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/features/quran/presentation/pages/quran_sync_page.dart';
import 'package:qareeb/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:qareeb/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:qareeb/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:qareeb/features/onboarding/presentation/widgets/onboarding_slide.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<OnboardingBloc>(),
      child: BlocConsumer<OnboardingBloc, OnboardingState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.currentPage != current.currentPage,
        listener: (context, state) {
          if (state.status == OnboardingStatus.completed) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const QuranSyncPage(),
              ),
            );
            return;
          }
          if (_pageController.hasClients &&
              _pageController.page?.round() != state.currentPage) {
            _goToPage(state.currentPage);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: OnboardingContent.slides.length,
                  onPageChanged: (index) {
                    context.read<OnboardingBloc>().add(
                      OnboardingPageChanged(index),
                    );
                  },
                  itemBuilder: (context, index) {
                    return OnboardingSlideWidget(
                      slide: OnboardingContent.slides[index],
                      slideIndex: index,
                    );
                  },
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        context.read<OnboardingBloc>().add(
                          const OnboardingSkipPressed(),
                        );
                      },
                      child: Text(l10n.skip),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 32,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            OnboardingContent.slides.length,
                            (index) => Container(
                              width: index == state.currentPage ? 24 : 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: index == state.currentPage
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final bloc = context.read<OnboardingBloc>();
                              if (state.isLastPage) {
                                bloc.add(const OnboardingCompletePressed());
                              } else {
                                bloc.add(const OnboardingNextPressed());
                              }
                            },
                            child: Text(
                              state.isLastPage ? l10n.getStarted : l10n.next,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
