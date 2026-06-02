import 'package:equatable/equatable.dart';

class HadithCollection extends Equatable {
  const HadithCollection({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.total,
  });

  final String id;
  final String name;
  final String nameAr;
  final int total;

  String nameFor({required bool isArabicLocale}) {
    return isArabicLocale ? nameAr : name;
  }

  @override
  List<Object?> get props => [id, name, nameAr, total];
}
