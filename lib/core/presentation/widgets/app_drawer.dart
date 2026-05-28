import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qareeb/core/constants/asset_paths.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/adhan/presentation/pages/adhan_page.dart';
import 'package:qareeb/features/asma_ul_husna/presentation/pages/asma_ul_husna_page.dart';
import 'package:qareeb/features/duaa/presentation/pages/duaa_categories_page.dart';
import 'package:qareeb/features/hadith/presentation/pages/hadith_collections_page.dart';
import 'package:qareeb/features/home/presentation/pages/surah_list_page.dart';
import 'package:qareeb/features/nearby_mosques/presentation/pages/nearby_mosques_page.dart';
import 'package:qareeb/features/qibla/presentation/pages/qibla_page.dart';
import 'package:qareeb/features/quran/presentation/pages/juz_list_page.dart';
import 'package:qareeb/features/quran/presentation/widgets/audio_reciter_picker_sheet.dart';
import 'package:qareeb/features/settings/presentation/pages/settings_page.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(20),
          bottomEnd: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DrawerHeader(
              title: l10n.appTitle,
              tagline: l10n.drawerTagline,
              isDark: isDark,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  Responsive.spacing(context, 12),
                  Responsive.spacing(context, 8),
                  Responsive.spacing(context, 12),
                  Responsive.spacing(context, 4),
                ),
                children: [
                  _DrawerSectionLabel(title: l10n.drawerSectionQuran),
                  _DrawerNavTile(
                    icon: Icons.menu_book_rounded,
                    label: l10n.drawerSurahs,
                    onTap: () => _openPage(context, const SurahListPage()),
                  ),
                  _DrawerNavTile(
                    icon: Icons.bookmark_rounded,
                    label: l10n.drawerJuz,
                    onTap: () => _openPage(context, const JuzListPage()),
                  ),
                  _DrawerNavTile(
                    icon: Icons.record_voice_over_rounded,
                    label: l10n.drawerSelectReciter,
                    onTap: () {
                      Navigator.of(context).pop();
                      showAudioReciterPickerSheet(context);
                    },
                  ),
                  SizedBox(height: Responsive.spacing(context, 4)),
                  _DrawerSectionLabel(title: l10n.drawerSectionWorship),
                  _DrawerNavTile(
                    icon: Icons.mosque_rounded,
                    label: l10n.drawerAdhan,
                    onTap: () => _openPage(context, const AdhanPage()),
                  ),
                  _DrawerNavTile(
                    icon: Icons.explore_rounded,
                    label: l10n.drawerQibla,
                    onTap: () => _openPage(context, const QiblaPage()),
                  ),
                  _DrawerNavTile(
                    icon: Icons.map_rounded,
                    label: l10n.drawerNearbyMosques,
                    onTap: () => _openPage(context, const NearbyMosquesPage()),
                  ),
                  SizedBox(height: Responsive.spacing(context, 4)),
                  _DrawerSectionLabel(title: l10n.drawerSectionKnowledge),
                  _DrawerNavTile(
                    icon: Icons.auto_awesome_rounded,
                    label: l10n.drawerAsmaUlHusna,
                    onTap: () => _openPage(context, const AsmaUlHusnaPage()),
                  ),
                  _DrawerNavTile(
                    icon: Icons.volunteer_activism_rounded,
                    label: l10n.drawerDuaa,
                    onTap: () => _openPage(context, const DuaaCategoriesPage()),
                  ),
                  _DrawerNavTile(
                    icon: Icons.format_quote_rounded,
                    label: l10n.drawerHadith,
                    onTap: () =>
                        _openPage(context, const HadithCollectionsPage()),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _DrawerFooter(
              settingsLabel: l10n.drawerSettings,
              onSettingsTap: () => _openPage(context, const SettingsPage()),
            ),
          ],
        ),
      ),
    );
  }

  static void _openPage(BuildContext context, Widget page) {
    Navigator.of(context)
      ..pop()
      ..push(MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    required this.title,
    required this.tagline,
    required this.isDark,
  });

  final String title;
  final String tagline;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.spacing(context, 20);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: isDark
              ? [const Color(0xFF243447), AppColors.navy]
              : [AppColors.navy, const Color(0xFF2A3F54)],
        ),
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            top: -28,
            end: -28,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withValues(alpha: 0.08),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: -36,
            start: -20,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              padding,
              padding,
              padding,
              padding + 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(Responsive.spacing(context, 10)),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Image.asset(
                    AssetPaths.appIcon,
                    width: Responsive.spacing(context, 40),
                    height: Responsive.spacing(context, 40),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, 14)),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, 6)),
                Text(
                  tagline,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                    height: 1.35,
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, 14)),
                Container(
                  height: 3,
                  width: Responsive.spacing(context, 36),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerSectionLabel extends StatelessWidget {
  const _DrawerSectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Responsive.spacing(context, 8),
        Responsive.spacing(context, 12),
        Responsive.spacing(context, 8),
        Responsive.spacing(context, 6),
      ),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _DrawerNavTile extends StatelessWidget {
  const _DrawerNavTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(14);
    final horizontalInset = Responsive.spacing(context, 4);

    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.spacing(context, 4)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalInset,
              vertical: Responsive.spacing(context, 2),
            ),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: radius,
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.45,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.spacing(context, 12),
                  vertical: Responsive.spacing(context, 10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: Responsive.spacing(context, 40),
                      height: Responsive.spacing(context, 40),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: colorScheme.primary,
                        size: Responsive.spacing(context, 22),
                      ),
                    ),
                    SizedBox(width: Responsive.spacing(context, 12)),
                    Expanded(
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? Icons.chevron_left_rounded
                          : Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: Responsive.spacing(context, 22),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter({
    required this.settingsLabel,
    required this.onSettingsTap,
  });

  final String settingsLabel;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Responsive.spacing(context, 12),
        Responsive.spacing(context, 8),
        Responsive.spacing(context, 12),
        Responsive.spacing(context, 12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DrawerNavTile(
            icon: Icons.settings_rounded,
            label: settingsLabel,
            onTap: onSettingsTap,
          ),
          SizedBox(height: Responsive.spacing(context, 4)),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.data?.version;
              if (version == null) {
                return const SizedBox.shrink();
              }

              return Center(
                child: Text(
                  'v$version',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
