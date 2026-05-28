import 'package:equatable/equatable.dart';

enum JuzListStatus { initial, loading, success, failure }

class JuzListState extends Equatable {
  const JuzListState({
    this.status = JuzListStatus.initial,
    this.surahCountByJuz = const {},
    this.errorMessage,
  });

  final JuzListStatus status;
  final Map<int, int> surahCountByJuz;
  final String? errorMessage;

  int? surahCountFor(int juzNumber) => surahCountByJuz[juzNumber];

  JuzListState copyWith({
    JuzListStatus? status,
    Map<int, int>? surahCountByJuz,
    String? errorMessage,
  }) {
    return JuzListState(
      status: status ?? this.status,
      surahCountByJuz: surahCountByJuz ?? this.surahCountByJuz,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, surahCountByJuz, errorMessage];
}
