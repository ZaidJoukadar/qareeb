import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/duaa/domain/usecases/get_dua_categories.dart';
import 'package:qareeb/features/duaa/presentation/cubit/duaa_categories_state.dart';

class DuaaCategoriesCubit extends Cubit<DuaaCategoriesState> {
  DuaaCategoriesCubit({required GetDuaCategories getDuaCategories})
    : _getDuaCategories = getDuaCategories,
      super(const DuaaCategoriesState());

  final GetDuaCategories _getDuaCategories;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: DuaaCategoriesStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final categories = await _getDuaCategories();
      emit(
        state.copyWith(
          status: DuaaCategoriesStatus.success,
          categories: categories,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: DuaaCategoriesStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
