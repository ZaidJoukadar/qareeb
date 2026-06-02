import 'package:equatable/equatable.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith.dart';

enum HadithCollectionStatus { initial, loading, success, failure }

class HadithCollectionState extends Equatable {
  const HadithCollectionState({
    this.status = HadithCollectionStatus.initial,
    this.hadiths = const [],
    this.searchResults = const [],
    this.errorMessage,
    this.searchQuery = '',
    this.currentPage = 0,
    this.totalPages = 0,
    this.isLoadingMore = false,
  });

  final HadithCollectionStatus status;
  final List<Hadith> hadiths;
  final List<Hadith> searchResults;
  final String? errorMessage;
  final String searchQuery;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;

  bool get isSearchActive => searchQuery.trim().length >= 2;

  bool get hasMore => !isSearchActive && currentPage < totalPages;

  List<Hadith> get visibleHadiths =>
      isSearchActive ? searchResults : hadiths;

  HadithCollectionState copyWith({
    HadithCollectionStatus? status,
    List<Hadith>? hadiths,
    List<Hadith>? searchResults,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? searchQuery,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return HadithCollectionState(
      status: status ?? this.status,
      hadiths: hadiths ?? this.hadiths,
      searchResults: searchResults ?? this.searchResults,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    hadiths,
    searchResults,
    errorMessage,
    searchQuery,
    currentPage,
    totalPages,
    isLoadingMore,
  ];
}
