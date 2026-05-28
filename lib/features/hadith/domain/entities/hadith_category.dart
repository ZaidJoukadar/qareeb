import 'package:equatable/equatable.dart';

enum HadithCategoryKind {
  /// Themed list loaded via [searchQuery] on UmmahAPI `/hadith/search`.
  topic,

  /// Curated list (e.g. Qudsi) via search; may apply [sahihOnly] client-side.
  curated,

  /// Opens a single hadith book (browse by number).
  book,
}

class HadithCategory extends Equatable {
  const HadithCategory({
    required this.id,
    required this.kind,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    this.searchQuery,
    this.collectionId,
    this.sahihOnly = false,
  });

  final String id;
  final HadithCategoryKind kind;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;

  /// English search terms (UmmahAPI search is English-oriented).
  final String? searchQuery;

  /// When [kind] is [HadithCategoryKind.book], the collection slug.
  final String? collectionId;

  /// Keeps only hadiths whose [Hadith.grade] contains "Sahih".
  final bool sahihOnly;

  String titleFor({required bool isArabicLocale}) {
    return isArabicLocale ? titleAr : titleEn;
  }

  String descriptionFor({required bool isArabicLocale}) {
    return isArabicLocale ? descriptionAr : descriptionEn;
  }

  @override
  List<Object?> get props => [
    id,
    kind,
    titleEn,
    titleAr,
    descriptionEn,
    descriptionAr,
    searchQuery,
    collectionId,
    sahihOnly,
  ];
}
