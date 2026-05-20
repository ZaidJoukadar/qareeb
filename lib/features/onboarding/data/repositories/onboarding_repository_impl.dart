import 'package:qareeb/core/monitoring/run_guarded.dart';
import 'package:qareeb/core/monitoring/sentry_report.dart';
import 'package:qareeb/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:qareeb/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._localDataSource);

  final OnboardingLocalDataSource _localDataSource;

  @override
  Future<bool> isOnboardingCompleted() => runGuarded(
    _localDataSource.isOnboardingCompleted,
    report: const SentryReport(
      feature: 'onboarding',
      action: 'is_onboarding_completed',
    ),
  );

  @override
  Future<void> completeOnboarding() => runGuarded(
    _localDataSource.setOnboardingCompleted,
    report: const SentryReport(
      feature: 'onboarding',
      action: 'complete_onboarding',
    ),
  );
}
