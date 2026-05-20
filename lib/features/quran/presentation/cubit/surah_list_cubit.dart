import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/quran/domain/usecases/get_surahs.dart';
import 'package:qareeb/features/quran/presentation/cubit/surah_list_state.dart';

class SurahListCubit extends Cubit<SurahListState> {
  SurahListCubit({required GetSurahs getSurahs})
    : _getSurahs = getSurahs,
      super(const SurahListState());

  final GetSurahs _getSurahs;

  Future<void> load() async {
    emit(state.copyWith(status: SurahListStatus.loading));
    try {
      final surahs = await _getSurahs();
      emit(
        state.copyWith(
          status: SurahListStatus.success,
          surahs: surahs,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: SurahListStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
