import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';
import 'package:qareeb/features/adhan/domain/entities/user_location.dart';
import 'package:qareeb/features/adhan/domain/repositories/adhan_repository.dart';

class GetPrayerCalendar {
  const GetPrayerCalendar(this._repository);

  final AdhanRepository _repository;

  Future<List<PrayerDay>> call({
    required UserLocation location,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _repository.getPrayerCalendar(
      location: location,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
