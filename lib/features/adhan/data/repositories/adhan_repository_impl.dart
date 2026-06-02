import 'package:qareeb/core/monitoring/run_guarded.dart';
import 'package:qareeb/core/monitoring/sentry_report.dart';
import 'package:qareeb/features/adhan/data/datasources/adhan_local_data_source.dart';
import 'package:qareeb/features/adhan/data/datasources/adhan_remote_data_source.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';
import 'package:qareeb/features/adhan/domain/entities/user_location.dart';
import 'package:qareeb/features/adhan/domain/repositories/adhan_repository.dart';

class AdhanRepositoryImpl implements AdhanRepository {
  AdhanRepositoryImpl(this._remote, this._local);

  final AdhanRemoteDataSource _remote;
  final AdhanLocalDataSource _local;

  @override
  Future<List<PrayerDay>> getPrayerCalendar({
    required UserLocation location,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await _local.purgeExpiredEntries();

    final cached = await _local.getPrayerCalendar(
      location: location,
      startDate: startDate,
      endDate: endDate,
    );
    if (cached != null) {
      return cached;
    }

    final remoteDays = await runGuarded(
      () => _remote.fetchPrayerCalendar(
        location: location,
        startDate: startDate,
        endDate: endDate,
      ),
      report: const SentryReport(
        feature: 'adhan',
        action: 'get_prayer_calendar',
      ),
    );
    await _local.savePrayerCalendar(location: location, days: remoteDays);
    return remoteDays;
  }
}
