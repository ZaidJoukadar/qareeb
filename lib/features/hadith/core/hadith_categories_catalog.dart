import 'package:qareeb/features/hadith/domain/entities/hadith_category.dart';

/// Topic and curated categories. UmmahAPI has no `/hadith/topics` endpoint;
/// themed lists use `GET /hadith/search?q=…` ([docs](https://ummahapi.com/api/docs)).
abstract final class HadithCategoriesCatalog {
  static const List<HadithCategory> topics = [
    HadithCategory(
      id: 'prayer',
      kind: HadithCategoryKind.topic,
      titleEn: 'Hadiths about Prayer',
      titleAr: 'أحاديث عن الصلاة',
      descriptionEn: 'Sayings of the Prophet ﷺ on salah and worship.',
      descriptionAr: 'أحاديث نبوية في الصلاة والعبادة.',
      searchQuery: 'prayer',
    ),
    HadithCategory(
      id: 'patience',
      kind: HadithCategoryKind.topic,
      titleEn: 'Hadiths about Patience',
      titleAr: 'أحاديث عن الصبر',
      descriptionEn: 'Guidance on sabr in hardship and daily life.',
      descriptionAr: 'أحاديث في الصبر عند البلاء وفي الحياة.',
      searchQuery: 'patience',
    ),
    HadithCategory(
      id: 'zakat',
      kind: HadithCategoryKind.topic,
      titleEn: 'Hadiths about Zakat',
      titleAr: 'أحاديث عن الزكاة',
      descriptionEn: 'Obligatory charity, sadaqah, and spending for Allah.',
      descriptionAr: 'الزكاة والصدقة والإنفاق في سبيل الله.',
      searchQuery: 'zakat charity',
    ),
    HadithCategory(
      id: 'authentic',
      kind: HadithCategoryKind.curated,
      titleEn: 'Authentic Hadiths',
      titleAr: 'أحاديث صحيحة',
      descriptionEn: 'Selected narrations graded Sahih across collections.',
      descriptionAr: 'أحاديث مصنّفة صحيحة من الكتب المعتمدة.',
      searchQuery: 'Prophet',
      sahihOnly: true,
    ),
    HadithCategory(
      id: 'qudsi',
      kind: HadithCategoryKind.curated,
      titleEn: 'Qudsi Hadiths',
      titleAr: 'الأحاديث القدسية',
      descriptionEn: 'Sacred hadiths where meaning is from Allah and wording from the Prophet ﷺ.',
      descriptionAr: 'أحاديث يكون معناها من عند الله ولفظها من عند النبي ﷺ.',
      searchQuery: 'Allah said',
    ),
  ];
}
