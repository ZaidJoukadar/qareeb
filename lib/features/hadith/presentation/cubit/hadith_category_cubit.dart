import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith_category.dart';
import 'package:qareeb/features/hadith/domain/usecases/get_hadiths_for_category.dart';
import 'package:qareeb/features/hadith/presentation/cubit/hadith_category_state.dart';

class HadithCategoryCubit extends Cubit<HadithCategoryState> {
  HadithCategoryCubit({required GetHadithsForCategory getHadithsForCategory})
    : _getHadithsForCategory = getHadithsForCategory,
      super(const HadithCategoryState());

  final GetHadithsForCategory _getHadithsForCategory;

  Future<void> load(HadithCategory category) async {
    emit(
      state.copyWith(
        status: HadithCategoryStatus.loading,
        hadiths: const [],
        clearErrorMessage: true,
        searchQuery: '',
      ),
    );

    try {
      final hadiths = await _getHadithsForCategory(category);
      emit(
        state.copyWith(
          status: HadithCategoryStatus.success,
          hadiths: hadiths,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HadithCategoryStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
