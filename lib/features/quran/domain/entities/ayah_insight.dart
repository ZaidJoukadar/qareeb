import 'package:equatable/equatable.dart';

class AyahInsight extends Equatable {
  const AyahInsight({
    required this.surahNumber,
    required this.ayahNumber,
    required this.meaning,
  });

  final int surahNumber;
  final int ayahNumber;
  final String meaning;

  @override
  List<Object?> get props => [surahNumber, ayahNumber, meaning];
}
