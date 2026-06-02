import 'package:intl/intl.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';

String formatAdhanHijriHeader(PrayerDay day, String locale) {
  final isArabic = locale.startsWith('ar');
  final weekday = isArabic ? day.hijriWeekdayAr : day.hijriWeekdayEn;
  final month = isArabic ? day.hijriMonthAr : day.hijriMonthEn;
  final dayNumber = int.tryParse(day.hijriDay) ?? day.hijriDay;
  final year = day.hijriYear;

  if (weekday.isNotEmpty && month.isNotEmpty && year.isNotEmpty) {
    final separator = isArabic ? '، ' : ', ';
    return '$weekday$separator$dayNumber $month $year';
  }

  return day.hijriDate;
}

String formatAdhanGregorianDate(PrayerDay day, String locale) {
  return DateFormat.yMMMMd(locale).format(day.date);
}

String formatAdhanCountdown(Duration remaining) {
  final hours = remaining.inHours;
  final minutes = remaining.inMinutes.remainder(60);
  final seconds = remaining.inSeconds.remainder(60);

  String twoDigits(int value) => value.toString().padLeft(2, '0');

  return '- ${twoDigits(hours)} : ${twoDigits(minutes)} : ${twoDigits(seconds)}';
}
