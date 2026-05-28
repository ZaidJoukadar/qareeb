import 'package:equatable/equatable.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';

enum HomeSurahStatus { initial, loading, success, failure }

class HomeSurahState extends Equatable {
  const HomeSurahState({
    this.status = HomeSurahStatus.initial,
    this.surah,
    this.errorMessage,
  });

  final HomeSurahStatus status;
  final Surah? surah;
  final String? errorMessage;

  HomeSurahState copyWith({
    HomeSurahStatus? status,
    Surah? surah,
    String? errorMessage,
  }) {
    return HomeSurahState(
      status: status ?? this.status,
      surah: surah ?? this.surah,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, surah, errorMessage];
}
