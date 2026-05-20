import 'package:equatable/equatable.dart';

enum QuranSyncUiStatus { initial, syncing, success, failure }

class QuranSyncState extends Equatable {
  const QuranSyncState({
    this.status = QuranSyncUiStatus.initial,
    this.completedSurahs = 0,
    this.totalSurahs = 114,
    this.errorMessage,
  });

  final QuranSyncUiStatus status;
  final int completedSurahs;
  final int totalSurahs;
  final String? errorMessage;

  double get progress =>
      totalSurahs == 0 ? 0 : completedSurahs / totalSurahs;

  QuranSyncState copyWith({
    QuranSyncUiStatus? status,
    int? completedSurahs,
    int? totalSurahs,
    String? errorMessage,
    bool clearError = false,
  }) {
    return QuranSyncState(
      status: status ?? this.status,
      completedSurahs: completedSurahs ?? this.completedSurahs,
      totalSurahs: totalSurahs ?? this.totalSurahs,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    completedSurahs,
    totalSurahs,
    errorMessage,
  ];
}
