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
  String get quranSyncTitle => 'جاري تحضير القرآن';

  @override
  String get quranSyncDescription =>
      'يتم تنزيل السور والآيات للقراءة دون اتصال. قد يستغرق ذلك بضع دقائق.';

  @override
  String quranSyncProgress(int completed, int total) {
    return '$completed من $total سورة';
  }

  @override
  String get quranSyncRetry => 'إعادة المحاولة';

  @override
  String get surahListError => 'تعذر تحميل السور';

  @override
  String get ayahCountLabel => 'آية';

  @override
  String get dismiss => 'إغلاق';
}
