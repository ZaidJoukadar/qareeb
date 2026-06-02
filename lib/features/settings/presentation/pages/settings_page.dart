import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qareeb/core/config/environment.dart';
import 'package:qareeb/core/constants/font_scale_defaults.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/locale/app_supported_languages.dart';
import 'package:qareeb/core/monitoring/app_feedback.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/core/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:qareeb/features/quran/data/datasources/ayah_insight_cache_local_data_source.dart';
import 'package:qareeb/features/quran/data/datasources/quran_audio_cache_data_source.dart';
import 'package:qareeb/features/settings/presentation/widgets/language_picker_sheet.dart';
import 'package:qareeb/features/settings/presentation/widgets/settings_ui.dart';
import 'package:qareeb/features/settings/presentation/widgets/theme_mode_toggle.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentLocale = Localizations.localeOf(context);
    final currentLanguage = languageForLocale(currentLocale);

    return Scaffold(
      appBar: AppBar(
        title: const SizedBox.shrink(),
        centerTitle: false,
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: Responsive.spacing(context, 24)),
        children: [
          SettingsPageHeader(title: l10n.settingsTitle),
          SettingsSectionLabel(title: l10n.settingsLanguageSection),
          SettingsSectionCard(
            children: [
              SettingsNavRow(
                icon: Icons.language_rounded,
                title: l10n.settingsLanguageSection,
                trailingLabel: currentLanguage.nativeName,
                onTap: () => showLanguagePickerSheet(context),
              ),
            ],
          ),
          SettingsSectionLabel(title: l10n.settingsThemeSection),
          SettingsSectionCard(
            children: [
              BlocBuilder<AppSettingsCubit, AppSettingsState>(
                buildWhen: (previous, current) =>
                    previous.themeMode != current.themeMode,
                builder: (context, settingsState) {
                  return SettingsCustomRow(
                    icon: settingsState.themeMode == ThemeMode.dark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    title: l10n.settingsDarkMode,
                    trailing: ThemeModeToggle(
                      themeMode: settingsState.themeMode,
                      onChanged:
                          context.read<AppSettingsCubit>().setThemeMode,
                    ),
                  );
                },
              ),
            ],
          ),
          SettingsSectionLabel(title: l10n.settingsFontSizeSection),
          SettingsSectionCard(
            children: [
              BlocBuilder<AppSettingsCubit, AppSettingsState>(
                buildWhen: (previous, current) =>
                    previous.appFontScale != current.appFontScale ||
                    previous.quranFontScale != current.quranFontScale,
                builder: (context, settingsState) {
                  final cubit = context.read<AppSettingsCubit>();
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SettingsFontScaleCard(
                        title: l10n.settingsAppFontSize,
                        value: settingsState.appFontScale,
                        min: FontScaleDefaults.min,
                        max: FontScaleDefaults.max,
                        valueLabel: l10n.settingsFontSizeValue(
                          (settingsState.appFontScale * 100).round(),
                        ),
                        onChanged: cubit.setAppFontScale,
                      ),
                      SettingsFontScaleCard(
                        title: l10n.settingsQuranReaderFontSize,
                        value: settingsState.quranFontScale,
                        min: FontScaleDefaults.min,
                        max: FontScaleDefaults.max,
                        valueLabel: l10n.settingsFontSizeValue(
                          (settingsState.quranFontScale * 100).round(),
                        ),
                        onChanged: cubit.setQuranFontScale,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          SettingsSectionLabel(title: l10n.settingsNotificationsSection),
          SettingsSectionCard(
            children: [
              BlocBuilder<AppSettingsCubit, AppSettingsState>(
                buildWhen: (previous, current) =>
                    previous.notificationsEnabled !=
                    current.notificationsEnabled,
                builder: (context, settingsState) {
                  return SettingsSwitchRow(
                    icon: Icons.notifications_rounded,
                    title: l10n.settingsNotificationsEnabled,
                    value: settingsState.notificationsEnabled,
                    onChanged: (enabled) {
                      context
                          .read<AppSettingsCubit>()
                          .setNotificationsEnabled(enabled);
                    },
                  );
                },
              ),
            ],
          ),
          SettingsSectionLabel(title: l10n.settingsStorageSection),
          SettingsSectionCard(
            children: [
              SettingsActionRow(
                icon: Icons.delete_outline_rounded,
                title: l10n.settingsClearCache,
                subtitle: l10n.settingsClearCacheDescription,
                destructive: true,
                onTap: () => _confirmClearCache(context),
              ),
            ],
          ),
          SettingsSectionLabel(title: l10n.settingsContactSection),
          SettingsSectionCard(
            children: [
              SettingsActionRow(
                icon: Icons.bug_report_rounded,
                title: l10n.settingsReportBug,
                subtitle: l10n.settingsReportBugDescription,
                enabled: Environment.current.isSentryEnabled,
                onTap: () => AppFeedback.show(context),
              ),
              SettingsActionRow(
                icon: Icons.mail_outline_rounded,
                title: l10n.settingsContactUs,
                trailingIcon: Icons.open_in_new_rounded,
                onTap: () => _openContactUs(context),
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, 16)),
          const _SettingsVersionFooter(),
        ],
      ),
    );
  }

  Future<void> _confirmClearCache(BuildContext context) async {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(l10n.settingsClearCacheConfirmTitle),
          content: Text(l10n.settingsClearCacheConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.settingsClearCacheCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.settingsClearCacheConfirmAction),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await Future.wait([
        getIt<QuranAudioCacheDataSource>().clearAll(),
        getIt<AyahInsightCacheLocalDataSource>().clearAll(),
      ]);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsClearCacheSuccess)),
      );
    } on Object {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsClearCacheError)),
      );
    }
  }

  Future<void> _openContactUs(BuildContext context) async {
    final uri = Uri.parse(Environment.current.supportUrl);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!context.mounted || launched) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.settingsContactUsError)),
    );
  }
}

class _SettingsVersionFooter extends StatelessWidget {
  const _SettingsVersionFooter();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final packageInfo = snapshot.data;
        if (packageInfo == null) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            Text(
              l10n.appTitle,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Responsive.spacing(context, 4)),
            Text(
              'v${packageInfo.version} (${packageInfo.buildNumber})',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        );
      },
    );
  }
}
