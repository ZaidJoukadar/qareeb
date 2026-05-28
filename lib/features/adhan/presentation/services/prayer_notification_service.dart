import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:qareeb/core/settings/data/app_settings_local_data_source.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_alert_preference.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';
import 'package:qareeb/features/adhan/presentation/utils/prayer_notification_schedule.dart';
import 'package:qareeb/features/adhan/presentation/utils/prayer_schedule.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

typedef PrayerNotificationCopy = ({
  String title,
  String body,
});

abstract class PrayerNotificationCopyProvider {
  PrayerNotificationCopy copyFor({
    required PrayerName prayer,
    required PrayerAlertPreference preference,
  });
}

class PrayerNotificationService {
  PrayerNotificationService({
    required AppSettingsLocalDataSource appSettings,
    required FlutterLocalNotificationsPlugin notificationsPlugin,
  })  : _appSettings = appSettings,
        _notifications = notificationsPlugin;

  final AppSettingsLocalDataSource _appSettings;
  final FlutterLocalNotificationsPlugin _notifications;

  List<PrayerDay>? _lastDays;
  PrayerAlertPreferences? _lastPreferences;
  PrayerNotificationCopyProvider? _lastCopyProvider;
  bool _initialized = false;
  bool _available = true;

  static const _androidChannelId = 'qareeb_prayer_alerts';
  static const _androidChannelName = 'Prayer alerts';

  bool get isAvailable => _available;

  Future<void> initialize() async {
    if (_initialized || !_available) {
      return;
    }

    tz_data.initializeTimeZones();
    try {
      final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
    } on Object {
      // Fallback when platform timezone lookup fails in tests.
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    try {
      await _notifications.initialize(
        settings: const InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        ),
      );

      final androidPlugin =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _androidChannelId,
          _androidChannelName,
          description: 'Reminders for prayer times',
          importance: Importance.high,
        ),
      );

      _initialized = true;
    } on MissingPluginException catch (error) {
      _available = false;
      debugPrint('Prayer notifications unavailable (rebuild required): $error');
    } on PlatformException catch (error) {
      _available = false;
      debugPrint('Prayer notifications unavailable: $error');
    }
  }

  Future<bool> requestPermissions() async {
    await initialize();
    if (!_available) {
      return false;
    }

    final androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final iosPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    final androidGranted =
        await androidPlugin?.requestNotificationsPermission() ?? true;
    final iosGranted = await iosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        true;

    return androidGranted && iosGranted;
  }

  Future<void> cancelAll() async {
    await initialize();
    if (!_available) {
      return;
    }
    await _notifications.cancelAll();
  }

  Future<void> reschedule({
    required List<PrayerDay> days,
    required PrayerAlertPreferences preferences,
    required PrayerNotificationCopyProvider copyProvider,
  }) async {
    await initialize();
    if (!_available) {
      return;
    }

    _lastDays = List<PrayerDay>.from(days);
    _lastPreferences = Map<PrayerName, PrayerAlertPreference>.from(preferences);
    _lastCopyProvider = copyProvider;

    await cancelAll();

    final notificationsEnabled = await _appSettings.getNotificationsEnabled();
    if (!notificationsEnabled) {
      return;
    }

    final daySlots = days
        .map(
          (day) => PrayerDaySlots(
            date: day.date,
            slots: buildPrayerSlots(day),
          ),
        )
        .toList(growable: false);

    final scheduled = buildScheduledNotifications(
      days: daySlots,
      preferences: preferences,
      now: DateTime.now(),
    );

    await Future.forEach(scheduled, (entry) async {
      final copy = copyProvider.copyFor(
        prayer: entry.prayer,
        preference: entry.preference,
      );

      final androidDetails = AndroidNotificationDetails(
        _androidChannelId,
        _androidChannelName,
        importance: Importance.high,
        priority: Priority.high,
        playSound: entry.preference.delivery == PrayerAlertDelivery.sound,
        enableVibration: true,
        category: AndroidNotificationCategory.alarm,
      );

      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: entry.preference.delivery == PrayerAlertDelivery.sound,
      );

      try {
        await _notifications.zonedSchedule(
          id: entry.id,
          title: copy.title,
          body: copy.body,
          scheduledDate: tz.TZDateTime.from(entry.scheduledAt, tz.local),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          notificationDetails: NotificationDetails(
            android: androidDetails,
            iOS: iosDetails,
          ),
        );
      } on Object catch (error, stackTrace) {
        debugPrint('Failed to schedule prayer notification: $error');
        debugPrint('$stackTrace');
      }
    });
  }

  Future<void> rescheduleFromCache() async {
    final days = _lastDays;
    final preferences = _lastPreferences;
    final copyProvider = _lastCopyProvider;
    if (days == null || preferences == null || copyProvider == null) {
      return;
    }

    await reschedule(
      days: days,
      preferences: preferences,
      copyProvider: copyProvider,
    );
  }
}
