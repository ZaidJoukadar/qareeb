import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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

  /// Sync progress label.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} surahs'**
  String quranSyncProgress(int completed, int total);

  /// Retry button on sync failure.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get quranSyncRetry;

  /// Error when surah list fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load surahs'**
  String get surahListError;

  /// Label for ayah count on surah list.
  ///
  /// In en, this message translates to:
  /// **'ayahs'**
  String get ayahCountLabel;

  /// Dismiss audio error banner.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;
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
      <String>['ar', 'en'].contains(locale.languageCode);

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
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
