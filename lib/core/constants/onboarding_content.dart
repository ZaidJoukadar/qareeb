import 'package:qareeb/core/constants/asset_paths.dart';
import 'package:qareeb/features/onboarding/domain/entities/onboarding_slide.dart';

abstract final class OnboardingContent {
  static const List<OnboardingSlide> slides = [
    OnboardingSlide(imageAsset: AssetPaths.onboarding1),
    OnboardingSlide(imageAsset: AssetPaths.onboarding2),
    OnboardingSlide(imageAsset: AssetPaths.onboarding3),
  ];
}
