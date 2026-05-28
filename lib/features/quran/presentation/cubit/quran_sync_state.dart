import 'package:equatable/equatable.dart';

enum QuranSyncUiStatus { initial, syncing, success, failure }

class QuranSyncState extends Equatable {
  const QuranSyncState({
    this.status = QuranSyncUiStatus.initial,
    this.completedSurahs = 0,
    this.totalSurahs = 114,
    this.errorMessage,
    this.showConnectionErrorDialog = false,
  });

  final QuranSyncUiStatus status;
  final int completedSurahs;
  final int totalSurahs;
  final String? errorMessage;
  final bool showConnectionErrorDialog;

  double get progress =>
      totalSurahs == 0 ? 0 : completedSurahs / totalSurahs;

  int get progressPercent => (progress * 100).round().clamp(0, 100);

  QuranSyncState copyWith({
    QuranSyncUiStatus? status,
    int? completedSurahs,
    int? totalSurahs,
    String? errorMessage,
    bool? showConnectionErrorDialog,
    bool clearError = false,
  }) {
    return QuranSyncState(
      status: status ?? this.status,
      completedSurahs: completedSurahs ?? this.completedSurahs,
      totalSurahs: totalSurahs ?? this.totalSurahs,
      showConnectionErrorDialog:
          showConnectionErrorDialog ?? this.showConnectionErrorDialog,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    completedSurahs,
    totalSurahs,
    errorMessage,
    showConnectionErrorDialog,
  ];
}
