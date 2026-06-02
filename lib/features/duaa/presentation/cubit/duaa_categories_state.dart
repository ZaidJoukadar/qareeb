import 'package:equatable/equatable.dart';
import 'package:qareeb/features/duaa/domain/entities/dua_category.dart';

enum DuaaCategoriesStatus { initial, loading, success, failure }

class DuaaCategoriesState extends Equatable {
  const DuaaCategoriesState({
    this.status = DuaaCategoriesStatus.initial,
    this.categories = const [],
    this.errorMessage,
    this.searchQuery = '',
  });

  final DuaaCategoriesStatus status;
  final List<DuaCategory> categories;
  final String? errorMessage;
  final String searchQuery;

  List<DuaCategory> get filteredCategories {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return categories;
    }

    return categories.where((category) {
      return category.name.toLowerCase().contains(query) ||
          category.description.toLowerCase().contains(query) ||
          (category.nameAr?.contains(query) ?? false) ||
          (category.descriptionAr?.contains(query) ?? false);
    }).toList();
  }

  DuaaCategoriesState copyWith({
    DuaaCategoriesStatus? status,
    List<DuaCategory>? categories,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? searchQuery,
  }) {
    return DuaaCategoriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, categories, errorMessage, searchQuery];
}
