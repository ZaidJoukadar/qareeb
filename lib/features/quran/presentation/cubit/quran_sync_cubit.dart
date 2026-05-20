import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/constants/quran_editions.dart';
import 'package:qareeb/features/quran/domain/usecases/get_sync_progress.dart';
import 'package:qareeb/features/quran/domain/usecases/sync_quran_to_local.dart';
import 'package:qareeb/features/quran/presentation/cubit/quran_sync_state.dart';

class QuranSyncCubit extends Cubit<QuranSyncState> {
  QuranSyncCubit({
    required SyncQuranToLocal syncQuranToLocal,
    required GetSyncProgress getSyncProgress,
    required String languageCode,
  }) : _syncQuranToLocal = syncQuranToLocal,
       _getSyncProgress = getSyncProgress,
       _translationEdition = QuranEditions.translationForLocale(
         languageCode,
       ),
       super(const QuranSyncState());

  final SyncQuranToLocal _syncQuranToLocal;
  final GetSyncProgress _getSyncProgress;
  final String _translationEdition;

  Future<void> startSync() async {
    final existing = await _getSyncProgress();
    emit(
      state.copyWith(
        status: QuranSyncUiStatus.syncing,
        completedSurahs: existing,
        clearError: true,
      ),
    );

    final progressTimer = Timer.periodic(
      const Duration(milliseconds: 400),
      (_) async {
        if (isClosed) return;
        final completed = await _getSyncProgress();
        emit(state.copyWith(completedSurahs: completed));
      },
    );

    try {
      await _syncQuranToLocal(translationEdition: _translationEdition);
      progressTimer.cancel();
      emit(
        state.copyWith(
          status: QuranSyncUiStatus.success,
          completedSurahs: 114,
          clearError: true,
        ),
      );
    } catch (error) {
      progressTimer.cancel();
      final completed = await _getSyncProgress();
      emit(
        state.copyWith(
          status: QuranSyncUiStatus.failure,
          completedSurahs: completed,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
