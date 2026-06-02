import 'package:flutter/material.dart';
import 'package:qareeb/features/onboarding/domain/entities/onboarding_slide.dart'
    as entity;
import 'package:qareeb/l10n/extensions/l10n_extension.dart';
import 'package:qareeb/l10n/onboarding_localizations.dart';

class OnboardingSlideWidget extends StatelessWidget {
  const OnboardingSlideWidget({
    super.key,
    required this.slide,
    required this.slideIndex,
  });

  final entity.OnboardingSlide slide;
  final int slideIndex;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          slide.imageAsset,
          fit: BoxFit.cover,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withValues(alpha: 0.75),
                Colors.black.withValues(alpha: 0.2),
                Colors.transparent,
              ],
              stops: const [0.0, 0.45, 0.85],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
            child: Align(
              alignment: Directionality.of(context) == TextDirection.rtl
                  ? Alignment.bottomRight
                  : Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.onboardingTitle(slideIndex),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    strings.onboardingDescription(slideIndex),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
