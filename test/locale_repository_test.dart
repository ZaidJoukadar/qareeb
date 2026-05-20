import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/core/locale/data/locale_local_data_source.dart';
import 'package:qareeb/core/locale/data/repositories/locale_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('saved locale is restored from preferences', () async {
    SharedPreferences.setMockInitialValues({'app_locale': 'ar'});
    final prefs = await SharedPreferences.getInstance();
    final dataSource = LocaleLocalDataSourceImpl(prefs);
    final repository = LocaleRepositoryImpl(dataSource);

    final locale = await repository.getSavedLocale();

    expect(locale, const Locale('ar'));
  });
}
