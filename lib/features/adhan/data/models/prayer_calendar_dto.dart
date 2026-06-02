import 'package:qareeb/features/adhan/domain/entities/prayer_timings.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';

class PrayerCalendarDto {
  const PrayerCalendarDto({
    required this.timings,
    required this.date,
  });

  factory PrayerCalendarDto.fromJson(Map<String, dynamic> json) {
    final timingsJson = json['timings'] as Map<String, dynamic>;
    final dateJson = json['date'] as Map<String, dynamic>;
    final gregorian = dateJson['gregorian'] as Map<String, dynamic>;

    return PrayerCalendarDto(
      timings: PrayerTimingsDto.fromJson(timingsJson),
      date: PrayerDateDto.fromJson(dateJson, gregorian),
    );
  }

  final PrayerTimingsDto timings;
  final PrayerDateDto date;

  PrayerDay toEntity() {
    return PrayerDay(
      date: date.gregorianDate,
      readableDate: date.readable,
      weekday: date.weekday,
      timings: timings.toEntity(),
      hijriDate: date.hijriDate,
      hijriWeekdayEn: date.hijriWeekdayEn,
      hijriWeekdayAr: date.hijriWeekdayAr,
      hijriDay: date.hijriDay,
      hijriMonthEn: date.hijriMonthEn,
      hijriMonthAr: date.hijriMonthAr,
      hijriYear: date.hijriYear,
    );
  }
}

class PrayerTimingsDto {
  const PrayerTimingsDto({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerTimingsDto.fromJson(Map<String, dynamic> json) {
    return PrayerTimingsDto(
      fajr: _stripTimezoneSuffix(json['Fajr'] as String),
      sunrise: _stripTimezoneSuffix(json['Sunrise'] as String),
      dhuhr: _stripTimezoneSuffix(json['Dhuhr'] as String),
      asr: _stripTimezoneSuffix(json['Asr'] as String),
      maghrib: _stripTimezoneSuffix(json['Maghrib'] as String),
      isha: _stripTimezoneSuffix(json['Isha'] as String),
    );
  }

  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  PrayerTimings toEntity() {
    return PrayerTimings(
      fajr: fajr,
      sunrise: sunrise,
      dhuhr: dhuhr,
      asr: asr,
      maghrib: maghrib,
      isha: isha,
    );
  }
}

class PrayerDateDto {
  const PrayerDateDto({
    required this.readable,
    required this.weekday,
    required this.gregorianDate,
    required this.hijriDate,
    required this.hijriWeekdayEn,
    required this.hijriWeekdayAr,
    required this.hijriDay,
    required this.hijriMonthEn,
    required this.hijriMonthAr,
    required this.hijriYear,
  });

  factory PrayerDateDto.fromJson(
    Map<String, dynamic> dateJson,
    Map<String, dynamic> gregorian,
  ) {
    final weekdayJson = gregorian['weekday'] as Map<String, dynamic>;
    final hijri = dateJson['hijri'] as Map<String, dynamic>;
    final gregorianDateString = gregorian['date'] as String;
    final hijriWeekday = hijri['weekday'] as Map<String, dynamic>?;
    final hijriMonth = hijri['month'] as Map<String, dynamic>?;

    return PrayerDateDto(
      readable: dateJson['readable'] as String,
      weekday: weekdayJson['en'] as String,
      gregorianDate: _parseGregorianDate(gregorianDateString),
      hijriDate: hijri['date'] as String,
      hijriWeekdayEn: hijriWeekday?['en'] as String? ?? '',
      hijriWeekdayAr: hijriWeekday?['ar'] as String? ?? '',
      hijriDay: hijri['day']?.toString() ?? '',
      hijriMonthEn: hijriMonth?['en'] as String? ?? '',
      hijriMonthAr: hijriMonth?['ar'] as String? ?? '',
      hijriYear: hijri['year']?.toString() ?? '',
    );
  }

  final String readable;
  final String weekday;
  final DateTime gregorianDate;
  final String hijriDate;
  final String hijriWeekdayEn;
  final String hijriWeekdayAr;
  final String hijriDay;
  final String hijriMonthEn;
  final String hijriMonthAr;
  final String hijriYear;
}

String _stripTimezoneSuffix(String time) {
  final spaceIndex = time.indexOf(' ');
  return spaceIndex == -1 ? time : time.substring(0, spaceIndex);
}

DateTime _parseGregorianDate(String date) {
  final parts = date.split('-');
  if (parts.length != 3) {
    throw FormatException('Invalid gregorian date: $date');
  }
  final day = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  final year = int.parse(parts[2]);
  return DateTime(year, month, day);
}
