import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/duaa/domain/usecases/get_duas_by_category.dart';
import 'package:qareeb/features/duaa/presentation/cubit/duaa_category_state.dart';

class DuaaCategoryCubit extends Cubit<DuaaCategoryState> {
  DuaaCategoryCubit({required GetDuasByCategory getDuasByCategory})
    : _getDuasByCategory = getDuasByCategory,
      super(const DuaaCategoryState());

  final GetDuasByCategory _getDuasByCategory;

  Future<void> load(String categoryId) async {
    emit(
      state.copyWith(
        status: DuaaCategoryStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final duas = await _getDuasByCategory(categoryId);
      emit(
        state.copyWith(
          status: DuaaCategoryStatus.success,
          duas: duas,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: DuaaCategoryStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
