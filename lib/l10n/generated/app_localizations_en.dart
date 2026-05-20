// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Qareeb';

  @override
  String get homeTitle => 'Qareeb Home';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboardingSlide1Title => 'Begin Your Journey with the Quran';

  @override
  String get onboardingSlide1Description =>
      'Set your intention and build a daily habit of reading — one step at a time, closer to Allah.';

  @override
  String get onboardingSlide2Title => 'Understand Every Verse';

  @override
  String get onboardingSlide2Description =>
      'Explore clear meanings and tafsir so every ayah speaks to your heart and mind.';

  @override
  String get onboardingSlide3Title => 'Stay Committed, Stay Close';

  @override
  String get onboardingSlide3Description =>
      'Reminders, progress, and gentle encouragement — we help you persevere on the path.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get quranSyncTitle => 'Preparing the Quran';

  @override
  String get quranSyncDescription =>
      'Downloading surahs and ayahs for offline reading. This may take a few minutes.';

  @override
  String quranSyncProgress(int completed, int total) {
    return '$completed of $total surahs';
  }

  @override
  String get quranSyncRetry => 'Retry';

  @override
  String get surahListError => 'Could not load surahs';

  @override
  String get ayahCountLabel => 'ayahs';

  @override
  String get dismiss => 'Dismiss';
}
