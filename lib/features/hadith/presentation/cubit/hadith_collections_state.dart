import 'package:equatable/equatable.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith_category.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith_collection.dart';

enum HadithCollectionsStatus { initial, loading, success, failure }

class HadithCollectionsState extends Equatable {
  const HadithCollectionsState({
    this.status = HadithCollectionsStatus.initial,
    this.categories = const [],
    this.collections = const [],
    this.searchResults = const [],
    this.errorMessage,
    this.searchQuery = '',
  });

  final HadithCollectionsStatus status;
  final List<HadithCategory> categories;
  final List<HadithCollection> collections;
  final List<Hadith> searchResults;
  final String? errorMessage;
  final String searchQuery;

  bool get isSearchActive => searchQuery.trim().length >= 2;

  List<HadithCategory> get filteredCategories {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty || isSearchActive) {
      return categories;
    }

    return categories.where((category) {
      return category.titleEn.toLowerCase().contains(query) ||
          category.titleAr.contains(query) ||
          category.descriptionEn.toLowerCase().contains(query) ||
          category.descriptionAr.contains(query);
    }).toList();
  }

  List<HadithCollection> get filteredCollections {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty || isSearchActive) {
      return collections;
    }

    return collections.where((collection) {
      return collection.name.toLowerCase().contains(query) ||
          collection.nameAr.contains(query);
    }).toList();
  }

  HadithCollectionsState copyWith({
    HadithCollectionsStatus? status,
    List<HadithCategory>? categories,
    List<HadithCollection>? collections,
    List<Hadith>? searchResults,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? searchQuery,
  }) {
    return HadithCollectionsState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      collections: collections ?? this.collections,
      searchResults: searchResults ?? this.searchResults,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    status,
    categories,
    collections,
    searchResults,
    errorMessage,
    searchQuery,
  ];
}
