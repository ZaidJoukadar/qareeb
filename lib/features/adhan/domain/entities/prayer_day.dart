import 'package:equatable/equatable.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_timings.dart';

class PrayerDay extends Equatable {
  const PrayerDay({
    required this.date,
    required this.readableDate,
    required this.weekday,
    required this.timings,
    required this.hijriDate,
    this.hijriWeekdayEn = '',
    this.hijriWeekdayAr = '',
    this.hijriDay = '',
    this.hijriMonthEn = '',
    this.hijriMonthAr = '',
    this.hijriYear = '',
  });

  final DateTime date;
  final String readableDate;
  final String weekday;
  final PrayerTimings timings;
  final String hijriDate;
  final String hijriWeekdayEn;
  final String hijriWeekdayAr;
  final String hijriDay;
  final String hijriMonthEn;
  final String hijriMonthAr;
  final String hijriYear;

  @override
  List<Object?> get props => [
    date,
    readableDate,
    weekday,
    timings,
    hijriDate,
    hijriWeekdayEn,
    hijriWeekdayAr,
    hijriDay,
    hijriMonthEn,
    hijriMonthAr,
    hijriYear,
  ];
}
