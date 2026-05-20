import 'package:equatable/equatable.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

final class OnboardingPageChanged extends OnboardingEvent {
  const OnboardingPageChanged(this.pageIndex);

  final int pageIndex;

  @override
  List<Object?> get props => [pageIndex];
}

final class OnboardingNextPressed extends OnboardingEvent {
  const OnboardingNextPressed();
}

final class OnboardingSkipPressed extends OnboardingEvent {
  const OnboardingSkipPressed();
}

final class OnboardingCompletePressed extends OnboardingEvent {
  const OnboardingCompletePressed();
}
