import 'package:flutter/material.dart';
import 'package:qareeb/core/locale/domain/repositories/locale_repository.dart';

class SaveLocale {
  const SaveLocale(this._repository);

  final LocaleRepository _repository;

  Future<void> call(Locale locale) => _repository.saveLocale(locale);
}
