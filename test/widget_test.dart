
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qareeb/features/quran/domain/usecases/get_sync_progress.dart';
import 'package:qareeb/features/quran/domain/usecases/sync_quran_to_local.dart';
import 'package:qareeb/features/quran/presentation/cubit/quran_sync_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/quran_sync_state.dart';
import 'package:qareeb/features/quran/presentation/pages/quran_sync_page.dart';
import 'helpers/app_test_helper.dart';

class _MockSyncQuranToLocal extends Mock implements SyncQuranToLocal {}

class _MockGetSyncProgress extends Mock implements GetSyncProgress {}

void main() {
  testWidgets('Quran sync page shows progress in English',
      (WidgetTester tester) async {
    final syncQuran = _MockSyncQuranToLocal();
    final getProgress = _MockGetSyncProgress();
    when(() => getProgress()).thenAnswer((_) async => 12);

    final cubit = QuranSyncCubit(
      syncQuranToLocal: syncQuran,
      getSyncProgress: getProgress,
      languageCode: 'en',
    )..emit(
      const QuranSyncState(
        status: QuranSyncUiStatus.syncing,
        completedSurahs: 12,
      ),
    );

    await tester.pumpWidget(
      buildTestApp(
        child: QuranSyncPage(cubit: cubit),
      ),
    );
    await tester.pump();

    expect(find.text('Preparing the Quran'), findsOneWidget);
    expect(find.text('11%'), findsOneWidget);

    await cubit.close();
  });
}
