import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/hadith/domain/usecases/get_hadith_categories.dart';
import 'package:qareeb/features/hadith/domain/usecases/get_hadith_collections.dart';
import 'package:qareeb/features/hadith/domain/usecases/search_hadith.dart';
import 'package:qareeb/features/hadith/presentation/cubit/hadith_collections_state.dart';

class HadithCollectionsCubit extends Cubit<HadithCollectionsState> {
  HadithCollectionsCubit({
    required GetHadithCategories getHadithCategories,
    required GetHadithCollections getHadithCollections,
    required SearchHadith searchHadith,
  }) : _getHadithCategories = getHadithCategories,
       _getHadithCollections = getHadithCollections,
       _searchHadith = searchHadith,
       super(const HadithCollectionsState());

  final GetHadithCategories _getHadithCategories;
  final GetHadithCollections _getHadithCollections;
  final SearchHadith _searchHadith;

  Timer? _searchDebounce;
  int _searchGeneration = 0;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: HadithCollectionsStatus.loading,
        categories: _getHadithCategories(),
        clearErrorMessage: true,
      ),
    );

    try {
      final collections = await _getHadithCollections();
      emit(
        state.copyWith(
          status: HadithCollectionsStatus.success,
          collections: collections,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HadithCollectionsStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _searchDebounce?.cancel();

    final trimmed = query.trim();
    if (trimmed.length < 2) {
      emit(
        state.copyWith(
          searchResults: const [],
          status: HadithCollectionsStatus.success,
          clearErrorMessage: true,
        ),
      );
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _runSearch(trimmed);
    });
  }

  Future<void> _runSearch(String query) async {
    final generation = ++_searchGeneration;
    emit(
      state.copyWith(
        status: HadithCollectionsStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final results = await _searchHadith(query: query, limit: 50);
      if (generation != _searchGeneration) {
        return;
      }
      emit(
        state.copyWith(
          status: HadithCollectionsStatus.success,
          searchResults: results,
        ),
      );
    } catch (error) {
      if (generation != _searchGeneration) {
        return;
      }
      emit(
        state.copyWith(
          status: HadithCollectionsStatus.failure,
          searchResults: const [],
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
