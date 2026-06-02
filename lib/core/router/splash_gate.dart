import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/widgets/app_splash_view.dart';
import 'package:qareeb/features/home/presentation/pages/home_placeholder_page.dart';
import 'package:qareeb/features/onboarding/domain/usecases/get_onboarding_completed.dart';
import 'package:qareeb/features/onboarding/presentation/pages/onboarding_page.dart';

class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  late final Future<bool> _onboardingCompletedFuture;

  @override
  void initState() {
    super.initState();
    _onboardingCompletedFuture = getIt<GetOnboardingCompleted>()();
    _onboardingCompletedFuture.whenComplete(FlutterNativeSplash.remove);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _onboardingCompletedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const AppSplashView();
        }

        final completed = snapshot.data ?? false;
        if (completed) {
          return const HomePlaceholderPage();
        }
        return const OnboardingPage();
      },
    );
  }
}
