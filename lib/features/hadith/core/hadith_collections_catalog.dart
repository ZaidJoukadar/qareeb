import 'package:qareeb/features/hadith/domain/entities/hadith_collection.dart';

/// Canonical hadith books served by [UmmahAPI](https://ummahapi.com/api/docs).
abstract final class HadithCollectionsCatalog {
  static const List<HadithCollection> all = [
    HadithCollection(
      id: 'bukhari',
      name: 'Sahih al-Bukhari',
      nameAr: 'صحيح البخاري',
      total: 7580,
    ),
    HadithCollection(
      id: 'muslim',
      name: 'Sahih Muslim',
      nameAr: 'صحيح مسلم',
      total: 7360,
    ),
    HadithCollection(
      id: 'abudawud',
      name: 'Sunan Abu Dawud',
      nameAr: 'سنن أبي داود',
      total: 5272,
    ),
    HadithCollection(
      id: 'tirmidhi',
      name: "Jami' at-Tirmidhi",
      nameAr: 'جامع الترمذي',
      total: 3926,
    ),
    HadithCollection(
      id: 'nasai',
      name: "Sunan an-Nasa'i",
      nameAr: 'سنن النسائي',
      total: 5679,
    ),
    HadithCollection(
      id: 'ibnmajah',
      name: 'Sunan Ibn Majah',
      nameAr: 'سنن ابن ماجه',
      total: 4340,
    ),
    HadithCollection(
      id: 'malik',
      name: 'Muwatta Malik',
      nameAr: 'موطأ مالك',
      total: 1829,
    ),
  ];
}
