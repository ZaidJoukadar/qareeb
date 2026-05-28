import 'dart:convert';

import 'package:flutter/services.dart';

class AsmaUlHusnaArabicEntry {
  const AsmaUlHusnaArabicEntry({
    required this.number,
    required this.translationAr,
    required this.meaningAr,
  });

  final int number;
  final String translationAr;
  final String meaningAr;
}

abstract class AsmaUlHusnaLocalDataSource {
  Future<Map<int, AsmaUlHusnaArabicEntry>> loadArabicByNumber();
}

class AsmaUlHusnaLocalDataSourceImpl implements AsmaUlHusnaLocalDataSource {
  static const _assetPath = 'assets/data/asma_ul_husna_ar.json';

  Map<int, AsmaUlHusnaArabicEntry>? _cache;

  @override
  Future<Map<int, AsmaUlHusnaArabicEntry>> loadArabicByNumber() async {
    if (_cache != null) {
      return _cache!;
    }

    final raw = await rootBundle.loadString(_assetPath);
    final list = jsonDecode(raw) as List<dynamic>;

    _cache = Map<int, AsmaUlHusnaArabicEntry>.fromEntries(
      list.map((item) {
        final json = item as Map<String, dynamic>;
        return MapEntry(
          json['number'] as int,
          AsmaUlHusnaArabicEntry(
            number: json['number'] as int,
            translationAr: json['translationAr'] as String,
            meaningAr: json['meaningAr'] as String,
          ),
        );
      }),
    );

    return _cache!;
  }
}
