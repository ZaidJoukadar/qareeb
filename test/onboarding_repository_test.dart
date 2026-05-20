import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:qareeb/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('onboarding is not completed until marked complete', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final dataSource = OnboardingLocalDataSourceImpl(prefs);
    final repository = OnboardingRepositoryImpl(dataSource);

    expect(await repository.isOnboardingCompleted(), isFalse);

    await repository.completeOnboarding();

    expect(await repository.isOnboardingCompleted(), isTrue);
  });
}
