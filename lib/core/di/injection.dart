import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:qareeb/core/locale/data/locale_local_data_source.dart';
import 'package:qareeb/core/locale/data/repositories/locale_repository_impl.dart';
import 'package:qareeb/core/locale/domain/repositories/locale_repository.dart';
import 'package:qareeb/core/locale/domain/usecases/get_saved_locale.dart';
import 'package:qareeb/core/locale/domain/usecases/save_locale.dart';
import 'package:qareeb/core/locale/presentation/cubit/locale_cubit.dart';
import 'package:qareeb/core/location/location_service.dart';
import 'package:qareeb/core/network/ummah_api_client.dart';
import 'package:qareeb/core/constants/quran_editions.dart';
import 'package:qareeb/core/constants/storage_keys.dart';
import 'package:qareeb/core/quran/quran_audio_reciter_settings.dart';
import 'package:qareeb/core/network/pollinations_api_client.dart';
import 'package:qareeb/core/settings/data/app_settings_local_data_source.dart';
import 'package:qareeb/core/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:qareeb/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:qareeb/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:qareeb/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:qareeb/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:qareeb/features/onboarding/domain/usecases/get_onboarding_completed.dart';
import 'package:qareeb/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qareeb/features/adhan/data/datasources/adhan_local_data_source.dart';
import 'package:qareeb/features/adhan/data/datasources/adhan_remote_data_source.dart';
import 'package:qareeb/features/adhan/data/datasources/prayer_alert_preferences_local_data_source.dart';
import 'package:qareeb/features/adhan/presentation/services/prayer_notification_service.dart';
import 'package:qareeb/features/adhan/data/datasources/location_local_data_source.dart';
import 'package:qareeb/features/adhan/data/repositories/adhan_repository_impl.dart';
import 'package:qareeb/features/adhan/domain/repositories/adhan_repository.dart';
import 'package:qareeb/features/adhan/domain/usecases/get_prayer_calendar.dart';
import 'package:qareeb/features/adhan/domain/usecases/resolve_user_location.dart';
import 'package:qareeb/features/adhan/domain/usecases/save_user_location.dart';
import 'package:qareeb/features/adhan/domain/usecases/search_cities.dart';
import 'package:qareeb/features/adhan/presentation/cubit/adhan_cubit.dart';
import 'package:qareeb/features/asma_ul_husna/data/datasources/asma_ul_husna_local_data_source.dart';
import 'package:qareeb/features/asma_ul_husna/data/datasources/asma_ul_husna_remote_data_source.dart';
import 'package:qareeb/features/asma_ul_husna/data/repositories/asma_ul_husna_repository_impl.dart';
import 'package:qareeb/features/asma_ul_husna/domain/repositories/asma_ul_husna_repository.dart';
import 'package:qareeb/features/asma_ul_husna/domain/usecases/get_asma_ul_husna.dart';
import 'package:qareeb/features/asma_ul_husna/presentation/cubit/asma_ul_husna_cubit.dart';
import 'package:qareeb/features/duaa/data/datasources/duaa_local_data_source.dart';
import 'package:qareeb/features/duaa/data/datasources/duaa_remote_data_source.dart';
import 'package:qareeb/features/duaa/data/repositories/duaa_repository_impl.dart';
import 'package:qareeb/features/duaa/domain/repositories/duaa_repository.dart';
import 'package:qareeb/features/duaa/domain/usecases/get_dua_categories.dart';
import 'package:qareeb/features/duaa/domain/usecases/get_duas_by_category.dart';
import 'package:qareeb/features/duaa/presentation/cubit/duaa_categories_cubit.dart';
import 'package:qareeb/features/duaa/presentation/cubit/duaa_category_cubit.dart';
import 'package:qareeb/features/hadith/data/datasources/hadith_remote_data_source.dart';
import 'package:qareeb/features/hadith/data/repositories/hadith_repository_impl.dart';
import 'package:qareeb/features/hadith/domain/repositories/hadith_repository.dart';
import 'package:qareeb/features/hadith/domain/usecases/get_hadith_categories.dart';
import 'package:qareeb/features/hadith/domain/usecases/get_hadith_collections.dart';
import 'package:qareeb/features/hadith/domain/usecases/get_hadith_page.dart';
import 'package:qareeb/features/hadith/domain/usecases/get_hadiths_for_category.dart';
import 'package:qareeb/features/hadith/domain/usecases/search_hadith.dart';
import 'package:qareeb/features/hadith/presentation/cubit/hadith_category_cubit.dart';
import 'package:qareeb/features/hadith/presentation/cubit/hadith_collection_cubit.dart';
import 'package:qareeb/features/hadith/presentation/cubit/hadith_collections_cubit.dart';
import 'package:qareeb/features/quran/data/database/app_database.dart';
import 'package:qareeb/features/quran/data/datasources/ayah_story_remote_data_source.dart';
import 'package:qareeb/features/quran/data/datasources/quran_audio_cache_data_source.dart';
import 'package:qareeb/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:qareeb/features/quran/data/datasources/quran_ayah_metadata_index.dart';
import 'package:qareeb/features/quran/data/datasources/quran_remote_data_source.dart';
import 'package:qareeb/features/quran/data/datasources/reading_progress_local_data_source.dart';
import 'package:qareeb/features/quran/data/repositories/ayah_story_repository_impl.dart';
import 'package:qareeb/features/quran/data/repositories/quran_repository_impl.dart';
import 'package:qareeb/features/quran/data/repositories/reading_progress_repository_impl.dart';
import 'package:qareeb/features/quran/presentation/cubit/surah_list_cubit.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart' as entities;
import 'package:qareeb/features/quran/domain/repositories/ayah_story_repository.dart';
import 'package:qareeb/features/quran/domain/repositories/quran_repository.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayah_audio_url.dart';
import 'package:qareeb/features/quran/domain/usecases/get_surah_audio_urls.dart';
import 'package:qareeb/features/quran/domain/usecases/prefetch_surah_audio.dart';
import 'package:qareeb/features/quran/domain/usecases/resolve_ayah_audio_source.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayah_insight.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayah_story.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayahs_by_surah.dart';
import 'package:qareeb/features/quran/domain/usecases/get_quran_sync_status.dart';
import 'package:qareeb/features/quran/domain/usecases/get_surahs.dart';
import 'package:qareeb/features/quran/domain/usecases/get_surah_count_by_juz.dart';
import 'package:qareeb/features/quran/domain/usecases/get_sync_progress.dart';
import 'package:qareeb/features/quran/domain/usecases/sync_quran_to_local.dart';
import 'package:qareeb/features/quran/presentation/cubit/ayah_reader_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/quran_sync_cubit.dart';
import 'package:qareeb/features/quran/domain/repositories/reading_progress_repository.dart';
import 'package:qareeb/features/quran/domain/usecases/get_all_read_ayah_keys.dart';
import 'package:qareeb/features/quran/domain/usecases/get_ayahs_by_page.dart';
import 'package:qareeb/features/quran/domain/usecases/get_first_page_for_juz.dart';
import 'package:qareeb/features/quran/domain/usecases/get_first_page_for_surah.dart';
import 'package:qareeb/features/quran/domain/usecases/get_mushaf_page_count.dart';
import 'package:qareeb/features/quran/domain/usecases/get_read_ayah_counts.dart';
import 'package:qareeb/features/quran/domain/usecases/get_read_ayah_numbers.dart';
import 'package:qareeb/features/quran/domain/usecases/mark_surah_as_read.dart';
import 'package:qareeb/features/quran/domain/usecases/toggle_ayah_read.dart';
import 'package:qareeb/features/quran/domain/usecases/get_surah_by_number.dart';
import 'package:qareeb/features/quran/presentation/cubit/juz_list_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/home_surah_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/mushaf_book_reader_cubit.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_book_reader.dart';
import 'package:qareeb/features/quran/presentation/services/quran_audio_player_service.dart';
import 'package:qareeb/features/quran/presentation/services/quran_surah_playback_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  final prefs = await SharedPreferences.getInstance();
  final audioReciterSettings = QuranAudioReciterSettings()
    ..editionIdentifier =
        prefs.getString(StorageKeys.quranAudioReciter) ??
        QuranEditions.audioRecitation;

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
    ..registerLazySingleton<AppSettingsLocalDataSource>(
      () => AppSettingsLocalDataSourceImpl(getIt()),
    )
    ..registerSingleton<QuranAudioReciterSettings>(audioReciterSettings)
    ..registerLazySingleton(
      () => AppSettingsCubit(
        dataSource: getIt(),
        audioReciterSettings: getIt(),
        notificationService: getIt(),
      ),
    )
    ..registerFactory(
      () => OnboardingBloc(completeOnboarding: getIt()),
    )
    ..registerLazySingleton<Dio>(createUmmahApiClient)
    ..registerLazySingleton<Dio>(
      createPollinationsApiClient,
      instanceName: 'pollinations',
    )
    ..registerLazySingleton<QuranAyahMetadataIndex>(
      () => QuranAyahMetadataIndex(getIt()),
    )
    ..registerLazySingleton<QuranRemoteDataSource>(
      () => QuranRemoteDataSourceImpl(getIt(), getIt(), getIt()),
    )
    ..registerLazySingleton<AppDatabase>(AppDatabase.new)
    ..registerLazySingleton<AyahStoryRemoteDataSource>(
      () => PollinationsAyahStoryRemoteDataSource(
        getIt(instanceName: 'pollinations'),
      ),
    )
    ..registerLazySingleton<QuranLocalDataSource>(
      () => QuranLocalDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<QuranAudioCacheDataSource>(
      () => QuranAudioCacheDataSourceImpl(getIt(), getIt()),
    )
    ..registerLazySingleton<ReadingProgressLocalDataSource>(
      () => ReadingProgressLocalDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<ReadingProgressRepository>(
      () => ReadingProgressRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<QuranRepository>(
      () => QuranRepositoryImpl(getIt(), getIt(), getIt(), getIt()),
    )
    ..registerLazySingleton<AyahStoryRepository>(
      () => AyahStoryRepositoryImpl(getIt(), getIt()),
    )
    ..registerLazySingleton(() => GetQuranSyncStatus(getIt()))
    ..registerLazySingleton(() => SyncQuranToLocal(getIt()))
    ..registerLazySingleton(() => GetSurahs(getIt()))
    ..registerLazySingleton(() => GetSurahByNumber(getIt()))
    ..registerLazySingleton(() => GetReadAyahNumbers(getIt()))
    ..registerLazySingleton(() => GetReadAyahCounts(getIt()))
    ..registerLazySingleton(() => ToggleAyahRead(getIt()))
    ..registerLazySingleton(() => MarkSurahAsRead(getIt()))
    ..registerLazySingleton(() => GetAyahsBySurah(getIt()))
    ..registerLazySingleton(() => GetAyahsByPage(getIt()))
    ..registerLazySingleton(() => GetMushafPageCount(getIt()))
    ..registerLazySingleton(() => GetFirstPageForSurah(getIt()))
    ..registerLazySingleton(() => GetFirstPageForJuz(getIt()))
    ..registerLazySingleton(() => GetSurahCountByJuz(getIt()))
    ..registerLazySingleton(() => GetAllReadAyahKeys(getIt()))
    ..registerLazySingleton(() => GetAyahAudioUrl(getIt()))
    ..registerLazySingleton(() => GetSurahAudioUrls(getIt()))
    ..registerLazySingleton(() => ResolveAyahAudioSource(getIt()))
    ..registerLazySingleton(() => PrefetchSurahAudio(getIt()))
    ..registerLazySingleton(() => GetAyahInsight(getIt()))
    ..registerLazySingleton(() => GetAyahStory(getIt()))
    ..registerLazySingleton(() => GetSyncProgress(getIt()))
    ..registerFactoryParam<QuranSyncCubit, String, void>(
      (languageCode, _) => QuranSyncCubit(
        syncQuranToLocal: getIt(),
        getSyncProgress: getIt(),
        languageCode: languageCode,
      ),
    )
    ..registerFactory(
      () => SurahListCubit(
        getSurahs: getIt(),
        getReadAyahCounts: getIt(),
      ),
    )
    ..registerFactory(
      () => JuzListCubit(getSurahCountByJuz: getIt()),
    )
    ..registerFactory(() => HomeSurahCubit(getSurahByNumber: getIt()))
    ..registerFactory(
      () => QuranSurahPlaybackService(
        resolveAyahAudioSource: getIt(),
        prefetchSurahAudio: getIt(),
        audioPlayer: QuranAudioPlayerService(),
      ),
    )
    ..registerFactoryParam<MushafBookReaderCubit, MushafBookReaderParams, void>(
      (params, _) => MushafBookReaderCubit(
        getAyahsByPage: getIt(),
        getMushafPageCount: getIt(),
        getFirstPageForSurah: getIt(),
        getSurahs: getIt(),
        getAllReadAyahKeys: getIt(),
        toggleAyahRead: getIt(),
        markSurahAsRead: getIt(),
        playback: getIt(),
        showTranslation: params.showTranslation,
        initialPage: params.initialPage,
        initialSurahNumber: params.initialSurahNumber,
      ),
    )
    ..registerFactoryParam<AyahReaderCubit, entities.Surah, bool>(
      (surah, showTranslation) => AyahReaderCubit(
        getAyahsBySurah: getIt(),
        getReadAyahNumbers: getIt(),
        toggleAyahRead: getIt(),
        markSurahAsRead: getIt(),
        playback: getIt(),
        surah: surah,
        showTranslation: showTranslation,
      ),
    )
    ..registerLazySingleton<LocationLocalDataSource>(
      () => LocationLocalDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<PrayerAlertPreferencesLocalDataSource>(
      () => PrayerAlertPreferencesLocalDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<FlutterLocalNotificationsPlugin>(
      FlutterLocalNotificationsPlugin.new,
    )
    ..registerLazySingleton<PrayerNotificationService>(
      () => PrayerNotificationService(
        appSettings: getIt(),
        notificationsPlugin: getIt(),
      ),
    )
    ..registerLazySingleton<LocationService>(
      () => LocationService(getIt()),
    )
    ..registerLazySingleton<AdhanRemoteDataSource>(
      () => AdhanRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<AdhanLocalDataSource>(
      () => AdhanLocalDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<AdhanRepository>(
      () => AdhanRepositoryImpl(getIt(), getIt()),
    )
    ..registerLazySingleton(() => ResolveUserLocation(getIt(), getIt()))
    ..registerLazySingleton(() => GetPrayerCalendar(getIt()))
    ..registerLazySingleton(() => SearchCities(getIt()))
    ..registerLazySingleton(() => SaveUserLocation(getIt()))
    ..registerFactory(
      () => AdhanCubit(
        resolveUserLocation: getIt(),
        getPrayerCalendar: getIt(),
        searchCities: getIt(),
        saveUserLocation: getIt(),
        alertPreferences: getIt(),
        notificationService: getIt(),
      ),
    )
    ..registerLazySingleton<AsmaUlHusnaRemoteDataSource>(
      () => AsmaUlHusnaRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<AsmaUlHusnaLocalDataSource>(
      AsmaUlHusnaLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<AsmaUlHusnaRepository>(
      () => AsmaUlHusnaRepositoryImpl(getIt(), getIt()),
    )
    ..registerLazySingleton(() => GetAsmaUlHusna(getIt()))
    ..registerFactory(() => AsmaUlHusnaCubit(getAsmaUlHusna: getIt()))
    ..registerLazySingleton<DuaaRemoteDataSource>(
      () => DuaaRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<DuaaLocalDataSource>(
      DuaaLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<DuaaRepository>(
      () => DuaaRepositoryImpl(getIt(), getIt()),
    )
    ..registerLazySingleton(() => GetDuaCategories(getIt()))
    ..registerLazySingleton(() => GetDuasByCategory(getIt()))
    ..registerFactory(() => DuaaCategoriesCubit(getDuaCategories: getIt()))
    ..registerFactory(() => DuaaCategoryCubit(getDuasByCategory: getIt()))
    ..registerLazySingleton<HadithRemoteDataSource>(
      () => HadithRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<HadithRepository>(
      () => HadithRepositoryImpl(getIt()),
    )
    ..registerLazySingleton(() => GetHadithCategories(getIt()))
    ..registerLazySingleton(() => GetHadithCollections(getIt()))
    ..registerLazySingleton(() => GetHadithPage(getIt()))
    ..registerLazySingleton(() => GetHadithsForCategory(getIt()))
    ..registerLazySingleton(() => SearchHadith(getIt()))
    ..registerFactory(
      () => HadithCollectionsCubit(
        getHadithCategories: getIt(),
        getHadithCollections: getIt(),
        searchHadith: getIt(),
      ),
    )
    ..registerFactory(() => HadithCategoryCubit(getHadithsForCategory: getIt()))
    ..registerFactory(
      () => HadithCollectionCubit(
        getHadithPage: getIt(),
        searchHadith: getIt(),
      ),
    );
}
