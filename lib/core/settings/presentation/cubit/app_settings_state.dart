part of 'app_settings_cubit.dart';

enum AppSettingsStatus { initial, ready }

class AppSettingsState extends Equatable {
  const AppSettingsState({
    this.themeMode = ThemeMode.light,
    this.notificationsEnabled = false,
    this.fontScale = FontScaleDefaults.defaultScale,
    this.quranAudioReciter = QuranEditions.audioRecitation,
    this.status = AppSettingsStatus.initial,
  });

  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final double fontScale;
  final String quranAudioReciter;
  final AppSettingsStatus status;

  AppSettingsState copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    double? fontScale,
    String? quranAudioReciter,
    AppSettingsStatus? status,
  }) {
    return AppSettingsState(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      fontScale: fontScale ?? this.fontScale,
      quranAudioReciter: quranAudioReciter ?? this.quranAudioReciter,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    notificationsEnabled,
    fontScale,
    quranAudioReciter,
    status,
  ];
}
