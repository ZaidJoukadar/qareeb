import 'package:equatable/equatable.dart';

class OnboardingSlide extends Equatable {
  const OnboardingSlide({required this.imageAsset});

  final String imageAsset;

  @override
  List<Object?> get props => [imageAsset];
}
