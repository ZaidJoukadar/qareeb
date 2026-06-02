import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:qareeb/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:qareeb/features/onboarding/presentation/bloc/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({required CompleteOnboarding completeOnboarding})
    : _completeOnboarding = completeOnboarding,
      super(const OnboardingState(status: OnboardingStatus.inProgress)) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingNextPressed>(_onNextPressed);
    on<OnboardingSkipPressed>(_onFinish);
    on<OnboardingCompletePressed>(_onFinish);
  }

  final CompleteOnboarding _completeOnboarding;

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(currentPage: event.pageIndex));
  }

  void _onNextPressed(
    OnboardingNextPressed event,
    Emitter<OnboardingState> emit,
  ) {
    if (state.isLastPage) return;
    emit(state.copyWith(currentPage: state.currentPage + 1));
  }

  Future<void> _onFinish(
    OnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    await _completeOnboarding();
    emit(state.copyWith(status: OnboardingStatus.completed));
  }
}
