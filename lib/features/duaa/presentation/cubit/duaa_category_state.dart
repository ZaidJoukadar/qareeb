import 'package:equatable/equatable.dart';
import 'package:qareeb/features/duaa/domain/entities/dua.dart';

enum DuaaCategoryStatus { initial, loading, success, failure }

class DuaaCategoryState extends Equatable {
  const DuaaCategoryState({
    this.status = DuaaCategoryStatus.initial,
    this.duas = const [],
    this.errorMessage,
    this.searchQuery = '',
  });

  final DuaaCategoryStatus status;
  final List<Dua> duas;
  final String? errorMessage;
  final String searchQuery;

  List<Dua> get filteredDuas {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return duas;
    }

    return duas.where((dua) {
      return dua.title.toLowerCase().contains(query) ||
          dua.arabic.contains(query) ||
          dua.transliteration.toLowerCase().contains(query) ||
          dua.translation.toLowerCase().contains(query) ||
          (dua.titleAr?.contains(query) ?? false) ||
          (dua.translationAr?.contains(query) ?? false);
    }).toList();
  }

  DuaaCategoryState copyWith({
    DuaaCategoryStatus? status,
    List<Dua>? duas,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? searchQuery,
  }) {
    return DuaaCategoryState(
      status: status ?? this.status,
      duas: duas ?? this.duas,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, duas, errorMessage, searchQuery];
}
