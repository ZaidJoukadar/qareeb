class DuaCategoryLabel {
  const DuaCategoryLabel({
    required this.nameAr,
    required this.descriptionAr,
  });

  final String nameAr;
  final String descriptionAr;
}

abstract final class DuaCategoryLabels {
  static const labels = <String, DuaCategoryLabel>{
    'morning': DuaCategoryLabel(
      nameAr: 'أذكار الصباح',
      descriptionAr: 'أدعية وذكر الصباح',
    ),
    'evening': DuaCategoryLabel(
      nameAr: 'أذكار المساء',
      descriptionAr: 'أدعية وذكر المساء',
    ),
    'wudu': DuaCategoryLabel(
      nameAr: 'الوضوء والطهارة',
      descriptionAr: 'أدعية الوضوء والطهارة',
    ),
    'prayer': DuaCategoryLabel(
      nameAr: 'أثناء الصلاة',
      descriptionAr: 'أدعية تُقال أثناء الصلاة',
    ),
    'after_prayer': DuaCategoryLabel(
      nameAr: 'بعد الصلاة',
      descriptionAr: 'الذكر والأدعية بعد الصلاة',
    ),
    'sleep': DuaCategoryLabel(
      nameAr: 'النوم',
      descriptionAr: 'أدعية قبل النوم وعند الاستيقاظ',
    ),
    'food': DuaCategoryLabel(
      nameAr: 'الطعام والشراب',
      descriptionAr: 'أدعية قبل الأكل وبعده',
    ),
    'travel': DuaCategoryLabel(
      nameAr: 'السفر',
      descriptionAr: 'أدعية السفر والرحلات',
    ),
    'home': DuaCategoryLabel(
      nameAr: 'المنزل',
      descriptionAr: 'أدعية دخول المنزل والخروج منه',
    ),
    'masjid': DuaCategoryLabel(
      nameAr: 'المسجد',
      descriptionAr: 'أدعية دخول المسجد والخروج منه',
    ),
    'distress': DuaCategoryLabel(
      nameAr: 'الكرب والهم',
      descriptionAr: 'أدعية وقت الشدة والقلق',
    ),
    'forgiveness': DuaCategoryLabel(
      nameAr: 'الاستغفار',
      descriptionAr: 'أدعية طلب المغفرة من الله',
    ),
    'illness': DuaCategoryLabel(
      nameAr: 'المرض والشفاء',
      descriptionAr: 'أدعية للمريض وطلب الشفاء',
    ),
    'weather': DuaCategoryLabel(
      nameAr: 'الطقس',
      descriptionAr: 'أدعية المطر والرعد والريح',
    ),
    'knowledge': DuaCategoryLabel(
      nameAr: 'العلم',
      descriptionAr: 'أدعية طلب العلم النافع',
    ),
    'parents': DuaCategoryLabel(
      nameAr: 'الوالدان',
      descriptionAr: 'أدعية للوالدين',
    ),
    'guidance': DuaCategoryLabel(
      nameAr: 'الهداية',
      descriptionAr: 'أدعية طلب الهداية والتوفيق',
    ),
    'gratitude': DuaCategoryLabel(
      nameAr: 'الشكر',
      descriptionAr: 'أدعية الشكر والحمد لله',
    ),
    'protection': DuaCategoryLabel(
      nameAr: 'الحفظ والعناية',
      descriptionAr: 'أدعية طلب الحفظ والاستعاذة',
    ),
    'dhikr': DuaCategoryLabel(
      nameAr: 'الذكر',
      descriptionAr: 'أذكار عامة لذكر الله',
    ),
    'marriage': DuaCategoryLabel(
      nameAr: 'الزواج والأسرة',
      descriptionAr: 'أدعية الزواج والحياة الأسرية',
    ),
    'hajj': DuaCategoryLabel(
      nameAr: 'الحج والعمرة',
      descriptionAr: 'أدعية الحج والعمرة',
    ),
    'grief': DuaCategoryLabel(
      nameAr: 'الحزن والفقد',
      descriptionAr: 'أدعية وقت المصيبة والوفاة',
    ),
    'children': DuaCategoryLabel(
      nameAr: 'الأطفال',
      descriptionAr: 'أدعية للأطفال والمواليد',
    ),
    'business': DuaCategoryLabel(
      nameAr: 'الرزق والتجارة',
      descriptionAr: 'أدعية الرزق والمعيشة',
    ),
    'night_prayer': DuaCategoryLabel(
      nameAr: 'قيام الليل',
      descriptionAr: 'أدعية التهجد والوتر والليل',
    ),
    'quran_recitation': DuaCategoryLabel(
      nameAr: 'تلاوة القرآن',
      descriptionAr: 'أدعية قبل تلاوة القرآن وأثناءها',
    ),
  };

  static DuaCategoryLabel? forId(String id) => labels[id];
}
