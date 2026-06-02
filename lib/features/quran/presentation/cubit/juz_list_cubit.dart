import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/quran/domain/usecases/get_surah_count_by_juz.dart';
import 'package:qareeb/features/quran/presentation/cubit/juz_list_state.dart';

class JuzListCubit extends Cubit<JuzListState> {
  JuzListCubit({required GetSurahCountByJuz getSurahCountByJuz})
    : _getSurahCountByJuz = getSurahCountByJuz,
      super(const JuzListState());

  final GetSurahCountByJuz _getSurahCountByJuz;

  Future<void> load() async {
    emit(state.copyWith(status: JuzListStatus.loading));
    try {
      final surahCountByJuz = await _getSurahCountByJuz();
      emit(
        state.copyWith(
          status: JuzListStatus.success,
          surahCountByJuz: surahCountByJuz,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: JuzListStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
