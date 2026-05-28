import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/asma_ul_husna/domain/usecases/get_asma_ul_husna.dart';
import 'package:qareeb/features/asma_ul_husna/presentation/cubit/asma_ul_husna_state.dart';

class AsmaUlHusnaCubit extends Cubit<AsmaUlHusnaState> {
  AsmaUlHusnaCubit({required GetAsmaUlHusna getAsmaUlHusna})
    : _getAsmaUlHusna = getAsmaUlHusna,
      super(const AsmaUlHusnaState());

  final GetAsmaUlHusna _getAsmaUlHusna;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: AsmaUlHusnaStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final names = await _getAsmaUlHusna();
      emit(
        state.copyWith(
          status: AsmaUlHusnaStatus.success,
          names: names,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AsmaUlHusnaStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
