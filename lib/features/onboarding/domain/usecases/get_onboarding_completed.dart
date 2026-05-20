import 'package:qareeb/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingCompleted {
  const GetOnboardingCompleted(this._repository);

  final OnboardingRepository _repository;

  Future<bool> call() => _repository.isOnboardingCompleted();
}
