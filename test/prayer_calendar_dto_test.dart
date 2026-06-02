import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/features/adhan/data/models/prayer_calendar_dto.dart';

void main() {
  group('PrayerCalendarDto', () {
    test('parses timings and strips timezone suffix', () {
      final dto = PrayerCalendarDto.fromJson({
        'timings': {
          'Fajr': '03:54 (+03)',
          'Sunrise': '05:34 (+03)',
          'Dhuhr': '12:33 (+03)',
          'Asr': '16:14 (+03)',
          'Maghrib': '19:33 (+03)',
          'Isha': '21:03 (+03)',
        },
        'date': {
          'readable': '25 May 2026',
          'gregorian': {
            'date': '25-05-2026',
            'weekday': {'en': 'Monday'},
          },
          'hijri': {
            'date': '08-12-1447',
            'day': '8',
            'weekday': {
              'en': 'Monday',
              'ar': 'الاثنين',
            },
            'month': {
              'en': 'Dhu al-Hijjah',
              'ar': 'ذو الحجة',
            },
            'year': '1447',
          },
        },
      });

      final entity = dto.toEntity();

      expect(entity.timings.fajr, '03:54');
      expect(entity.timings.sunrise, '05:34');
      expect(entity.timings.dhuhr, '12:33');
      expect(entity.timings.asr, '16:14');
      expect(entity.timings.maghrib, '19:33');
      expect(entity.timings.isha, '21:03');
      expect(entity.readableDate, '25 May 2026');
      expect(entity.weekday, 'Monday');
      expect(entity.hijriDate, '08-12-1447');
      expect(entity.hijriWeekdayEn, 'Monday');
      expect(entity.hijriMonthAr, 'ذو الحجة');
      expect(entity.hijriYear, '1447');
      expect(entity.date, DateTime(2026, 5, 25));
    });

    test('parses timings without timezone suffix', () {
      final dto = PrayerCalendarDto.fromJson({
        'timings': {
          'Fajr': '04:00',
          'Sunrise': '05:30',
          'Dhuhr': '12:00',
          'Asr': '15:30',
          'Maghrib': '18:00',
          'Isha': '19:30',
        },
        'date': {
          'readable': '24 May 2026',
          'gregorian': {
            'date': '24-05-2026',
            'weekday': {'en': 'Sunday'},
          },
          'hijri': {
            'date': '07-12-1447',
          },
        },
      });

      expect(dto.timings.fajr, '04:00');
    });
  });
}
