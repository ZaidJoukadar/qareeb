import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qareeb/core/location/location_service.dart';
import 'package:qareeb/features/adhan/domain/entities/city_search_result.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_timings.dart';
import 'package:qareeb/features/adhan/domain/entities/user_location.dart';
import 'package:qareeb/features/adhan/domain/usecases/get_prayer_calendar.dart';
import 'package:qareeb/features/adhan/domain/usecases/resolve_user_location.dart';
import 'package:qareeb/features/adhan/domain/usecases/save_user_location.dart';
import 'package:qareeb/features/adhan/domain/usecases/search_cities.dart';
import 'package:qareeb/features/adhan/data/datasources/prayer_alert_preferences_local_data_source.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_alert_preference.dart';
import 'package:qareeb/features/adhan/presentation/services/prayer_notification_service.dart';
import 'package:qareeb/features/adhan/presentation/cubit/adhan_cubit.dart';
import 'package:qareeb/features/adhan/presentation/cubit/adhan_state.dart';
import 'package:qareeb/features/adhan/presentation/utils/prayer_schedule.dart';

class _MockResolveUserLocation extends Mock implements ResolveUserLocation {}

class _MockGetPrayerCalendar extends Mock implements GetPrayerCalendar {}

class _MockSearchCities extends Mock implements SearchCities {}

class _MockSaveUserLocation extends Mock implements SaveUserLocation {}

class _MockAlertPreferences extends Mock
    implements PrayerAlertPreferencesLocalDataSource {}

class _MockNotificationService extends Mock
    implements PrayerNotificationService {}

class _MockCopyProvider extends Mock implements PrayerNotificationCopyProvider {}

void main() {
  late _MockResolveUserLocation resolveUserLocation;
  late _MockGetPrayerCalendar getPrayerCalendar;
  late _MockSearchCities searchCities;
  late _MockSaveUserLocation saveUserLocation;
  late _MockAlertPreferences alertPreferences;
  late _MockNotificationService notificationService;

  const location = UserLocation(
    latitude: 31.95,
    longitude: 35.91,
    city: 'Amman',
    country: 'Jordan',
  );

  const searchedCity = CitySearchResult(
    city: 'Dubai',
    country: 'United Arab Emirates',
    latitude: 25.2,
    longitude: 55.27,
  );

  final prayerDay = PrayerDay(
    date: DateTime(2026, 5, 24),
    readableDate: '24 May 2026',
    weekday: 'Sunday',
    timings: const PrayerTimings(
      fajr: '03:54',
      sunrise: '05:34',
      dhuhr: '12:33',
      asr: '16:14',
      maghrib: '19:33',
      isha: '21:03',
    ),
    hijriDate: '07-12-1447',
  );

  AdhanCubit buildCubit() {
    return AdhanCubit(
      resolveUserLocation: resolveUserLocation,
      getPrayerCalendar: getPrayerCalendar,
      searchCities: searchCities,
      saveUserLocation: saveUserLocation,
      alertPreferences: alertPreferences,
      notificationService: notificationService,
    );
  }

  setUp(() {
    resolveUserLocation = _MockResolveUserLocation();
    getPrayerCalendar = _MockGetPrayerCalendar();
    searchCities = _MockSearchCities();
    saveUserLocation = _MockSaveUserLocation();
    alertPreferences = _MockAlertPreferences();
    notificationService = _MockNotificationService();
    registerFallbackValue(searchedCity.toUserLocation());
    registerFallbackValue(PrayerName.fajr);
    registerFallbackValue(const PrayerAlertPreference());
    registerFallbackValue(_MockCopyProvider());

    when(() => alertPreferences.loadAll()).thenAnswer(
      (_) async => {
        for (final prayer in PrayerName.values)
          prayer: const PrayerAlertPreference(),
      },
    );
    when(
      () => notificationService.reschedule(
        days: any(named: 'days'),
        preferences: any(named: 'preferences'),
        copyProvider: any(named: 'copyProvider'),
      ),
    ).thenAnswer((_) async {});
  });

  blocTest<AdhanCubit, AdhanState>(
    'emits success when location and calendar load',
    build: buildCubit,
    act: (cubit) => cubit.load(),
    setUp: () {
      when(
        () => resolveUserLocation(useDeviceLocation: any(named: 'useDeviceLocation')),
      ).thenAnswer((_) async => location);
      when(
        () => getPrayerCalendar(
          location: location,
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => [prayerDay]);
    },
    expect: () => [
      isA<AdhanState>().having((s) => s.status, 'status', AdhanStatus.loading),
      isA<AdhanState>()
          .having((s) => s.status, 'status', AdhanStatus.success)
          .having((s) => s.location, 'location', location)
          .having((s) => s.prayerDays, 'prayerDays', [prayerDay]),
    ],
  );

  blocTest<AdhanCubit, AdhanState>(
    'emits success when a searched city is selected',
    build: buildCubit,
    act: (cubit) => cubit.selectCity(searchedCity),
    setUp: () {
      when(() => saveUserLocation(any())).thenAnswer((_) async {});
      when(
        () => getPrayerCalendar(
          location: searchedCity.toUserLocation(),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => [prayerDay]);
    },
    expect: () => [
      isA<AdhanState>().having((s) => s.status, 'status', AdhanStatus.loading),
      isA<AdhanState>()
          .having((s) => s.status, 'status', AdhanStatus.success)
          .having((s) => s.location?.city, 'city', 'Dubai'),
    ],
  );

  blocTest<AdhanCubit, AdhanState>(
    'emits locationDenied when permission is denied',
    build: buildCubit,
    act: (cubit) => cubit.load(),
    setUp: () {
      when(
        () => resolveUserLocation(useDeviceLocation: any(named: 'useDeviceLocation')),
      ).thenThrow(const LocationPermissionDeniedException());
    },
    expect: () => [
      isA<AdhanState>().having((s) => s.status, 'status', AdhanStatus.loading),
      isA<AdhanState>()
          .having((s) => s.status, 'status', AdhanStatus.failure)
          .having(
            (s) => s.failureReason,
            'failureReason',
            AdhanFailureReason.locationDenied,
          ),
    ],
  );

  blocTest<AdhanCubit, AdhanState>(
    'emits locationPluginUnavailable when geolocator is not linked',
    build: buildCubit,
    act: (cubit) => cubit.load(),
    setUp: () {
      when(
        () => resolveUserLocation(useDeviceLocation: any(named: 'useDeviceLocation')),
      ).thenThrow(const LocationPluginUnavailableException());
    },
    expect: () => [
      isA<AdhanState>().having((s) => s.status, 'status', AdhanStatus.loading),
      isA<AdhanState>()
          .having((s) => s.status, 'status', AdhanStatus.failure)
          .having(
            (s) => s.failureReason,
            'failureReason',
            AdhanFailureReason.locationPluginUnavailable,
          ),
    ],
  );

  blocTest<AdhanCubit, AdhanState>(
    'emits generic failure when calendar fetch throws',
    build: buildCubit,
    act: (cubit) => cubit.load(),
    setUp: () {
      when(
        () => resolveUserLocation(useDeviceLocation: any(named: 'useDeviceLocation')),
      ).thenAnswer((_) async => location);
      when(
        () => getPrayerCalendar(
          location: location,
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenThrow(Exception('network'));
    },
    expect: () => [
      isA<AdhanState>().having((s) => s.status, 'status', AdhanStatus.loading),
      isA<AdhanState>()
          .having((s) => s.status, 'status', AdhanStatus.failure)
          .having(
            (s) => s.failureReason,
            'failureReason',
            AdhanFailureReason.generic,
          ),
    ],
  );
}
