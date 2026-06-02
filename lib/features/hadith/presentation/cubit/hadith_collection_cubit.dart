import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/hadith/domain/usecases/get_hadith_page.dart';
import 'package:qareeb/features/hadith/domain/usecases/search_hadith.dart';
import 'package:qareeb/features/hadith/presentation/cubit/hadith_collection_state.dart';

class HadithCollectionCubit extends Cubit<HadithCollectionState> {
  HadithCollectionCubit({
    required GetHadithPage getHadithPage,
    required SearchHadith searchHadith,
  }) : _getHadithPage = getHadithPage,
       _searchHadith = searchHadith,
       super(const HadithCollectionState());

  final GetHadithPage _getHadithPage;
  final SearchHadith _searchHadith;

  Timer? _searchDebounce;
  int _searchGeneration = 0;
  String? _collectionId;

  Future<void> load(String collectionId) async {
    _collectionId = collectionId;
    emit(
      state.copyWith(
        status: HadithCollectionStatus.loading,
        hadiths: const [],
        searchResults: const [],
        currentPage: 0,
        totalPages: 0,
        clearErrorMessage: true,
        searchQuery: '',
      ),
    );

    try {
      final page = await _getHadithPage(collectionId: collectionId, page: 1);
      emit(
        state.copyWith(
          status: HadithCollectionStatus.success,
          hadiths: page.hadiths,
          currentPage: page.page,
          totalPages: page.totalPages,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HadithCollectionStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> loadMore() async {
    final collectionId = _collectionId;
    if (collectionId == null ||
        state.isSearchActive ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final page = await _getHadithPage(
        collectionId: collectionId,
        page: state.currentPage + 1,
      );
      emit(
        state.copyWith(
          hadiths: [...state.hadiths, ...page.hadiths],
          currentPage: page.page,
          totalPages: page.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _searchDebounce?.cancel();

    final trimmed = query.trim();
    final collectionId = _collectionId;
    if (collectionId == null) {
      return;
    }

    if (trimmed.length < 2) {
      emit(
        state.copyWith(
          searchResults: const [],
          status: state.hadiths.isEmpty
              ? HadithCollectionStatus.loading
              : HadithCollectionStatus.success,
          clearErrorMessage: true,
        ),
      );
      if (trimmed.isEmpty && state.hadiths.isEmpty) {
        unawaited(load(collectionId));
      }
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _runSearch(collectionId, trimmed);
    });
  }

  Future<void> _runSearch(String collectionId, String query) async {
    final generation = ++_searchGeneration;
    emit(
      state.copyWith(
        status: HadithCollectionStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final results = await _searchHadith(
        query: query,
        collectionId: collectionId,
        limit: 50,
      );
      if (generation != _searchGeneration) {
        return;
      }
      emit(
        state.copyWith(
          status: HadithCollectionStatus.success,
          searchResults: results,
        ),
      );
    } catch (error) {
      if (generation != _searchGeneration) {
        return;
      }
      emit(
        state.copyWith(
          status: HadithCollectionStatus.failure,
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
