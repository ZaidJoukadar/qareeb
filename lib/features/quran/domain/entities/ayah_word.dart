import 'package:equatable/equatable.dart';

class AyahWord extends Equatable {
  const AyahWord({
    required this.position,
    required this.arabic,
    required this.translation,
    required this.transliteration,
  });

  final int position;
  final String arabic;
  final String translation;
  final String transliteration;

  @override
  List<Object?> get props => [position, arabic, translation, transliteration];
}
