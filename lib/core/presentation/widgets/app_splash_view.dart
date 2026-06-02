import 'package:flutter/material.dart';
import 'package:qareeb/core/constants/asset_paths.dart';
import 'package:qareeb/core/theme/app_theme.dart';

/// Branded splash layout matching the native launch screen.
class AppSplashView extends StatelessWidget {
  const AppSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Image(
            image: AssetImage(AssetPaths.splashIcon),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
