import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/widgets/app_splash_view.dart';
import 'package:qareeb/features/home/presentation/pages/home_shell_page.dart';
import 'package:qareeb/features/onboarding/domain/usecases/get_onboarding_completed.dart';
import 'package:qareeb/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:qareeb/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:qareeb/features/quran/domain/usecases/get_quran_sync_status.dart';
import 'package:qareeb/features/quran/presentation/pages/quran_sync_page.dart';

enum AppStartRoute { onboarding, quranSync, home }

class AppStartGate extends StatefulWidget {
  const AppStartGate({super.key});

  @override
  State<AppStartGate> createState() => _AppStartGateState();
}

class _AppStartGateState extends State<AppStartGate> {
  late final Future<AppStartRoute> _routeFuture;

  @override
  void initState() {
    super.initState();
    _routeFuture = _resolveRoute();
    _routeFuture.whenComplete(FlutterNativeSplash.remove);
  }

  Future<AppStartRoute> _resolveRoute() async {
    final onboardingDone = await getIt<GetOnboardingCompleted>()();
    if (!onboardingDone) {
      return AppStartRoute.onboarding;
    }

    final syncStatus = await getIt<GetQuranSyncStatus>()();
    if (syncStatus == QuranSyncStatus.completed) {
      return AppStartRoute.home;
    }

    return AppStartRoute.quranSync;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppStartRoute>(
      future: _routeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const AppSplashView();
        }

        return switch (snapshot.data) {
          AppStartRoute.onboarding => const OnboardingPage(),
          AppStartRoute.quranSync => const QuranSyncPage(),
          AppStartRoute.home => const HomeShellPage(),
          null => const OnboardingPage(),
        };
      },
    );
  }
}
