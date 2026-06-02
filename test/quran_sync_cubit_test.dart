import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qareeb/features/quran/domain/usecases/get_sync_progress.dart';
import 'package:qareeb/features/quran/domain/usecases/sync_quran_to_local.dart';
import 'package:qareeb/features/quran/presentation/cubit/quran_sync_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/quran_sync_state.dart';

class _MockSyncQuranToLocal extends Mock implements SyncQuranToLocal {}

class _MockGetSyncProgress extends Mock implements GetSyncProgress {}

void main() {
  late _MockSyncQuranToLocal syncQuran;
  late _MockGetSyncProgress getProgress;

  setUp(() {
    syncQuran = _MockSyncQuranToLocal();
    getProgress = _MockGetSyncProgress();
    when(() => getProgress()).thenAnswer((_) async => 0);
  });

  blocTest<QuranSyncCubit, QuranSyncState>(
    'emits success when sync completes',
    build: () => QuranSyncCubit(
      syncQuranToLocal: syncQuran,
      getSyncProgress: getProgress,
      languageCode: 'en',
    ),
    act: (cubit) => cubit.startSync(),
    setUp: () {
      when(
        () => syncQuran(translationEdition: any(named: 'translationEdition')),
      ).thenAnswer((_) async {});
      when(() => getProgress()).thenAnswer((_) async => 0);
    },
    expect: () => [
      isA<QuranSyncState>()
          .having((s) => s.status, 'status', QuranSyncUiStatus.syncing),
      isA<QuranSyncState>()
          .having((s) => s.status, 'status', QuranSyncUiStatus.success)
          .having((s) => s.completedSurahs, 'completed', 114),
    ],
  );

  blocTest<QuranSyncCubit, QuranSyncState>(
    'emits failure when sync throws',
    build: () => QuranSyncCubit(
      syncQuranToLocal: syncQuran,
      getSyncProgress: getProgress,
      languageCode: 'en',
    ),
    act: (cubit) => cubit.startSync(),
    setUp: () {
      when(
        () => syncQuran(translationEdition: any(named: 'translationEdition')),
      ).thenThrow(Exception('network'));
      when(() => getProgress()).thenAnswer((_) async => 3);
    },
    expect: () => [
      isA<QuranSyncState>()
          .having((s) => s.status, 'status', QuranSyncUiStatus.syncing),
      isA<QuranSyncState>()
          .having((s) => s.status, 'status', QuranSyncUiStatus.failure)
          .having((s) => s.completedSurahs, 'completed', 3),
    ],
  );
}
