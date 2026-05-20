import 'package:qareeb/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocaleLocalDataSource {
  Future<String?> getLanguageCode();
  Future<void> saveLanguageCode(String languageCode);
}

class LocaleLocalDataSourceImpl implements LocaleLocalDataSource {
  LocaleLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<String?> getLanguageCode() async {
    return _prefs.getString(StorageKeys.appLocale);
  }

  @override
  Future<void> saveLanguageCode(String languageCode) async {
    await _prefs.setString(StorageKeys.appLocale, languageCode);
  }
}
