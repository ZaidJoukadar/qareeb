import 'package:flutter/material.dart';
import 'package:qareeb/core/locale/domain/repositories/locale_repository.dart';

class GetSavedLocale {
  const GetSavedLocale(this._repository);

  final LocaleRepository _repository;

  Future<Locale?> call() => _repository.getSavedLocale();
}
