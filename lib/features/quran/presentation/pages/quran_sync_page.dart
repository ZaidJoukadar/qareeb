import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/features/home/presentation/pages/surah_list_page.dart';
import 'package:qareeb/features/quran/presentation/cubit/quran_sync_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/quran_sync_state.dart';
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
    final l10n = context.l10n;

    final languageCode = Localizations.localeOf(context).languageCode;

    final cubit =
        widget.cubit ?? getIt<QuranSyncCubit>(param1: languageCode);
    if (widget.cubit == null) {
      cubit.startSync();
    }

    return BlocProvider(
      create: (_) => cubit,
      child: BlocConsumer<QuranSyncCubit, QuranSyncState>(
        listener: (context, state) {
          if (state.status == QuranSyncUiStatus.success) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const SurahListPage(),
              ),
            );
          }
        },
        builder: (context, state) {
          final isSyncing = state.status == QuranSyncUiStatus.syncing;
          final isFailure = state.status == QuranSyncUiStatus.failure;

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.quranSyncTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.quranSyncDescription,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                    LinearProgressIndicator(value: state.progress),
                    const SizedBox(height: 12),
                    Text(
                      l10n.quranSyncProgress(
                        state.completedSurahs,
                        state.totalSurahs,
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (isFailure && state.errorMessage != null) ...[
                      const SizedBox(height: 24),
                      Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: isSyncing
                            ? null
                            : () {
                                context.read<QuranSyncCubit>().startSync();
                              },
                        child: Text(l10n.quranSyncRetry),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
