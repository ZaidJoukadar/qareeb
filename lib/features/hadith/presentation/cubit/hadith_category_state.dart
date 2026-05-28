import 'package:equatable/equatable.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith.dart';

enum HadithCategoryStatus { initial, loading, success, failure }

class HadithCategoryState extends Equatable {
  const HadithCategoryState({
    this.status = HadithCategoryStatus.initial,
    this.hadiths = const [],
    this.errorMessage,
    this.searchQuery = '',
  });

  final HadithCategoryStatus status;
  final List<Hadith> hadiths;
  final String? errorMessage;
  final String searchQuery;

  List<Hadith> get visibleHadiths {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return hadiths;
    }

    return hadiths.where((hadith) {
      return hadith.arabic.contains(query) ||
          hadith.english.toLowerCase().contains(query) ||
          '${hadith.number}'.contains(query) ||
          hadith.collectionName.toLowerCase().contains(query);
    }).toList();
  }

  HadithCategoryState copyWith({
    HadithCategoryStatus? status,
    List<Hadith>? hadiths,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? searchQuery,
  }) {
    return HadithCategoryState(
      status: status ?? this.status,
      hadiths: hadiths ?? this.hadiths,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, hadiths, errorMessage, searchQuery];
}
