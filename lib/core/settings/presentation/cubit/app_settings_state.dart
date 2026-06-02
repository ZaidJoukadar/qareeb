part of 'app_settings_cubit.dart';

enum AppSettingsStatus { initial, ready }

class AppSettingsState extends Equatable {
  const AppSettingsState({
    this.themeMode = ThemeMode.light,
    this.notificationsEnabled = false,
    this.appFontScale = FontScaleDefaults.defaultScale,
    this.quranFontScale = FontScaleDefaults.defaultScale,
    this.quranAudioReciter = QuranEditions.audioRecitation,
    this.status = AppSettingsStatus.initial,
  });

  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final double appFontScale;
  final double quranFontScale;
  final String quranAudioReciter;
  final AppSettingsStatus status;

  AppSettingsState copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    double? appFontScale,
    double? quranFontScale,
    String? quranAudioReciter,
    AppSettingsStatus? status,
  }) {
    return AppSettingsState(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      appFontScale: appFontScale ?? this.appFontScale,
      quranFontScale: quranFontScale ?? this.quranFontScale,
      quranAudioReciter: quranAudioReciter ?? this.quranAudioReciter,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    notificationsEnabled,
    appFontScale,
    quranFontScale,
    quranAudioReciter,
    status,
  ];
}
