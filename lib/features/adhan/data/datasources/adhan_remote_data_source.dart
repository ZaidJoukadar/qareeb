import 'package:dio/dio.dart';
import 'package:qareeb/core/network/ummah_api_response.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_timings.dart';
import 'package:qareeb/features/adhan/domain/entities/user_location.dart';

abstract class AdhanRemoteDataSource {
  Future<List<PrayerDay>> fetchPrayerCalendar({
    required UserLocation location,
    required DateTime startDate,
    required DateTime endDate,
  });
}

class AdhanRemoteDataSourceImpl implements AdhanRemoteDataSource {
  AdhanRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<PrayerDay>> fetchPrayerCalendar({
    required UserLocation location,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final days = <PrayerDay>[];
    var current = _dateOnly(startDate);
    final last = _dateOnly(endDate);

    while (!current.isAfter(last)) {
      days.add(
        await _fetchPrayerDay(
          location: location,
          date: current,
        ),
      );
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  Future<PrayerDay> _fetchPrayerDay({
    required UserLocation location,
    required DateTime date,
  }) async {
    final isoDate = _formatIsoDate(date);

    final results = await Future.wait([
      _dio.get<Map<String, dynamic>>(
        '/prayer-times',
        queryParameters: {
          'latitude': location.latitude,
          'longitude': location.longitude,
          'date': isoDate,
        },
      ),
      _dio.get<Map<String, dynamic>>(
        '/hijri-date',
        queryParameters: {'date': isoDate},
      ),
    ]);

    final prayerBody = results[0].data;
    final hijriBody = results[1].data;
    if (prayerBody == null || hijriBody == null) {
      throw StateError('Empty response from UmmahAPI prayer times');
    }

    final prayerParsed = UmmahApiResponse.fromJson(
      prayerBody,
      (data) => data as Map<String, dynamic>,
    );
    final hijriParsed = UmmahApiResponse.fromJson(
      hijriBody,
      (data) => data as Map<String, dynamic>,
    );
    ensureUmmahSuccess(prayerParsed.success);
    ensureUmmahSuccess(hijriParsed.success);

  return _mapPrayerDay(
      date: date,
      prayerData: prayerParsed.data,
      hijriData: hijriParsed.data,
    );
  }

  PrayerDay _mapPrayerDay({
    required DateTime date,
    required Map<String, dynamic> prayerData,
    required Map<String, dynamic> hijriData,
  }) {
    final prayerTimes = prayerData['prayer_times'] as Map<String, dynamic>;
    final gregorian = hijriData['gregorian'] as Map<String, dynamic>;
    final hijri = hijriData['hijri'] as Map<String, dynamic>;

    final readableDate =
        gregorian['formatted'] as String? ?? _readableGregorianDate(date);
    final weekday = gregorian['day_of_week'] as String? ?? '';
    final hijriDate = hijri['date'] as String? ?? '';

    return PrayerDay(
      date: date,
      readableDate: readableDate,
      weekday: weekday,
      timings: PrayerTimings(
        fajr: prayerTimes['fajr'] as String,
        sunrise: prayerTimes['sunrise'] as String,
        dhuhr: prayerTimes['dhuhr'] as String,
        asr: prayerTimes['asr'] as String,
        maghrib: prayerTimes['maghrib'] as String,
        isha: prayerTimes['isha'] as String,
      ),
      hijriDate: hijriDate,
      hijriWeekdayEn: weekday,
      hijriWeekdayAr: '',
      hijriDay: hijri['day']?.toString() ?? '',
      hijriMonthEn: hijri['month_name'] as String? ?? '',
      hijriMonthAr: hijri['month_name_arabic'] as String? ?? '',
      hijriYear: hijri['year']?.toString() ?? '',
    );
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _formatIsoDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _readableGregorianDate(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday, $month ${date.day}, ${date.year}';
  }
}
