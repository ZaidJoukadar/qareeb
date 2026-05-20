import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qareeb/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:qareeb/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:qareeb/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:qareeb/features/onboarding/presentation/bloc/onboarding_state.dart';

class _MockCompleteOnboarding extends Mock implements CompleteOnboarding {}

void main() {
  late _MockCompleteOnboarding completeOnboarding;

  setUp(() {
    completeOnboarding = _MockCompleteOnboarding();
    when(() => completeOnboarding()).thenAnswer((_) async {});
  });

  blocTest<OnboardingBloc, OnboardingState>(
    'emits next page index on OnboardingNextPressed',
    build: () => OnboardingBloc(completeOnboarding: completeOnboarding),
    act: (bloc) => bloc.add(const OnboardingNextPressed()),
    expect: () => [
      const OnboardingState(
        currentPage: 1,
        status: OnboardingStatus.inProgress,
      ),
    ],
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'emits completed on skip',
    build: () => OnboardingBloc(completeOnboarding: completeOnboarding),
    act: (bloc) => bloc.add(const OnboardingSkipPressed()),
    expect: () => [
      const OnboardingState(
        status: OnboardingStatus.completed,
      ),
    ],
    verify: (_) {
      verify(() => completeOnboarding()).called(1);
    },
  );
}
