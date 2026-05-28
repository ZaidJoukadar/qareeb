import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/location/location_service.dart';
import 'package:qareeb/features/adhan/data/datasources/prayer_alert_preferences_local_data_source.dart';
import 'package:qareeb/features/adhan/domain/entities/city_search_result.dart';
import 'package:qareeb/features/adhan/domain/entities/user_location.dart';
import 'package:qareeb/features/adhan/domain/usecases/get_prayer_calendar.dart';
import 'package:qareeb/features/adhan/domain/usecases/resolve_user_location.dart';
import 'package:qareeb/features/adhan/domain/usecases/save_user_location.dart';
import 'package:qareeb/features/adhan/domain/usecases/search_cities.dart';
import 'package:qareeb/features/adhan/presentation/cubit/adhan_state.dart';
import 'package:qareeb/features/adhan/presentation/services/prayer_notification_service.dart';

class AdhanCubit extends Cubit<AdhanState> {
  AdhanCubit({
    required ResolveUserLocation resolveUserLocation,
    required GetPrayerCalendar getPrayerCalendar,
    required SearchCities searchCities,
    required SaveUserLocation saveUserLocation,
    required PrayerAlertPreferencesLocalDataSource alertPreferences,
    required PrayerNotificationService notificationService,
  }) : _resolveUserLocation = resolveUserLocation,
       _getPrayerCalendar = getPrayerCalendar,
       _searchCities = searchCities,
       _saveUserLocation = saveUserLocation,
       _alertPreferences = alertPreferences,
       _notificationService = notificationService,
       super(const AdhanState());

  final ResolveUserLocation _resolveUserLocation;
  final GetPrayerCalendar _getPrayerCalendar;
  final SearchCities _searchCities;
  final SaveUserLocation _saveUserLocation;
  final PrayerAlertPreferencesLocalDataSource _alertPreferences;
  final PrayerNotificationService _notificationService;

  PrayerNotificationCopyProvider? _copyProvider;

  Future<void> load({bool useDeviceLocation = false}) async {
    emit(
      state.copyWith(
        status: AdhanStatus.loading,
        clearFailureReason: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final location = await _resolveUserLocation(
        useDeviceLocation: useDeviceLocation,
      );
      await _loadPrayerTimesForLocation(location);
    } on LocationPermissionDeniedException {
      emit(
        state.copyWith(
          status: AdhanStatus.failure,
          failureReason: AdhanFailureReason.locationDenied,
        ),
      );
    } on LocationServiceUnavailableException {
      emit(
        state.copyWith(
          status: AdhanStatus.failure,
          failureReason: AdhanFailureReason.locationUnavailable,
        ),
      );
    } on LocationPluginUnavailableException {
      emit(
        state.copyWith(
          status: AdhanStatus.failure,
          failureReason: AdhanFailureReason.locationPluginUnavailable,
        ),
      );
    } on LocationTimeoutException {
      emit(
        state.copyWith(
          status: AdhanStatus.failure,
          failureReason: AdhanFailureReason.locationTimeout,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AdhanStatus.failure,
          failureReason: AdhanFailureReason.generic,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> refresh() async {
    final location = state.location;
    if (location == null) {
      await load();
      return;
    }

    emit(
      state.copyWith(
        status: AdhanStatus.loading,
        clearFailureReason: true,
        clearErrorMessage: true,
      ),
    );

    try {
      await _loadPrayerTimesForLocation(location);
    } catch (error) {
      emit(
        state.copyWith(
          status: AdhanStatus.failure,
          failureReason: AdhanFailureReason.generic,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> loadForDate(DateTime date) async {
    final location = state.location;
    if (location == null) {
      await load();
      return;
    }

    emit(
      state.copyWith(
        status: AdhanStatus.loading,
        clearFailureReason: true,
        clearErrorMessage: true,
      ),
    );

    try {
      await _loadPrayerTimesForLocation(
        location,
        startDateOverride: _dateOnly(date),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AdhanStatus.failure,
          failureReason: AdhanFailureReason.generic,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> selectCity(CitySearchResult city) async {
    final location = city.toUserLocation();
    await _saveUserLocation(location);

    emit(
      state.copyWith(
        status: AdhanStatus.loading,
        clearFailureReason: true,
        clearErrorMessage: true,
      ),
    );

    try {
      await _loadPrayerTimesForLocation(location);
    } catch (error) {
      emit(
        state.copyWith(
          status: AdhanStatus.failure,
          failureReason: AdhanFailureReason.generic,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<List<CitySearchResult>> searchCities(String query) {
    return _searchCities(query);
  }

  void setNotificationCopyProvider(PrayerNotificationCopyProvider provider) {
    _copyProvider = provider;
  }

  Future<void> rescheduleNotifications() async {
    final copyProvider = _copyProvider;
    if (copyProvider == null || state.prayerDays.isEmpty) {
      return;
    }

    final preferences = await _alertPreferences.loadAll();
    await _notificationService.reschedule(
      days: state.prayerDays,
      preferences: preferences,
      copyProvider: copyProvider,
    );
  }

  Future<void> _loadPrayerTimesForLocation(
    UserLocation location, {
    DateTime? startDateOverride,
  }) async {
    final startDate = startDateOverride ?? _dateOnly(DateTime.now());
    final endDate = startDate.add(const Duration(days: 6));

    final prayerDays = await _getPrayerCalendar(
      location: location,
      startDate: startDate,
      endDate: endDate,
    );

    emit(
      state.copyWith(
        status: AdhanStatus.success,
        location: location,
        prayerDays: prayerDays,
        clearFailureReason: true,
        clearErrorMessage: true,
      ),
    );

    await rescheduleNotifications();
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
