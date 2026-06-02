import 'package:flutter/material.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/core/theme/app_theme.dart';

/// Uppercase section label matching the navigation drawer style.
class SettingsSectionLabel extends StatelessWidget {
  const SettingsSectionLabel({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Responsive.horizontalPadding(context) + Responsive.spacing(context, 4),
        Responsive.spacing(context, 20),
        Responsive.horizontalPadding(context) + Responsive.spacing(context, 4),
        Responsive.spacing(context, 8),
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

/// Rounded card grouping one or more settings rows.
class SettingsSectionCard extends StatelessWidget {
  const SettingsSectionCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final horizontal = Responsive.horizontalPadding(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children.asMap().entries.expand((entry) {
              final index = entry.key;
              final child = entry.value;
              return [
                if (index > 0)
                  Divider(
                    height: 1,
                    indent: Responsive.spacing(context, 68),
                    endIndent: Responsive.spacing(context, 16),
                    color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                  ),
                child,
              ];
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class SettingsIconBadge extends StatelessWidget {
  const SettingsIconBadge({
    required this.icon,
    super.key,
    this.iconColor,
    this.backgroundColor,
  });

  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = Responsive.spacing(context, 40);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: iconColor ?? colorScheme.primary,
        size: Responsive.spacing(context, 22),
      ),
    );
  }
}

class SettingsNavRow extends StatelessWidget {
  const SettingsNavRow({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
    this.subtitle,
    this.trailingLabel,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? trailingLabel;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return _SettingsRowShell(
      enabled: enabled,
      onTap: enabled ? onTap : null,
      child: _SettingsRowContent(
        icon: icon,
        title: title,
        subtitle: subtitle,
        trailing: trailingLabel != null
            ? SettingsValueChip(label: trailingLabel!)
            : null,
        showChevron: true,
      ),
    );
  }
}

class SettingsSwitchRow extends StatelessWidget {
  const SettingsSwitchRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsRowShell(
      child: _SettingsRowContent(
        icon: icon,
        title: title,
        subtitle: subtitle,
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class SettingsCustomRow extends StatelessWidget {
  const SettingsCustomRow({
    required this.icon,
    required this.title,
    required this.trailing,
    super.key,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return _SettingsRowShell(
      child: _SettingsRowContent(
        icon: icon,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
      ),
    );
  }
}

class SettingsActionRow extends StatelessWidget {
  const SettingsActionRow({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
    this.subtitle,
    this.trailingIcon = Icons.chevron_right_rounded,
    this.destructive = false,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final IconData trailingIcon;
  final bool destructive;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accent = destructive ? colorScheme.error : colorScheme.primary;

    return _SettingsRowShell(
      enabled: enabled,
      onTap: enabled ? onTap : null,
      child: _SettingsRowContent(
        icon: icon,
        title: title,
        subtitle: subtitle,
        iconColor: accent,
        iconBackgroundColor: accent.withValues(alpha: 0.12),
        trailing: Icon(
          trailingIcon,
          color: enabled
              ? colorScheme.onSurfaceVariant
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
          size: Responsive.spacing(context, 22),
        ),
      ),
    );
  }
}

class SettingsValueChip extends StatelessWidget {
  const SettingsValueChip({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.spacing(context, 10),
        vertical: Responsive.spacing(context, 4),
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SettingsFontScaleCard extends StatelessWidget {
  const SettingsFontScaleCard({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.valueLabel,
    required this.onChanged,
    super.key,
  });

  final String title;
  final double value;
  final double min;
  final double max;
  final String valueLabel;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final padding = Responsive.spacing(context, 16);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SettingsIconBadge(icon: Icons.format_size_rounded),
              SizedBox(width: Responsive.spacing(context, 12)),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SettingsValueChip(label: valueLabel),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, 4)),
          Padding(
            padding: EdgeInsets.only(left: Responsive.spacing(context, 52)),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: colorScheme.primary,
                inactiveTrackColor:
                    colorScheme.primary.withValues(alpha: 0.2),
                thumbColor: colorScheme.primary,
                overlayColor: colorScheme.primary.withValues(alpha: 0.12),
                trackHeight: 4,
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: ((max - min) / 0.05).round(),
                label: valueLabel,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPageHeader extends StatelessWidget {
  const SettingsPageHeader({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final padding = Responsive.horizontalPadding(context);

    return Container(
      margin: EdgeInsets.fromLTRB(
        padding,
        Responsive.spacing(context, 8),
        padding,
        Responsive.spacing(context, 4),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: isDark
              ? [
                  const Color(0xFF243447),
                  AppColors.navy,
                ]
              : [
                  AppColors.navy,
                  const Color(0xFF2A3F54),
                ],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            top: -20,
            end: -16,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withValues(alpha: 0.1),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Responsive.spacing(context, 20)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Responsive.spacing(context, 12)),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: AppColors.gold,
                    size: Responsive.spacing(context, 28),
                  ),
                ),
                SizedBox(width: Responsive.spacing(context, 16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: Responsive.spacing(context, 6)),
                      Container(
                        height: 3,
                        width: Responsive.spacing(context, 32),
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
          ),
        ],
      ),
    );
  }
}

class _SettingsRowShell extends StatelessWidget {
  const _SettingsRowShell({
    required this.child,
    this.onTap,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final content = Opacity(
      opacity: enabled ? 1 : 0.45,
      child: child,
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: content,
      ),
    );
  }
}

class _SettingsRowContent extends StatelessWidget {
  const _SettingsRowContent({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.showChevron = false,
    this.iconColor,
    this.iconBackgroundColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool showChevron;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.spacing(context, 16),
        vertical: Responsive.spacing(context, 12),
      ),
      child: Row(
        crossAxisAlignment: subtitle != null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          SettingsIconBadge(
            icon: icon,
            iconColor: iconColor,
            backgroundColor: iconBackgroundColor,
          ),
          SizedBox(width: Responsive.spacing(context, 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: Responsive.spacing(context, 4)),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: Responsive.spacing(context, 8)),
            trailing!,
          ],
          if (showChevron) ...[
            SizedBox(width: Responsive.spacing(context, 4)),
            Icon(
              isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant,
              size: Responsive.spacing(context, 22),
            ),
          ],
        ],
      ),
    );
  }
}
