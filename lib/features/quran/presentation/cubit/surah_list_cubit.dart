import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/quran/domain/usecases/get_read_ayah_counts.dart';
import 'package:qareeb/features/quran/domain/usecases/get_surahs.dart';
import 'package:qareeb/features/quran/presentation/cubit/surah_list_state.dart';

class SurahListCubit extends Cubit<SurahListState> {
  SurahListCubit({
    required GetSurahs getSurahs,
    required GetReadAyahCounts getReadAyahCounts,
  }) : _getSurahs = getSurahs,
       _getReadAyahCounts = getReadAyahCounts,
       super(const SurahListState());

  final GetSurahs _getSurahs;
  final GetReadAyahCounts _getReadAyahCounts;

  Future<void> load() async {
    emit(state.copyWith(status: SurahListStatus.loading));
    try {
      final surahs = await _getSurahs();
      final readAyahCounts = await _getReadAyahCounts();
      emit(
        state.copyWith(
          status: SurahListStatus.success,
          surahs: surahs,
          readAyahCounts: readAyahCounts,
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

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
