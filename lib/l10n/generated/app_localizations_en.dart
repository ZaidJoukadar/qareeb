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
  String get languageTurkish => 'Turkish';

  @override
  String get quranSyncTitle => 'Preparing the Quran';

  @override
  String get quranSyncDescription =>
      'Downloading surahs and ayahs for offline reading. This may take a few minutes.';

  @override
  String quranSyncProgressPercent(int percent) {
    return '$percent%';
  }

  @override
  String get quranSyncRetry => 'Retry';

  @override
  String get quranSyncConnectionErrorTitle => 'Check your connection';

  @override
  String get quranSyncConnectionErrorMessage =>
      'Couldn’t download the Quran. Please check your internet connection and try again.';

  @override
  String get surahListError => 'Could not load surahs';

  @override
  String get surahListTitle => 'Surahs';

  @override
  String get surahListSearchHint => 'Search surahs by name or number…';

  @override
  String get surahListSearchTooltip => 'Search surahs';

  @override
  String get surahListNoResults => 'No surahs match your search.';

  @override
  String get surahRevelationMakki => 'Makki';

  @override
  String get surahRevelationMadani => 'Madani';

  @override
  String readProgressLabel(int read, int total) {
    return '$read/$total read';
  }

  @override
  String get markSurahAsRead => 'Mark surah as read';

  @override
  String get readAyahHint =>
      'Long press an ayah to mark it as read. Double-tap an ayah to play audio.';

  @override
  String mushafPageNumber(int page) {
    return 'Page $page';
  }

  @override
  String get goToFlaggedAyah => 'Go to flagged ayah';

  @override
  String get removeFlag => 'Remove the flag';

  @override
  String ayahInsightAyahLabel(int number) {
    return 'Ayah $number';
  }

  @override
  String get ayahInsightMeaning => 'Meaning';

  @override
  String get ayahInsightWordByWord => 'Word by word';

  @override
  String get ayahInsightWordsError => 'Could not load word meanings';

  @override
  String get ayahInsightWordTransliteration => 'Transliteration';

  @override
  String get ayahInsightError => 'Could not load ayah meaning';

  @override
  String get ayahInsightPlayAudio => 'Play ayah audio';

  @override
  String get ayahInsightStory => 'Story';

  @override
  String get ayahInsightStoryLoading => 'Loading story ...';

  @override
  String get ayahInsightStoryAiHint =>
      'Explanation covering the reason for revelation, how it was revealed, and the miracle in the verse.';

  @override
  String get ayahInsightStoryRevelationReason => 'Reason for revelation';

  @override
  String get ayahInsightStoryHowRevealed =>
      'How it was revealed to the Prophet';

  @override
  String get ayahInsightStoryMiracle => 'Miracle in the verse';

  @override
  String get ayahInsightStoryError => 'Could not load the ayah story';

  @override
  String get ayahCountLabel => 'ayahs';

  @override
  String get playSurah => 'Play surah';

  @override
  String get pauseAudio => 'Pause';

  @override
  String get stopAudio => 'Stop';

  @override
  String audioAyahProgress(int current, int total) {
    return 'Ayah $current of $total';
  }

  @override
  String get previousAyah => 'Previous ayah';

  @override
  String get nextAyah => 'Next ayah';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get quranAudioUnavailable =>
      'Audio for this reciter is not available. Choose another reciter.';

  @override
  String get quranAudioNetworkError =>
      'Could not download ayah audio. Check your connection and try again.';

  @override
  String get quranAudioLoadError =>
      'Could not play ayah audio. Try again or choose another reciter.';

  @override
  String get quranAudioNextAyahDownloading =>
      'The next ayah is still downloading. Check your connection and tap play.';

  @override
  String get drawerAdhan => 'Adhan';

  @override
  String get drawerSurahs => 'Surahs';

  @override
  String get drawerJuz => 'Juz';

  @override
  String get juzListTitle => 'Juz';

  @override
  String juzSurahCountLabel(int count) {
    return '$count surahs';
  }

  @override
  String get drawerSettings => 'Settings';

  @override
  String get drawerQibla => 'Qibla';

  @override
  String get drawerNearbyMosques => 'Nearby Mosques';

  @override
  String get drawerNearbyMosquesLaunchError => 'Could not open maps.';

  @override
  String get nearbyMosquesTitle => 'Nearby Mosques';

  @override
  String get nearbyMosquesLoading => 'Finding nearby mosques…';

  @override
  String get nearbyMosquesError => 'Could not load nearby mosques.';

  @override
  String get nearbyMosquesRetry => 'Retry';

  @override
  String get nearbyMosquesEmpty => 'No nearby mosques found.';

  @override
  String nearbyMosquesDistanceMeters(int meters) {
    return '$meters m away';
  }

  @override
  String nearbyMosquesDistanceKm(String kilometers) {
    return '$kilometers km away';
  }

  @override
  String nearbyMosquesRouteTo(String mosque) {
    return 'Route to $mosque';
  }

  @override
  String get nearbyMosquesRouteHint =>
      'Follow the blue route line on the map to reach the mosque.';

  @override
  String get nearbyMosquesRouteFallbackHint =>
      'Showing direct path. Turn-by-turn route is currently unavailable.';

  @override
  String get nearbyMosquesRouteDurationUnknown => 'ETA unavailable';

  @override
  String nearbyMosquesRouteDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get drawerAsmaUlHusna => '99 Names of Allah';

  @override
  String get drawerSelectReciter => 'Quran reciter';

  @override
  String get drawerRecitersLoadError =>
      'Could not load reciters. Check your connection and try again.';

  @override
  String get asmaUlHusnaTitle => '99 Names of Allah';

  @override
  String get asmaUlHusnaSearchHint => 'Search by name or meaning…';

  @override
  String get asmaUlHusnaError => 'Could not load the names of Allah.';

  @override
  String get asmaUlHusnaNoResults => 'No names match your search.';

  @override
  String get asmaUlHusnaMeaningLabel => 'Meaning';

  @override
  String asmaUlHusnaNameNumber(int number) {
    return 'Name $number of 99';
  }

  @override
  String get drawerDuaa => 'Duaa';

  @override
  String get drawerHadith => 'Hadith';

  @override
  String get drawerTagline => 'Your companion for Quran & worship';

  @override
  String get drawerSectionQuran => 'Quran';

  @override
  String get drawerSectionWorship => 'Worship';

  @override
  String get drawerSectionKnowledge => 'Knowledge';

  @override
  String get hadithTitle => 'Hadith';

  @override
  String get hadithSearchHint => 'Search all collections…';

  @override
  String get hadithSectionsTitle => 'Sections';

  @override
  String get hadithBooksTitle => 'Books';

  @override
  String get hadithFilterCategoryHint => 'Filter in this section…';

  @override
  String get hadithSearchCollectionHint => 'Search this collection…';

  @override
  String get hadithError =>
      'Could not load hadith. Check your connection and try again.';

  @override
  String get hadithNoResults => 'No results match your search.';

  @override
  String hadithCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hadiths',
      one: '1 hadith',
    );
    return '$_temp0';
  }

  @override
  String hadithNumberLabel(int number) {
    return 'Hadith $number';
  }

  @override
  String get hadithSourceLabel => 'Source';

  @override
  String hadithSourceReference(String collection, int number) {
    return '$collection, $number';
  }

  @override
  String get hadithOpenDetailHint => 'Open hadith';

  @override
  String get duaaTitle => 'Duaa';

  @override
  String get duaaSearchCategoriesHint => 'Search categories…';

  @override
  String get duaaSearchDuasHint => 'Search duas…';

  @override
  String get duaaError =>
      'Could not load duas. Check your connection and try again.';

  @override
  String get duaaNoResults => 'No results match your search.';

  @override
  String duaaCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count duas',
      one: '1 dua',
    );
    return '$_temp0';
  }

  @override
  String get duaaSourceLabel => 'Source';

  @override
  String duaaRepeatLabel(int count) {
    return 'Repeat $count times';
  }

  @override
  String get qiblaTitle => 'Qibla';

  @override
  String get qiblaDescription =>
      'The direction of prayer is towards the Kaaba.';

  @override
  String get qiblaLoading => 'Finding your direction…';

  @override
  String get qiblaError => 'Could not determine the Qibla direction.';

  @override
  String get qiblaNoCompass => 'Your device does not have a compass sensor.';

  @override
  String get qiblaCompassPluginUnavailable =>
      'Live compass is not ready yet. Fully stop the app, then run it again from your IDE or terminal (hot reload is not enough after adding compass support).';

  @override
  String get qiblaStaticDirectionHint =>
      'The arrow shows the Qibla direction from north. Use a phone with a compass for live guidance.';

  @override
  String qiblaBearing(String degrees) {
    return '$degrees° from north';
  }

  @override
  String get qiblaAligned => 'You are facing the Qiblah';

  @override
  String qiblaOffset(String degrees) {
    return '$degrees° from Qiblah';
  }

  @override
  String qiblaDirection(String direction) {
    return 'Direction: $direction';
  }

  @override
  String qiblaDistance(String distance) {
    return '$distance km to Makkah';
  }

  @override
  String get qiblaHint =>
      'Hold your phone flat and rotate until the arrow points up.';

  @override
  String get compassNorth => 'North';

  @override
  String get compassNortheast => 'Northeast';

  @override
  String get compassEast => 'East';

  @override
  String get compassSoutheast => 'Southeast';

  @override
  String get compassSouth => 'South';

  @override
  String get compassSouthwest => 'Southwest';

  @override
  String get compassWest => 'West';

  @override
  String get compassNorthwest => 'Northwest';

  @override
  String get adhanTitle => 'Adhan';

  @override
  String get adhanLoading => 'Loading prayer times…';

  @override
  String get adhanError => 'Could not load prayer times.';

  @override
  String get adhanRetry => 'Retry';

  @override
  String get adhanOpenSettings => 'Open settings';

  @override
  String get adhanLocationDenied =>
      'Location permission is required to show prayer times for your city.';

  @override
  String get adhanLocationUnavailable =>
      'Location services are disabled. Enable them to show prayer times for your city.';

  @override
  String get adhanLocationPluginUnavailable =>
      'Location is not ready yet. Fully stop the app, then run it again from your IDE or terminal (hot reload is not enough after adding location support).';

  @override
  String get adhanLocationTimeout =>
      'Could not detect your location in time. Move to an open area, enable GPS, or set a mock location on the emulator and try again.';

  @override
  String get adhanToday => 'Today';

  @override
  String get adhanChangeCity => 'Change';

  @override
  String get adhanSearchCityTitle => 'Search city';

  @override
  String get adhanSearchCityHint => 'City or city, country';

  @override
  String get adhanSearchCityEmpty => 'No cities found. Try a different name.';

  @override
  String get adhanUseMyLocation => 'Use my current location';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerSunrise => 'Sunrise';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String adhanAlertSettingsTitle(String prayer) {
    return '$prayer reminder';
  }

  @override
  String get adhanAlertTimingSection => 'When to notify';

  @override
  String get adhanAlertOff => 'Off';

  @override
  String get adhanAlertBefore => 'Before';

  @override
  String get adhanAlertAtAdhan => 'At adhan';

  @override
  String get adhanAlertAfter => 'After';

  @override
  String get adhanAlertMinutesSection => 'How long';

  @override
  String adhanAlertMinutesLabel(int minutes) {
    return '$minutes min';
  }

  @override
  String adhanAlertMaxBeforeHint(int minutes, String prayer) {
    return 'Up to $minutes min before $prayer (not before the previous prayer)';
  }

  @override
  String adhanAlertMaxAfterHint(int minutes, String prayer) {
    return 'Up to $minutes min after $prayer (not after the next prayer)';
  }

  @override
  String get adhanAlertDeliverySection => 'Alert style';

  @override
  String get adhanAlertSound => 'Sound';

  @override
  String get adhanAlertVibrate => 'Vibrate';

  @override
  String get adhanAlertSave => 'Save';

  @override
  String adhanNotificationTitle(String prayer) {
    return '$prayer';
  }

  @override
  String adhanNotificationBodyBefore(int minutes, String prayer) {
    return '$minutes minutes until $prayer';
  }

  @override
  String adhanNotificationBodyAt(String prayer) {
    return 'It is time for $prayer';
  }

  @override
  String adhanNotificationBodyAfter(int minutes, String prayer) {
    return '$minutes minutes since $prayer';
  }

  @override
  String get adhanNotificationPermissionDenied =>
      'Notification permission is required for prayer reminders.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsThemeSection => 'Appearance';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsDarkMode => 'Dark mode';

  @override
  String get settingsSelectLanguage => 'Select language';

  @override
  String get settingsFontSizeSection => 'Text size';

  @override
  String get settingsAppFontSize => 'App font size';

  @override
  String get settingsQuranReaderFontSize => 'Quran reader font size';

  @override
  String settingsFontSizeValue(int percent) {
    return '$percent%';
  }

  @override
  String get settingsNotificationsSection => 'Notifications';

  @override
  String get settingsNotificationsEnabled => 'Enable notifications';

  @override
  String get settingsContactSection => 'Support';

  @override
  String get settingsReportBug => 'Report a bug';

  @override
  String get settingsReportBugDescription =>
      'Describe the issue and mark the screen. Your report is sent to our team.';

  @override
  String get settingsReportBugSuccess => 'Thank you — your report was sent.';

  @override
  String get settingsReportBugError =>
      'Could not send your report. Please try again.';

  @override
  String get settingsReportBugEmptyMessage =>
      'Please describe the issue before submitting.';

  @override
  String get settingsContactUs => 'Contact us';

  @override
  String get settingsContactUsError => 'Could not open contact page';

  @override
  String get settingsStorageSection => 'Storage';

  @override
  String get settingsClearCache => 'Clear cache';

  @override
  String get settingsClearCacheDescription =>
      'Remove downloaded audio, ayah meanings, and word meanings. They will load again when needed.';

  @override
  String get settingsClearCacheConfirmTitle => 'Clear cache?';

  @override
  String get settingsClearCacheConfirmMessage =>
      'Downloaded audio, ayah meanings, and word meanings will be removed from this device.';

  @override
  String get settingsClearCacheConfirmAction => 'Clear';

  @override
  String get settingsClearCacheCancel => 'Cancel';

  @override
  String get settingsClearCacheSuccess => 'Cache cleared.';

  @override
  String get settingsClearCacheError =>
      'Could not clear cache. Please try again.';
}
