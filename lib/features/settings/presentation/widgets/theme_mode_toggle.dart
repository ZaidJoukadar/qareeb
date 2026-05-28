import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

class ThemeModeToggle extends StatelessWidget {
  const ThemeModeToggle({
    super.key,
    required this.themeMode,
    required this.onChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedToggleSwitch<ThemeMode>.dual(
      current: themeMode,
      first: ThemeMode.light,
      second: ThemeMode.dark,
      indicatorSize: const Size(40, 36),
      height: 40,
      spacing: 36,
      borderWidth: 0,
      loading: false,
      iconBuilder: (mode) => Icon(
        mode == ThemeMode.dark
            ? Icons.dark_mode_outlined
            : Icons.light_mode_outlined,
        size: 20,
        color: mode == themeMode
            ? colorScheme.onPrimary
            : colorScheme.onSurfaceVariant,
      ),
      style: ToggleStyle(
        backgroundColor: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      styleBuilder: (mode) => ToggleStyle(
        indicatorColor: colorScheme.primary,
        indicatorBorderRadius: BorderRadius.circular(18),
      ),
      onChanged: onChanged,
    );
  }
}
