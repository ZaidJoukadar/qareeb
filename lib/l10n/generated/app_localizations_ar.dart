// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'قريب';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get onboardingSlide1Title => 'ابدأ رحلتك مع القرآن';

  @override
  String get onboardingSlide1Description =>
      'اضبط نيتك وابنِ عادة يومية للقراءة خطوة بخطوة، أقرب إلى الله.';

  @override
  String get onboardingSlide2Title => 'افهم كل آية';

  @override
  String get onboardingSlide2Description =>
      'استكشف المعاني والتفسير بوضوح حتى تتكلم كل آية إلى قلبك وعقلك.';

  @override
  String get onboardingSlide3Title => 'اثبت وابقَ قريبًا';

  @override
  String get onboardingSlide3Description =>
      'تذكيرات وتقدم وتشجيع لطيف — نساعدك على الثبات في الطريق.';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageTurkish => 'التركية';

  @override
  String get quranSyncTitle => 'جاري تنزيل القرآن';

  @override
  String get quranSyncDescription =>
      'يتم تنزيل السور والآيات للقراءة دون اتصال. قد يستغرق ذلك بضع دقائق.';

  @override
  String quranSyncProgressPercent(int percent) {
    return '$percent٪';
  }

  @override
  String get quranSyncRetry => 'إعادة المحاولة';

  @override
  String get quranSyncConnectionErrorTitle => 'تحقق من الاتصال';

  @override
  String get quranSyncConnectionErrorMessage =>
      'تعذر تنزيل القرآن بسبب مشكلة في الاتصال. يُرجى التحقق من اتصالك وإعادة المحاولة.';

  @override
  String get surahListError => 'تعذر تحميل السور';

  @override
  String get surahListTitle => 'السور';

  @override
  String get surahListSearchHint => 'ابحث عن سورة بالاسم أو الرقم…';

  @override
  String get surahListSearchTooltip => 'بحث السور';

  @override
  String get surahListNoResults => 'لا توجد سور مطابقة لبحثك.';

  @override
  String get surahRevelationMakki => 'مكية';

  @override
  String get surahRevelationMadani => 'مدنية';

  @override
  String readProgressLabel(int read, int total) {
    return '$read/$total مقروءة';
  }

  @override
  String get markSurahAsRead => 'تعليم السورة كمقروءة';

  @override
  String get readAyahHint =>
      'اضغط مطولًا على الآية لتعليمها كمقروءة. اضغط مرتين على الآية لتشغيل الصوت.';

  @override
  String mushafPageNumber(int page) {
    return 'صفحة $page';
  }

  @override
  String get goToFlaggedAyah => 'الانتقال إلى الآية المعلّمة';

  @override
  String get removeFlag => 'إزالة العلامة';

  @override
  String ayahInsightAyahLabel(int number) {
    return 'آية $number';
  }

  @override
  String get ayahInsightMeaning => 'المعنى';

  @override
  String get ayahInsightWordByWord => 'كلمة بكلمة';

  @override
  String get ayahInsightWordsError => 'تعذر تحميل معاني الكلمات';

  @override
  String get ayahInsightWordTransliteration => 'التهجئة';

  @override
  String get ayahInsightError => 'تعذر تحميل معنى الآية';

  @override
  String get ayahInsightPlayAudio => 'تشغيل صوت الآية';

  @override
  String get ayahInsightStory => 'القصة';

  @override
  String get ayahInsightStoryLoading => 'جاري تحميل القصة';

  @override
  String get ayahInsightStoryAiHint =>
      'شرح الاية يتضمن سبب النزول، وكيفية النزول، والمعجزة في الآية.';

  @override
  String get ayahInsightStoryRevelationReason => 'سبب نزول الآية';

  @override
  String get ayahInsightStoryHowRevealed => 'كيف نزلت على النبي ﷺ';

  @override
  String get ayahInsightStoryMiracle => 'المعجزة في الآية';

  @override
  String get ayahInsightStoryError => 'تعذر تحميل قصة الآية';

  @override
  String get ayahCountLabel => 'آيات';

  @override
  String get playSurah => 'تشغيل السورة';

  @override
  String get pauseAudio => 'إيقاف مؤقت';

  @override
  String get stopAudio => 'إيقاف';

  @override
  String audioAyahProgress(int current, int total) {
    return 'الآية $current من $total';
  }

  @override
  String get previousAyah => 'الآية السابقة';

  @override
  String get nextAyah => 'الآية التالية';

  @override
  String get dismiss => 'إغلاق';

  @override
  String get quranAudioUnavailable =>
      'تسجيل هذا القارئ غير متاح. اختر قارئاً آخر.';

  @override
  String get quranAudioNetworkError =>
      'تعذر تنزيل صوت الآية. تحقق من الاتصال وحاول مرة أخرى.';

  @override
  String get quranAudioLoadError =>
      'تعذر تشغيل صوت الآية. حاول مرة أخرى أو اختر قارئاً آخر.';

  @override
  String get quranAudioNextAyahDownloading =>
      'الآية التالية ما زالت قيد التنزيل. تحقق من الاتصال واضغط تشغيل.';

  @override
  String get drawerAdhan => 'الأذان';

  @override
  String get drawerSurahs => 'السور';

  @override
  String get drawerJuz => 'الأجزاء';

  @override
  String get juzListTitle => 'الأجزاء';

  @override
  String juzSurahCountLabel(int count) {
    return '$count سورة';
  }

  @override
  String get drawerSettings => 'الإعدادات';

  @override
  String get drawerQibla => 'القبلة';

  @override
  String get drawerNearbyMosques => 'المساجد القريبة';

  @override
  String get drawerNearbyMosquesLaunchError => 'تعذر فتح الخرائط.';

  @override
  String get nearbyMosquesTitle => 'المساجد القريبة';

  @override
  String get nearbyMosquesLoading => 'جاري العثور على المساجد القريبة…';

  @override
  String get nearbyMosquesError => 'تعذر تحميل المساجد القريبة.';

  @override
  String get nearbyMosquesRetry => 'إعادة المحاولة';

  @override
  String get nearbyMosquesEmpty => 'لم يتم العثور على مساجد قريبة.';

  @override
  String nearbyMosquesDistanceMeters(int meters) {
    return 'يبعد $meters م';
  }

  @override
  String nearbyMosquesDistanceKm(String kilometers) {
    return 'يبعد $kilometers كم';
  }

  @override
  String nearbyMosquesRouteTo(String mosque) {
    return 'المسار إلى $mosque';
  }

  @override
  String get nearbyMosquesRouteHint =>
      'اتبع الخط الأزرق على الخريطة للوصول إلى المسجد.';

  @override
  String get nearbyMosquesRouteFallbackHint =>
      'يتم عرض المسار المباشر فقط حالياً. تعذر تحميل مسار خطوة بخطوة.';

  @override
  String get nearbyMosquesRouteDurationUnknown => 'الوقت المتوقع غير متاح';

  @override
  String nearbyMosquesRouteDurationMinutes(int minutes) {
    return '$minutes د';
  }

  @override
  String get drawerAsmaUlHusna => 'أسماء الله الحسنى';

  @override
  String get drawerSelectReciter => 'قارئ القرآن';

  @override
  String get drawerRecitersLoadError =>
      'تعذّر تحميل قائمة القرّاء. تحقق من الاتصال وحاول مرة أخرى.';

  @override
  String get asmaUlHusnaTitle => 'أسماء الله الحسنى';

  @override
  String get asmaUlHusnaSearchHint => 'ابحث بالاسم أو المعنى…';

  @override
  String get asmaUlHusnaError => 'تعذّر تحميل أسماء الله الحسنى.';

  @override
  String get asmaUlHusnaNoResults => 'لا توجد أسماء مطابقة لبحثك.';

  @override
  String get asmaUlHusnaMeaningLabel => 'المعنى';

  @override
  String asmaUlHusnaNameNumber(int number) {
    return 'الاسم $number من ٩٩';
  }

  @override
  String get drawerDuaa => 'الأدعية';

  @override
  String get drawerHadith => 'الأحاديث';

  @override
  String get drawerTagline => 'رفيقك في القرآن والعبادة';

  @override
  String get drawerSectionQuran => 'القرآن';

  @override
  String get drawerSectionWorship => 'العبادة';

  @override
  String get drawerSectionKnowledge => 'المعرفة';

  @override
  String get hadithTitle => 'الأحاديث';

  @override
  String get hadithSearchHint => 'ابحث في جميع الكتب…';

  @override
  String get hadithSectionsTitle => 'الأقسام';

  @override
  String get hadithBooksTitle => 'الكتب';

  @override
  String get hadithFilterCategoryHint => 'تصفية في هذا القسم…';

  @override
  String get hadithSearchCollectionHint => 'ابحث في هذا الكتاب…';

  @override
  String get hadithError =>
      'تعذّر تحميل الأحاديث. تحقق من الاتصال وحاول مرة أخرى.';

  @override
  String get hadithNoResults => 'لا توجد نتائج مطابقة لبحثك.';

  @override
  String hadithCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حديث',
      one: 'حديث واحد',
    );
    return '$_temp0';
  }

  @override
  String hadithNumberLabel(int number) {
    return 'حديث $number';
  }

  @override
  String get hadithSourceLabel => 'المصدر';

  @override
  String hadithSourceReference(String collection, int number) {
    return '$collection، $number';
  }

  @override
  String get hadithOpenDetailHint => 'فتح الحديث';

  @override
  String get duaaTitle => 'الأدعية';

  @override
  String get duaaSearchCategoriesHint => 'ابحث في التصنيفات…';

  @override
  String get duaaSearchDuasHint => 'ابحث في الأدعية…';

  @override
  String get duaaError =>
      'تعذّر تحميل الأدعية. تحقق من الاتصال وحاول مرة أخرى.';

  @override
  String get duaaNoResults => 'لا توجد نتائج مطابقة لبحثك.';

  @override
  String duaaCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أدعية',
      one: 'دعاء واحد',
    );
    return '$_temp0';
  }

  @override
  String get duaaSourceLabel => 'المصدر';

  @override
  String duaaRepeatLabel(int count) {
    return 'يُكرَّر $count مرات';
  }

  @override
  String get qiblaTitle => 'القبلة';

  @override
  String get qiblaDescription => 'اتجاه الصلاة نحو الكعبة المشرفة.';

  @override
  String get qiblaLoading => 'جاري تحديد اتجاهك…';

  @override
  String get qiblaError => 'تعذّر تحديد اتجاه القبلة.';

  @override
  String get qiblaNoCompass => 'جهازك لا يحتوي على مستشعر بوصلة.';

  @override
  String get qiblaCompassPluginUnavailable =>
      'البوصلة الحية غير جاهزة بعد. أغلق التطبيق بالكامل ثم شغّله من جديد من المحرر أو الطرفية (إعادة التحميل السريع لا تكفي بعد إضافة دعم البوصلة).';

  @override
  String get qiblaStaticDirectionHint =>
      'السهم يوضح اتجاه القبلة من الشمال. استخدم هاتفًا يحتوي على بوصلة للتوجيه المباشر.';

  @override
  String qiblaBearing(String degrees) {
    return '$degrees° من الشمال';
  }

  @override
  String get qiblaAligned => 'أنت في اتجاه القبلة';

  @override
  String qiblaOffset(String degrees) {
    return '$degrees° عن القبلة';
  }

  @override
  String qiblaDirection(String direction) {
    return 'الاتجاه: $direction';
  }

  @override
  String qiblaDistance(String distance) {
    return '$distance كم إلى مكة';
  }

  @override
  String get qiblaHint =>
      'أمسك هاتفك بشكل مسطح واستدر حتى يشير السهم إلى الأعلى.';

  @override
  String get compassNorth => 'شمال';

  @override
  String get compassNortheast => 'شمال شرق';

  @override
  String get compassEast => 'شرق';

  @override
  String get compassSoutheast => 'جنوب شرق';

  @override
  String get compassSouth => 'جنوب';

  @override
  String get compassSouthwest => 'جنوب غرب';

  @override
  String get compassWest => 'غرب';

  @override
  String get compassNorthwest => 'شمال غرب';

  @override
  String get adhanTitle => 'الأذان';

  @override
  String get adhanLoading => 'جاري تحميل مواقيت الصلاة…';

  @override
  String get adhanError => 'تعذر تحميل مواقيت الصلاة.';

  @override
  String get adhanRetry => 'إعادة المحاولة';

  @override
  String get adhanOpenSettings => 'فتح الإعدادات';

  @override
  String get adhanLocationDenied =>
      'يلزم إذن الموقع لعرض مواقيت الصلاة لمدينتك.';

  @override
  String get adhanLocationUnavailable =>
      'خدمات الموقع معطّلة. فعّلها لعرض مواقيت الصلاة لمدينتك.';

  @override
  String get adhanLocationPluginUnavailable =>
      'خدمة الموقع غير جاهزة بعد. أغلق التطبيق بالكامل ثم شغّله من جديد من المحرر أو الطرفية (إعادة التحميل السريع لا تكفي بعد إضافة دعم الموقع).';

  @override
  String get adhanLocationTimeout =>
      'تعذّر تحديد موقعك في الوقت المحدد. انتقل إلى مكان مفتوح، أو فعّل GPS، أو عيّن موقعًا تجريبيًا على المحاكي ثم أعد المحاولة.';

  @override
  String get adhanToday => 'اليوم';

  @override
  String get adhanChangeCity => 'تغيير';

  @override
  String get adhanSearchCityTitle => 'بحث عن مدينة';

  @override
  String get adhanSearchCityHint => 'المدينة أو المدينة، الدولة';

  @override
  String get adhanSearchCityEmpty => 'لم يتم العثور على مدن. جرّب اسمًا آخر.';

  @override
  String get adhanUseMyLocation => 'استخدام موقعي الحالي';

  @override
  String get prayerFajr => 'الفجر';

  @override
  String get prayerSunrise => 'الشروق';

  @override
  String get prayerDhuhr => 'الظهر';

  @override
  String get prayerAsr => 'العصر';

  @override
  String get prayerMaghrib => 'المغرب';

  @override
  String get prayerIsha => 'العشاء';

  @override
  String adhanAlertSettingsTitle(String prayer) {
    return 'تذكير $prayer';
  }

  @override
  String get adhanAlertTimingSection => 'وقت التذكير';

  @override
  String get adhanAlertOff => 'إيقاف';

  @override
  String get adhanAlertBefore => 'قبل';

  @override
  String get adhanAlertAtAdhan => 'عند الأذان';

  @override
  String get adhanAlertAfter => 'بعد';

  @override
  String get adhanAlertMinutesSection => 'المدة';

  @override
  String adhanAlertMinutesLabel(int minutes) {
    return '$minutes د';
  }

  @override
  String adhanAlertMaxBeforeHint(int minutes, String prayer) {
    return 'بحد أقصى $minutes د قبل $prayer (وليس قبل صلاة سابقة)';
  }

  @override
  String adhanAlertMaxAfterHint(int minutes, String prayer) {
    return 'بحد أقصى $minutes د بعد $prayer (وليس بعد الصلاة التالية)';
  }

  @override
  String get adhanAlertDeliverySection => 'نوع التنبيه';

  @override
  String get adhanAlertSound => 'صوت';

  @override
  String get adhanAlertVibrate => 'اهتزاز';

  @override
  String get adhanAlertSave => 'حفظ';

  @override
  String adhanNotificationTitle(String prayer) {
    return '$prayer';
  }

  @override
  String adhanNotificationBodyBefore(int minutes, String prayer) {
    return 'متبقّ $minutes د على $prayer';
  }

  @override
  String adhanNotificationBodyAt(String prayer) {
    return 'حان وقت $prayer';
  }

  @override
  String adhanNotificationBodyAfter(int minutes, String prayer) {
    return 'مرّ $minutes د على $prayer';
  }

  @override
  String get adhanNotificationPermissionDenied =>
      'يلزم إذن الإشعارات لتذكيرات الصلاة.';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsLanguageSection => 'اللغة';

  @override
  String get settingsThemeSection => 'المظهر';

  @override
  String get settingsThemeLight => 'فاتح';

  @override
  String get settingsThemeDark => 'داكن';

  @override
  String get settingsDarkMode => 'الوضع الداكن';

  @override
  String get settingsSelectLanguage => 'اختر اللغة';

  @override
  String get settingsFontSizeSection => 'حجم الخط';

  @override
  String get settingsAppFontSize => 'حجم خط التطبيق';

  @override
  String get settingsQuranReaderFontSize => 'حجم خط قارئ القرآن';

  @override
  String settingsFontSizeValue(int percent) {
    return '$percent٪';
  }

  @override
  String get settingsNotificationsSection => 'الإشعارات';

  @override
  String get settingsNotificationsEnabled => 'تفعيل الإشعارات';

  @override
  String get settingsContactSection => 'الدعم';

  @override
  String get settingsReportBug => 'الإبلاغ عن مشكلة';

  @override
  String get settingsReportBugDescription =>
      'صف المشكلة وحدّد موضعها على الشاشة. يُرسل تقريرك إلى فريقنا.';

  @override
  String get settingsReportBugSuccess => 'شكراً — تم إرسال تقريرك.';

  @override
  String get settingsReportBugError => 'تعذر إرسال التقرير. حاول مرة أخرى.';

  @override
  String get settingsReportBugEmptyMessage => 'يرجى وصف المشكلة قبل الإرسال.';

  @override
  String get settingsContactUs => 'تواصل معنا';

  @override
  String get settingsContactUsError => 'تعذر فتح صفحة التواصل';

  @override
  String get settingsStorageSection => 'التخزين';

  @override
  String get settingsClearCache => 'مسح الذاكرة المؤقتة';

  @override
  String get settingsClearCacheDescription =>
      'إزالة الصوت المحمّل ومعاني الآيات ومعاني الكلمات. ستُحمَّل مجدداً عند الحاجة.';

  @override
  String get settingsClearCacheConfirmTitle => 'مسح الذاكرة المؤقتة؟';

  @override
  String get settingsClearCacheConfirmMessage =>
      'ستُزال التلاوات المحمّلة ومعاني الآيات ومعاني الكلمات من هذا الجهاز.';

  @override
  String get settingsClearCacheConfirmAction => 'مسح';

  @override
  String get settingsClearCacheCancel => 'إلغاء';

  @override
  String get settingsClearCacheSuccess => 'تم مسح الذاكرة المؤقتة.';

  @override
  String get settingsClearCacheError =>
      'تعذر مسح الذاكرة المؤقتة. حاول مرة أخرى.';
}
