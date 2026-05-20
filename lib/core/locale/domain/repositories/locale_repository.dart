import 'package:flutter/material.dart';

abstract class LocaleRepository {
  Future<Locale?> getSavedLocale();
  Future<void> saveLocale(Locale locale);
}
