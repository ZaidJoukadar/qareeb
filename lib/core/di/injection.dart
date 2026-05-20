import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:qareeb/core/locale/data/locale_local_data_source.dart';
import 'package:qareeb/core/locale/data/repositories/locale_repository_impl.dart';
import 'package:qareeb/core/locale/domain/repositories/locale_repository.dart';
import 'package:qareeb/core/locale/domain/usecases/get_saved_locale.dart';
import 'package:qareeb/core/locale/domain/usecases/save_locale.dart';
import 'package:qareeb/core/locale/presentation/cubit/locale_cubit.dart';
import 'package:qareeb/core/network/quran_api_client.dart';
import 'package:qareeb/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:qareeb/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:qareeb/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:qareeb/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:qareeb/features/onboarding/domain/usecases/get_onboarding_completed.dart';
import 'package:qareeb/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:qareeb/features/quran/data/database/app_database.dart';
import 'package:qareeb/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:qareeb/features/quran/data/datasources/quran_remote_data_source.dart';
import 'package:qareeb/features/quran/data/repositories/quran_repository_impl.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart' as entities;
import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayah_audio_url.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayahs_by_surah.dart';
import 'package:qareeb/features/quran/domain/usecases/get_quran_sync_status.dart';
import 'package:qareeb/features/quran/domain/usecases/get_surahs.dart';
import 'package:qareeb/features/quran/domain/usecases/get_sync_progress.dart';
import 'package:qareeb/features/quran/domain/usecases/sync_quran_to_local.dart';
import 'package:qareeb/features/quran/presentation/cubit/ayah_reader_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/quran_sync_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/surah_list_cubit.dart';
import 'package:qareeb/features/quran/presentation/services/quran_audio_player_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  final prefs = await SharedPreferences.getInstance();

  getIt
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerLazySingleton<OnboardingLocalDataSource>(
      () => OnboardingLocalDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<LocaleLocalDataSource>(
      () => LocaleLocalDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<LocaleRepository>(
      () => LocaleRepositoryImpl(getIt()),
    )
    ..registerLazySingleton(() => GetOnboardingCompleted(getIt()))
    ..registerLazySingleton(() => CompleteOnboarding(getIt()))
    ..registerLazySingleton(() => GetSavedLocale(getIt()))
    ..registerLazySingleton(() => SaveLocale(getIt()))
    ..registerLazySingleton(
      () => LocaleCubit(getSavedLocale: getIt(), saveLocale: getIt()),
    )
    ..registerFactory(
      () => OnboardingBloc(completeOnboarding: getIt()),
    )
    ..registerLazySingleton<Dio>(createQuranApiClient)
    ..registerLazySingleton<AppDatabase>(AppDatabase.new)
    ..registerLazySingleton<QuranRemoteDataSource>(
      () => QuranRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<QuranLocalDataSource>(
      () => QuranLocalDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<QuranRepository>(
      () => QuranRepositoryImpl(getIt(), getIt()),
    )
    ..registerLazySingleton(() => GetQuranSyncStatus(getIt()))
    ..registerLazySingleton(() => SyncQuranToLocal(getIt()))
    ..registerLazySingleton(() => GetSurahs(getIt()))
    ..registerLazySingleton(() => GetAyahsBySurah(getIt()))
    ..registerLazySingleton(() => GetAyahAudioUrl(getIt()))
    ..registerLazySingleton(() => GetSyncProgress(getIt()))
    ..registerFactoryParam<QuranSyncCubit, String, void>(
      (languageCode, _) => QuranSyncCubit(
        syncQuranToLocal: getIt(),
        getSyncProgress: getIt(),
        languageCode: languageCode,
      ),
    )
    ..registerFactory(() => SurahListCubit(getSurahs: getIt()))
    ..registerFactory(() => QuranAudioPlayerService())
    ..registerFactoryParam<AyahReaderCubit, entities.Surah, bool>(
      (surah, showTranslation) => AyahReaderCubit(
        getAyahsBySurah: getIt(),
        getAyahAudioUrl: getIt(),
        audioPlayer: getIt(),
        surah: surah,
        showTranslation: showTranslation,
      ),
    );
}
