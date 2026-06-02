import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/constants/asset_paths.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/features/home/presentation/pages/home_shell_page.dart';
import 'package:qareeb/features/quran/presentation/cubit/quran_sync_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/quran_sync_state.dart';
import 'package:qareeb/features/quran/presentation/widgets/quran_sync_progress_panel.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class QuranSyncPage extends StatefulWidget {
  const QuranSyncPage({this.cubit, super.key});

  /// Optional override for tests; production uses [getIt].
  final QuranSyncCubit? cubit;

  @override
  State<QuranSyncPage> createState() => _QuranSyncPageState();
}

class _QuranSyncPageState extends State<QuranSyncPage> {
  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    final cubit =
        widget.cubit ?? getIt<QuranSyncCubit>(param1: languageCode);
    if (widget.cubit == null) {
      cubit.startSync();
    }

    return BlocProvider(
      create: (_) => cubit,
      child: BlocConsumer<QuranSyncCubit, QuranSyncState>(
        listener: (context, state) async {
          if (state.status == QuranSyncUiStatus.success) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const HomeShellPage(),
              ),
            );
            return;
          }

          final l10n = context.l10n;
          if (state.status == QuranSyncUiStatus.failure &&
              state.showConnectionErrorDialog) {
            final cubit = context.read<QuranSyncCubit>();
            await showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                final theme = Theme.of(dialogContext);
                return AlertDialog(
                  icon: Icon(
                    Icons.wifi_off_rounded,
                    size: 56,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  title: Text(
                    l10n.quranSyncConnectionErrorTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  content: Text(l10n.quranSyncConnectionErrorMessage),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    FilledButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        cubit.startSync();
                      },
                      child: Text(l10n.quranSyncRetry),
                    ),
                  ],
                );
              },
            );

            if (!context.mounted) return;
            cubit.dismissConnectionErrorDialog();
          }
        },
        builder: (context, state) {
          final isSyncing = state.status == QuranSyncUiStatus.syncing;
          final isFailure = state.status == QuranSyncUiStatus.failure;

          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                const Image(
                  image: AssetImage(AssetPaths.loadingBackground),
                  fit: BoxFit.cover,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.72),
                        Colors.black.withValues(alpha: 0.35),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.42, 0.78],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: QuranSyncProgressPanel(
                        state: state,
                        showRetry: isFailure,
                        onRetry: isSyncing
                            ? null
                            : () {
                                context.read<QuranSyncCubit>().startSync();
                              },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
