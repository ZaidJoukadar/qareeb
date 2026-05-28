import 'dart:convert';

import 'package:flutter/services.dart';

class DuaArabicEntry {
  const DuaArabicEntry({
    required this.id,
    required this.titleAr,
    required this.translationAr,
  });

  final int id;
  final String titleAr;
  final String translationAr;
}

abstract class DuaaLocalDataSource {
  Future<Map<int, DuaArabicEntry>> loadArabicById();
}

class DuaaLocalDataSourceImpl implements DuaaLocalDataSource {
  static const _assetPath = 'assets/data/duaa_ar.json';

  Map<int, DuaArabicEntry>? _cache;

  @override
  Future<Map<int, DuaArabicEntry>> loadArabicById() async {
    if (_cache != null) {
      return _cache!;
    }

    final raw = await rootBundle.loadString(_assetPath);
    final list = jsonDecode(raw) as List<dynamic>;

    _cache = Map<int, DuaArabicEntry>.fromEntries(
      list.map((item) {
        final json = item as Map<String, dynamic>;
        return MapEntry(
          json['id'] as int,
          DuaArabicEntry(
            id: json['id'] as int,
            titleAr: json['titleAr'] as String,
            translationAr: json['translationAr'] as String,
          ),
        );
      }),
    );

    return _cache!;
  }
}
