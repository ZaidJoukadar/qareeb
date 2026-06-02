import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/quran/domain/usecases/get_surah_by_number.dart';
import 'package:qareeb/features/quran/presentation/cubit/home_surah_state.dart';

class HomeSurahCubit extends Cubit<HomeSurahState> {
  HomeSurahCubit({required GetSurahByNumber getSurahByNumber})
    : _getSurahByNumber = getSurahByNumber,
      super(const HomeSurahState());

  final GetSurahByNumber _getSurahByNumber;

  Future<void> load() async {
    emit(state.copyWith(status: HomeSurahStatus.loading));
    try {
      final surah = await _getSurahByNumber(1);
      if (surah == null) {
        emit(
          state.copyWith(
            status: HomeSurahStatus.failure,
            errorMessage: 'Surah not found',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: HomeSurahStatus.success,
          surah: surah,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HomeSurahStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
