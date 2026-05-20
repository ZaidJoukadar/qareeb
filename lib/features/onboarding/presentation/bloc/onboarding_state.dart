import 'package:equatable/equatable.dart';

enum OnboardingStatus { initial, inProgress, completed }

class OnboardingState extends Equatable {
  const OnboardingState({
    this.currentPage = 0,
    this.status = OnboardingStatus.initial,
    this.totalPages = 3,
  });

  final int currentPage;
  final OnboardingStatus status;
  final int totalPages;

  bool get isLastPage => currentPage >= totalPages - 1;

  OnboardingState copyWith({
    int? currentPage,
    OnboardingStatus? status,
    int? totalPages,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props => [currentPage, status, totalPages];
}
