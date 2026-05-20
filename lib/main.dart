import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qareeb/app.dart';
import 'package:qareeb/core/config/environment.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/monitoring/app_bloc_observer.dart';
import 'package:qareeb/core/monitoring/sentry_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  final widgetsBinding = SentryWidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Environment.init();
  await setupInjection();

  final packageInfo = await PackageInfo.fromPlatform();

  await SentryService.init(
    packageInfo: packageInfo,
    appRunner: () {
      Bloc.observer = AppBlocObserver();
      runApp(SentryService.wrapApp(const QareebApp()));
    },
  );
}
