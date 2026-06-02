import 'package:equatable/equatable.dart';

class AyahStory extends Equatable {
  const AyahStory({
    required this.revelationReason,
    required this.howRevealed,
    required this.miracle,
  });

  final String revelationReason;
  final String howRevealed;
  final String miracle;

  @override
  List<Object?> get props => [revelationReason, howRevealed, miracle];
}
