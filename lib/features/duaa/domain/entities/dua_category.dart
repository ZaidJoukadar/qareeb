import 'package:equatable/equatable.dart';

class DuaCategory extends Equatable {
  const DuaCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.count,
    this.nameAr,
    this.descriptionAr,
  });

  final String id;
  final String name;
  final String description;
  final int count;
  final String? nameAr;
  final String? descriptionAr;

  String nameFor({required bool isArabicLocale}) {
    if (isArabicLocale && nameAr != null && nameAr!.isNotEmpty) {
      return nameAr!;
    }
    return name;
  }

  String descriptionFor({required bool isArabicLocale}) {
    if (isArabicLocale && descriptionAr != null && descriptionAr!.isNotEmpty) {
      return descriptionAr!;
    }
    return description;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    count,
    nameAr,
    descriptionAr,
  ];
}
