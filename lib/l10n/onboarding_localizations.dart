import 'package:qareeb/l10n/generated/app_localizations.dart';

extension OnboardingLocalizations on AppLocalizations {
  String onboardingTitle(int index) {
    return switch (index) {
      0 => onboardingSlide1Title,
      1 => onboardingSlide2Title,
      2 => onboardingSlide3Title,
      _ => onboardingSlide1Title,
    };
  }

  String onboardingDescription(int index) {
    return switch (index) {
      0 => onboardingSlide1Description,
      1 => onboardingSlide2Description,
      2 => onboardingSlide3Description,
      _ => onboardingSlide1Description,
    };
  }
}
