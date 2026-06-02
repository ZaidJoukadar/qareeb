import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/monitoring/sentry_service.dart';

final class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    SentryService.addBreadcrumb(
      message: '${bloc.runtimeType} → $event',
      category: 'bloc.event',
      data: {'bloc': bloc.runtimeType.toString()},
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    SentryService.addBreadcrumb(
      message:
          '${bloc.runtimeType}: ${transition.currentState.runtimeType} → ${transition.nextState.runtimeType}',
      category: 'bloc.transition',
      data: {
        'bloc': bloc.runtimeType.toString(),
        'event': transition.event.runtimeType.toString(),
      },
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    final stateDescription = bloc.state?.runtimeType.toString() ?? 'unknown';

    SentryService.captureException(
      error,
      stackTrace: stackTrace,
      report: SentryReport(
        feature: 'bloc',
        action: bloc.runtimeType.toString(),
        level: ReportLevel.error,
        extra: {
          'bloc_type': bloc.runtimeType.toString(),
          'state_type': stateDescription,
          'error_type': error.runtimeType.toString(),
        },
      ),
    );
  }
}
