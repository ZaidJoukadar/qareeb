import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';
import 'package:qareeb/features/adhan/domain/entities/user_location.dart';

abstract class AdhanRepository {
  Future<List<PrayerDay>> getPrayerCalendar({
    required UserLocation location,
    required DateTime startDate,
    required DateTime endDate,
  });
}
