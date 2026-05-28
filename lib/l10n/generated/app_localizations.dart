import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
    Locale('tr'),
  ];

  /// Application name shown in the app bar and system UI.
  ///
  /// In en, this message translates to:
  /// **'Qareeb'**
  String get appTitle;

  /// Title on the home placeholder screen body.
  ///
  /// In en, this message translates to:
  /// **'Qareeb Home'**
  String get homeTitle;

  /// Onboarding skip action.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Onboarding next page action.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Onboarding final action to enter the app.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Onboarding slide 1 title — commit to reading.
  ///
  /// In en, this message translates to:
  /// **'Begin Your Journey with the Quran'**
  String get onboardingSlide1Title;

  /// Onboarding slide 1 description.
  ///
  /// In en, this message translates to:
  /// **'Set your intention and build a daily habit of reading — one step at a time, closer to Allah.'**
  String get onboardingSlide1Description;

  /// Onboarding slide 2 title — understand meanings.
  ///
  /// In en, this message translates to:
  /// **'Understand Every Verse'**
  String get onboardingSlide2Title;

  /// Onboarding slide 2 description.
  ///
  /// In en, this message translates to:
  /// **'Explore clear meanings and tafsir so every ayah speaks to your heart and mind.'**
  String get onboardingSlide2Description;

  /// Onboarding slide 3 title — persevere on the path.
  ///
  /// In en, this message translates to:
  /// **'Stay Committed, Stay Close'**
  String get onboardingSlide3Title;

  /// Onboarding slide 3 description.
  ///
  /// In en, this message translates to:
  /// **'Reminders, progress, and gentle encouragement — we help you persevere on the path.'**
  String get onboardingSlide3Description;

  /// English language label in settings.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Arabic language label in settings.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// Turkish language label in settings.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get languageTurkish;

  /// Title on the Quran download/sync screen.
  ///
  /// In en, this message translates to:
  /// **'Preparing the Quran'**
  String get quranSyncTitle;

  /// Description on the Quran sync screen.
  ///
  /// In en, this message translates to:
  /// **'Downloading surahs and ayahs for offline reading. This may take a few minutes.'**
  String get quranSyncDescription;

  /// Sync progress shown as a percentage.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String quranSyncProgressPercent(int percent);

  /// Retry button on sync failure.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get quranSyncRetry;

  /// Title on the Quran sync connectivity error dialog.
  ///
  /// In en, this message translates to:
  /// **'Check your connection'**
  String get quranSyncConnectionErrorTitle;

  /// Message on the Quran sync connectivity error dialog.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t download the Quran. Please check your internet connection and try again.'**
  String get quranSyncConnectionErrorMessage;

  /// Error when surah list fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load surahs'**
  String get surahListError;

  /// Title on the surah list screen.
  ///
  /// In en, this message translates to:
  /// **'Surahs'**
  String get surahListTitle;

  /// Hint on the surah list search field.
  ///
  /// In en, this message translates to:
  /// **'Search surahs by name or number…'**
  String get surahListSearchHint;

  /// Tooltip for the surah list search action.
  ///
  /// In en, this message translates to:
  /// **'Search surahs'**
  String get surahListSearchTooltip;

  /// Empty state when surah search has no matches.
  ///
  /// In en, this message translates to:
  /// **'No surahs match your search.'**
  String get surahListNoResults;

  /// Label for surahs revealed in Mecca.
  ///
  /// In en, this message translates to:
  /// **'Makki'**
  String get surahRevelationMakki;

  /// Label for surahs revealed in Medina.
  ///
  /// In en, this message translates to:
  /// **'Madani'**
  String get surahRevelationMadani;

  /// Read ayah progress for a surah.
  ///
  /// In en, this message translates to:
  /// **'{read}/{total} read'**
  String readProgressLabel(int read, int total);

  /// Marks every ayah in the current surah as read.
  ///
  /// In en, this message translates to:
  /// **'Mark surah as read'**
  String get markSurahAsRead;

  /// Hint shown above the mushaf reader.
  ///
  /// In en, this message translates to:
  /// **'Long press an ayah to mark it as read. Double-tap an ayah to play audio.'**
  String get readAyahHint;

  /// Current mushaf page number in the book reader.
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String mushafPageNumber(int page);

  /// Tooltip for the FAB that jumps to the last flagged ayah.
  ///
  /// In en, this message translates to:
  /// **'Go to flagged ayah'**
  String get goToFlaggedAyah;

  /// Ayah number label in the insight dialog title.
  ///
  /// In en, this message translates to:
  /// **'Ayah {number}'**
  String ayahInsightAyahLabel(int number);

  /// Section title for the overall ayah meaning in the insight dialog.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get ayahInsightMeaning;

  /// Error when ayah insight fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load ayah meaning'**
  String get ayahInsightError;

  /// Tooltip for the play button in the ayah insight dialog.
  ///
  /// In en, this message translates to:
  /// **'Play ayah audio'**
  String get ayahInsightPlayAudio;

  /// Button label to open the ayah story bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get ayahInsightStory;

  /// Loading message while AI generates the ayah story.
  ///
  /// In en, this message translates to:
  /// **'Loading story ...'**
  String get ayahInsightStoryLoading;

  /// Hint shown above the AI-generated ayah story.
  ///
  /// In en, this message translates to:
  /// **'Explanation covering the reason for revelation, how it was revealed, and the miracle in the verse.'**
  String get ayahInsightStoryAiHint;

  /// Section title for why the ayah was revealed.
  ///
  /// In en, this message translates to:
  /// **'Reason for revelation'**
  String get ayahInsightStoryRevelationReason;

  /// Section title for the manner of revelation to the Prophet.
  ///
  /// In en, this message translates to:
  /// **'How it was revealed to the Prophet'**
  String get ayahInsightStoryHowRevealed;

  /// Section title for the miracle or sign in the ayah.
  ///
  /// In en, this message translates to:
  /// **'Miracle in the verse'**
  String get ayahInsightStoryMiracle;

  /// Error when ayah story fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load the ayah story'**
  String get ayahInsightStoryError;

  /// Label for ayah count on surah list.
  ///
  /// In en, this message translates to:
  /// **'ayahs'**
  String get ayahCountLabel;

  /// Play audio for the surah from the current page.
  ///
  /// In en, this message translates to:
  /// **'Play surah'**
  String get playSurah;

  /// Pause surah audio playback.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseAudio;

  /// Stop surah audio playback.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopAudio;

  /// Current ayah progress in the audio player bar.
  ///
  /// In en, this message translates to:
  /// **'Ayah {current} of {total}'**
  String audioAyahProgress(int current, int total);

  /// Skip to the previous ayah in the audio player.
  ///
  /// In en, this message translates to:
  /// **'Previous ayah'**
  String get previousAyah;

  /// Skip to the next ayah in the audio player.
  ///
  /// In en, this message translates to:
  /// **'Next ayah'**
  String get nextAyah;

  /// Dismiss audio error banner.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// Drawer menu item for prayer times and adhan.
  ///
  /// In en, this message translates to:
  /// **'Adhan'**
  String get drawerAdhan;

  /// Drawer menu item for the surah list.
  ///
  /// In en, this message translates to:
  /// **'Surahs'**
  String get drawerSurahs;

  /// Drawer menu item for the juz list.
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get drawerJuz;

  /// Title on the juz list screen.
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get juzListTitle;

  /// Subtitle on the juz list showing how many surahs are in the juz.
  ///
  /// In en, this message translates to:
  /// **'{count} surahs'**
  String juzSurahCountLabel(int count);

  /// Drawer menu item for app settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettings;

  /// Drawer menu item for the Qibla compass.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get drawerQibla;

  /// Drawer menu item that opens nearby mosques in maps.
  ///
  /// In en, this message translates to:
  /// **'Nearby Mosques'**
  String get drawerNearbyMosques;

  /// Shown when opening nearby mosques in maps fails.
  ///
  /// In en, this message translates to:
  /// **'Could not open maps.'**
  String get drawerNearbyMosquesLaunchError;

  /// Title of the in-app nearby mosques map and list screen.
  ///
  /// In en, this message translates to:
  /// **'Nearby Mosques'**
  String get nearbyMosquesTitle;

  /// Loading state while fetching nearby mosques.
  ///
  /// In en, this message translates to:
  /// **'Finding nearby mosques…'**
  String get nearbyMosquesLoading;

  /// Error state when nearby mosques cannot be loaded.
  ///
  /// In en, this message translates to:
  /// **'Could not load nearby mosques.'**
  String get nearbyMosquesError;

  /// Retry button for nearby mosques loading.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get nearbyMosquesRetry;

  /// Empty state when no mosques are returned near the user.
  ///
  /// In en, this message translates to:
  /// **'No nearby mosques found.'**
  String get nearbyMosquesEmpty;

  /// Distance label in meters for a mosque.
  ///
  /// In en, this message translates to:
  /// **'{meters} m away'**
  String nearbyMosquesDistanceMeters(int meters);

  /// Distance label in kilometers for a mosque.
  ///
  /// In en, this message translates to:
  /// **'{kilometers} km away'**
  String nearbyMosquesDistanceKm(String kilometers);

  /// Route summary title for selected mosque.
  ///
  /// In en, this message translates to:
  /// **'Route to {mosque}'**
  String nearbyMosquesRouteTo(String mosque);

  /// Hint instructing user to follow the route line.
  ///
  /// In en, this message translates to:
  /// **'Follow the blue route line on the map to reach the mosque.'**
  String get nearbyMosquesRouteHint;

  /// Shown when route service is unavailable and app falls back to direct line.
  ///
  /// In en, this message translates to:
  /// **'Showing direct path. Turn-by-turn route is currently unavailable.'**
  String get nearbyMosquesRouteFallbackHint;

  /// Shown when route duration cannot be calculated.
  ///
  /// In en, this message translates to:
  /// **'ETA unavailable'**
  String get nearbyMosquesRouteDurationUnknown;

  /// Estimated route duration in minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String nearbyMosquesRouteDurationMinutes(int minutes);

  /// Drawer menu item for Asma ul Husna.
  ///
  /// In en, this message translates to:
  /// **'99 Names of Allah'**
  String get drawerAsmaUlHusna;

  /// Drawer menu item to choose audio recitation edition.
  ///
  /// In en, this message translates to:
  /// **'Quran reciter'**
  String get drawerSelectReciter;

  /// Error when the audio reciter list fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load reciters. Check your connection and try again.'**
  String get drawerRecitersLoadError;

  /// Title on the Asma ul Husna screen.
  ///
  /// In en, this message translates to:
  /// **'99 Names of Allah'**
  String get asmaUlHusnaTitle;

  /// Placeholder for the Asma ul Husna search field.
  ///
  /// In en, this message translates to:
  /// **'Search by name or meaning…'**
  String get asmaUlHusnaSearchHint;

  /// Error message when Asma ul Husna fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load the names of Allah.'**
  String get asmaUlHusnaError;

  /// Empty state when search has no matches.
  ///
  /// In en, this message translates to:
  /// **'No names match your search.'**
  String get asmaUlHusnaNoResults;

  /// Label above the meaning text in the name detail sheet.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get asmaUlHusnaMeaningLabel;

  /// Label showing the position of a divine name.
  ///
  /// In en, this message translates to:
  /// **'Name {number} of 99'**
  String asmaUlHusnaNameNumber(int number);

  /// Drawer menu item for supplications.
  ///
  /// In en, this message translates to:
  /// **'Duaa'**
  String get drawerDuaa;

  /// Drawer menu item for hadith collections.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get drawerHadith;

  /// Short subtitle under the app name in the navigation drawer header.
  ///
  /// In en, this message translates to:
  /// **'Your companion for Quran & worship'**
  String get drawerTagline;

  /// Section label in the drawer for Quran-related destinations.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get drawerSectionQuran;

  /// Section label in the drawer for prayer and Qibla.
  ///
  /// In en, this message translates to:
  /// **'Worship'**
  String get drawerSectionWorship;

  /// Section label in the drawer for duas, hadith, and names of Allah.
  ///
  /// In en, this message translates to:
  /// **'Knowledge'**
  String get drawerSectionKnowledge;

  /// Title on the hadith collections screen.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get hadithTitle;

  /// Placeholder for global hadith search on collections screen.
  ///
  /// In en, this message translates to:
  /// **'Search all collections…'**
  String get hadithSearchHint;

  /// Header for themed hadith categories on the main hadith screen.
  ///
  /// In en, this message translates to:
  /// **'Sections'**
  String get hadithSectionsTitle;

  /// Header for hadith books (Bukhari, Muslim, etc.).
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get hadithBooksTitle;

  /// Placeholder for filtering loaded hadiths within a category.
  ///
  /// In en, this message translates to:
  /// **'Filter in this section…'**
  String get hadithFilterCategoryHint;

  /// Placeholder for hadith search within one collection.
  ///
  /// In en, this message translates to:
  /// **'Search this collection…'**
  String get hadithSearchCollectionHint;

  /// Error message when hadith fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load hadith. Check your connection and try again.'**
  String get hadithError;

  /// Empty state when hadith search has no matches.
  ///
  /// In en, this message translates to:
  /// **'No results match your search.'**
  String get hadithNoResults;

  /// Subtitle showing how many hadiths are in a collection.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hadith} other{{count} hadiths}}'**
  String hadithCountLabel(int count);

  /// Title for a hadith detail sheet showing its number.
  ///
  /// In en, this message translates to:
  /// **'Hadith {number}'**
  String hadithNumberLabel(int number);

  /// Label above the hadith source reference.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get hadithSourceLabel;

  /// Hadith book name and number in the detail sheet.
  ///
  /// In en, this message translates to:
  /// **'{collection}, {number}'**
  String hadithSourceReference(String collection, int number);

  /// Accessibility hint for opening a hadith from the list.
  ///
  /// In en, this message translates to:
  /// **'Open hadith'**
  String get hadithOpenDetailHint;

  /// Title on the Duaa categories screen.
  ///
  /// In en, this message translates to:
  /// **'Duaa'**
  String get duaaTitle;

  /// Placeholder for the Duaa category search field.
  ///
  /// In en, this message translates to:
  /// **'Search categories…'**
  String get duaaSearchCategoriesHint;

  /// Placeholder for the Duaa search field within a category.
  ///
  /// In en, this message translates to:
  /// **'Search duas…'**
  String get duaaSearchDuasHint;

  /// Error message when Duaa fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load duas. Check your connection and try again.'**
  String get duaaError;

  /// Empty state when Duaa search has no matches.
  ///
  /// In en, this message translates to:
  /// **'No results match your search.'**
  String get duaaNoResults;

  /// Subtitle showing how many duas are in a category.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 dua} other{{count} duas}}'**
  String duaaCountLabel(int count);

  /// Label above the hadith source in the dua detail sheet.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get duaaSourceLabel;

  /// Label showing how many times to repeat a dua.
  ///
  /// In en, this message translates to:
  /// **'Repeat {count} times'**
  String duaaRepeatLabel(int count);

  /// Title on the Qibla compass screen.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get qiblaTitle;

  /// Subtitle explaining the purpose of the Qibla screen.
  ///
  /// In en, this message translates to:
  /// **'The direction of prayer is towards the Kaaba.'**
  String get qiblaDescription;

  /// Loading message on the Qibla screen.
  ///
  /// In en, this message translates to:
  /// **'Finding your direction…'**
  String get qiblaLoading;

  /// Generic error on the Qibla screen.
  ///
  /// In en, this message translates to:
  /// **'Could not determine the Qibla direction.'**
  String get qiblaError;

  /// Error when the device lacks a magnetometer.
  ///
  /// In en, this message translates to:
  /// **'Your device does not have a compass sensor.'**
  String get qiblaNoCompass;

  /// Error when the compass native plugin is not linked into the running app.
  ///
  /// In en, this message translates to:
  /// **'Live compass is not ready yet. Fully stop the app, then run it again from your IDE or terminal (hot reload is not enough after adding compass support).'**
  String get qiblaCompassPluginUnavailable;

  /// Hint when only static Qibla bearing is shown.
  ///
  /// In en, this message translates to:
  /// **'The arrow shows the Qibla direction from north. Use a phone with a compass for live guidance.'**
  String get qiblaStaticDirectionHint;

  /// Absolute Qibla bearing from true north.
  ///
  /// In en, this message translates to:
  /// **'{degrees}° from north'**
  String qiblaBearing(String degrees);

  /// Shown when the device is aligned with the Qibla.
  ///
  /// In en, this message translates to:
  /// **'You are facing the Qiblah'**
  String get qiblaAligned;

  /// Degrees off from the Qibla direction.
  ///
  /// In en, this message translates to:
  /// **'{degrees}° from Qiblah'**
  String qiblaOffset(String degrees);

  /// Cardinal direction towards the Kaaba.
  ///
  /// In en, this message translates to:
  /// **'Direction: {direction}'**
  String qiblaDirection(String direction);

  /// Great-circle distance to Makkah.
  ///
  /// In en, this message translates to:
  /// **'{distance} km to Makkah'**
  String qiblaDistance(String distance);

  /// Usage hint on the Qibla compass screen.
  ///
  /// In en, this message translates to:
  /// **'Hold your phone flat and rotate until the arrow points up.'**
  String get qiblaHint;

  /// Compass direction north.
  ///
  /// In en, this message translates to:
  /// **'North'**
  String get compassNorth;

  /// Compass direction northeast.
  ///
  /// In en, this message translates to:
  /// **'Northeast'**
  String get compassNortheast;

  /// Compass direction east.
  ///
  /// In en, this message translates to:
  /// **'East'**
  String get compassEast;

  /// Compass direction southeast.
  ///
  /// In en, this message translates to:
  /// **'Southeast'**
  String get compassSoutheast;

  /// Compass direction south.
  ///
  /// In en, this message translates to:
  /// **'South'**
  String get compassSouth;

  /// Compass direction southwest.
  ///
  /// In en, this message translates to:
  /// **'Southwest'**
  String get compassSouthwest;

  /// Compass direction west.
  ///
  /// In en, this message translates to:
  /// **'West'**
  String get compassWest;

  /// Compass direction northwest.
  ///
  /// In en, this message translates to:
  /// **'Northwest'**
  String get compassNorthwest;

  /// Title on the adhan screen.
  ///
  /// In en, this message translates to:
  /// **'Adhan'**
  String get adhanTitle;

  /// Loading message on the adhan screen.
  ///
  /// In en, this message translates to:
  /// **'Loading prayer times…'**
  String get adhanLoading;

  /// Generic error on the adhan screen.
  ///
  /// In en, this message translates to:
  /// **'Could not load prayer times.'**
  String get adhanError;

  /// Retry button on the adhan screen.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get adhanRetry;

  /// Opens app settings when location permission is denied.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get adhanOpenSettings;

  /// Error when location permission is denied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to show prayer times for your city.'**
  String get adhanLocationDenied;

  /// Error when device location services are off.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Enable them to show prayer times for your city.'**
  String get adhanLocationUnavailable;

  /// Error when the geolocator native plugin is not linked into the running app.
  ///
  /// In en, this message translates to:
  /// **'Location is not ready yet. Fully stop the app, then run it again from your IDE or terminal (hot reload is not enough after adding location support).'**
  String get adhanLocationPluginUnavailable;

  /// Error when GPS location request times out.
  ///
  /// In en, this message translates to:
  /// **'Could not detect your location in time. Move to an open area, enable GPS, or set a mock location on the emulator and try again.'**
  String get adhanLocationTimeout;

  /// Label for today's prayer times card.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get adhanToday;

  /// Button to change the selected city on the adhan screen.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get adhanChangeCity;

  /// Title for the city search sheet.
  ///
  /// In en, this message translates to:
  /// **'Search city'**
  String get adhanSearchCityTitle;

  /// Hint text in the city search field.
  ///
  /// In en, this message translates to:
  /// **'City or city, country'**
  String get adhanSearchCityHint;

  /// Message when city search returns no results.
  ///
  /// In en, this message translates to:
  /// **'No cities found. Try a different name.'**
  String get adhanSearchCityEmpty;

  /// Option to load prayer times from device GPS.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get adhanUseMyLocation;

  /// Fajr prayer name.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// Sunrise time label.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get prayerSunrise;

  /// Dhuhr prayer name.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// Asr prayer name.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// Maghrib prayer name.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// Isha prayer name.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// Title on the per-prayer alert settings sheet.
  ///
  /// In en, this message translates to:
  /// **'{prayer} reminder'**
  String adhanAlertSettingsTitle(String prayer);

  /// Section label for alert timing options.
  ///
  /// In en, this message translates to:
  /// **'When to notify'**
  String get adhanAlertTimingSection;

  /// Option to disable prayer alerts.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get adhanAlertOff;

  /// Notify before the adhan time.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get adhanAlertBefore;

  /// Notify exactly at adhan time.
  ///
  /// In en, this message translates to:
  /// **'At adhan'**
  String get adhanAlertAtAdhan;

  /// Notify after the adhan time.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get adhanAlertAfter;

  /// Section label for alert offset duration.
  ///
  /// In en, this message translates to:
  /// **'How long'**
  String get adhanAlertMinutesSection;

  /// Minute option chip for prayer alert offset.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String adhanAlertMinutesLabel(int minutes);

  /// Explains the maximum allowed before offset for a prayer.
  ///
  /// In en, this message translates to:
  /// **'Up to {minutes} min before {prayer} (not before the previous prayer)'**
  String adhanAlertMaxBeforeHint(int minutes, String prayer);

  /// Explains the maximum allowed after offset for a prayer.
  ///
  /// In en, this message translates to:
  /// **'Up to {minutes} min after {prayer} (not after the next prayer)'**
  String adhanAlertMaxAfterHint(int minutes, String prayer);

  /// Section label for sound vs vibrate.
  ///
  /// In en, this message translates to:
  /// **'Alert style'**
  String get adhanAlertDeliverySection;

  /// Play sound for prayer alert.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get adhanAlertSound;

  /// Vibrate for prayer alert.
  ///
  /// In en, this message translates to:
  /// **'Vibrate'**
  String get adhanAlertVibrate;

  /// Save prayer alert settings.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get adhanAlertSave;

  /// Notification title for a prayer alert.
  ///
  /// In en, this message translates to:
  /// **'{prayer}'**
  String adhanNotificationTitle(String prayer);

  /// Notification body when alerting before adhan.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes until {prayer}'**
  String adhanNotificationBodyBefore(int minutes, String prayer);

  /// Notification body when alerting at adhan time.
  ///
  /// In en, this message translates to:
  /// **'It is time for {prayer}'**
  String adhanNotificationBodyAt(String prayer);

  /// Notification body when alerting after adhan.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes since {prayer}'**
  String adhanNotificationBodyAfter(int minutes, String prayer);

  /// Snackbar when notification permission is denied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission is required for prayer reminders.'**
  String get adhanNotificationPermissionDenied;

  /// Title on the settings screen.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Section header for language selection in settings.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSection;

  /// Section header for theme selection in settings.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsThemeSection;

  /// Light theme option in settings.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// Dark theme option in settings.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// Toggle label for enabling dark theme.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settingsDarkMode;

  /// Title on the language picker bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get settingsSelectLanguage;

  /// Section header for font size settings.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get settingsFontSizeSection;

  /// Slider label for app and Quran reader text size.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get settingsFontSize;

  /// Current font size percentage shown next to a slider.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String settingsFontSizeValue(int percent);

  /// Section header for notification settings.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsSection;

  /// Toggle label to enable push notifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get settingsNotificationsEnabled;

  /// Section header for support options.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsContactSection;

  /// Opens in-app feedback UI that uploads to Sentry.
  ///
  /// In en, this message translates to:
  /// **'Report a bug'**
  String get settingsReportBug;

  /// Subtitle for the report-a-bug settings row.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue and mark the screen. Your report is sent to our team.'**
  String get settingsReportBugDescription;

  /// Snackbar after bug report is uploaded to Sentry.
  ///
  /// In en, this message translates to:
  /// **'Thank you — your report was sent.'**
  String get settingsReportBugSuccess;

  /// Snackbar when Sentry feedback upload fails.
  ///
  /// In en, this message translates to:
  /// **'Could not send your report. Please try again.'**
  String get settingsReportBugError;

  /// Snackbar when user submits feedback without a message.
  ///
  /// In en, this message translates to:
  /// **'Please describe the issue before submitting.'**
  String get settingsReportBugEmptyMessage;

  /// Opens the support contact page.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get settingsContactUs;

  /// Snackbar when the contact URL fails to open.
  ///
  /// In en, this message translates to:
  /// **'Could not open contact page'**
  String get settingsContactUsError;

  /// Section header for storage and cache settings.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get settingsStorageSection;

  /// Settings row that deletes downloaded Quran audio files.
  ///
  /// In en, this message translates to:
  /// **'Clear audio cache'**
  String get settingsClearCache;

  /// Subtitle for the clear audio cache settings row.
  ///
  /// In en, this message translates to:
  /// **'Remove downloaded recitation audio. Files will download again when you play them.'**
  String get settingsClearCacheDescription;

  /// Title on the confirmation dialog before clearing audio cache.
  ///
  /// In en, this message translates to:
  /// **'Clear audio cache?'**
  String get settingsClearCacheConfirmTitle;

  /// Body text on the confirmation dialog before clearing audio cache.
  ///
  /// In en, this message translates to:
  /// **'Downloaded recitation audio will be removed from this device.'**
  String get settingsClearCacheConfirmMessage;

  /// Confirm button on the clear audio cache dialog.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get settingsClearCacheConfirmAction;

  /// Cancel button on the clear audio cache dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsClearCacheCancel;

  /// Snackbar after audio cache is cleared successfully.
  ///
  /// In en, this message translates to:
  /// **'Audio cache cleared.'**
  String get settingsClearCacheSuccess;

  /// Snackbar when clearing audio cache fails.
  ///
  /// In en, this message translates to:
  /// **'Could not clear audio cache. Please try again.'**
  String get settingsClearCacheError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
