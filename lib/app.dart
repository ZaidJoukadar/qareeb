import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qareeb/core/config/environment.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/locale/locale_resolution.dart';
import 'package:qareeb/core/locale/presentation/cubit/locale_cubit.dart';
import 'package:qareeb/core/monitoring/sentry_navigation_observer.dart';
import 'package:qareeb/core/router/app_start_gate.dart';
import 'package:qareeb/core/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/l10n/generated/app_localizations.dart';

class QareebApp extends StatelessWidget {
  const QareebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<LocaleCubit>()..load(),
        ),
        BlocProvider(
          create: (_) => getIt<AppSettingsCubit>()..load(),
        ),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        buildWhen: (previous, current) =>
            previous.locale != current.locale ||
            previous.status != current.status,
        builder: (context, localeState) {
          final locale = LocaleCubit.resolveLocale(localeState.locale);

          return BlocBuilder<AppSettingsCubit, AppSettingsState>(
            buildWhen: (previous, current) =>
                previous.themeMode != current.themeMode ||
                previous.appFontScale != current.appFontScale,
            builder: (context, settingsState) {
              return MaterialApp(
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context).appTitle,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: settingsState.themeMode,
                builder: (context, child) {
                  final mediaQuery = MediaQuery.of(context);
                  return MediaQuery(
                    data: mediaQuery.copyWith(
                      textScaler: TextScaler.linear(
                        settingsState.appFontScale,
                      ),
                    ),
                    child: child ?? const SizedBox.shrink(),
                  );
                },
                locale: locale,
                supportedLocales: supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: localeResolutionCallback,
                navigatorObservers: Environment.current.isSentryEnabled
                    ? [SentryNavigationObserver()]
                    : const [],
                home: const AppStartGate(),
              );
            },
          );
        },
      ),
    );
  }
}
