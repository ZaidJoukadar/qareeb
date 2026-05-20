import 'package:equatable/equatable.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';

enum SurahListStatus { initial, loading, success, failure }

class SurahListState extends Equatable {
  const SurahListState({
    this.status = SurahListStatus.initial,
    this.surahs = const [],
    this.errorMessage,
  });

  final SurahListStatus status;
  final List<Surah> surahs;
  final String? errorMessage;

  SurahListState copyWith({
    SurahListStatus? status,
    List<Surah>? surahs,
    String? errorMessage,
  }) {
    return SurahListState(
      status: status ?? this.status,
      surahs: surahs ?? this.surahs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, surahs, errorMessage];
}
