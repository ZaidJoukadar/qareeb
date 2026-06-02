import 'package:equatable/equatable.dart';
import 'package:qareeb/features/asma_ul_husna/domain/entities/allah_name.dart';

enum AsmaUlHusnaStatus { initial, loading, success, failure }

class AsmaUlHusnaState extends Equatable {
  const AsmaUlHusnaState({
    this.status = AsmaUlHusnaStatus.initial,
    this.names = const [],
    this.errorMessage,
    this.searchQuery = '',
  });

  final AsmaUlHusnaStatus status;
  final List<AllahName> names;
  final String? errorMessage;
  final String searchQuery;

  List<AllahName> get filteredNames {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return names;
    }

    return names.where((name) {
      return name.arabic.contains(query) ||
          name.transliteration.toLowerCase().contains(query) ||
          name.english.toLowerCase().contains(query) ||
          name.meaning.toLowerCase().contains(query) ||
          (name.meaningAr?.contains(query) ?? false) ||
          (name.translationAr?.contains(query) ?? false) ||
          name.number.toString() == query;
    }).toList();
  }

  AsmaUlHusnaState copyWith({
    AsmaUlHusnaStatus? status,
    List<AllahName>? names,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? searchQuery,
  }) {
    return AsmaUlHusnaState(
      status: status ?? this.status,
      names: names ?? this.names,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, names, errorMessage, searchQuery];
}
