import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/locale/presentation/cubit/locale_cubit.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (locale) {
              context.read<LocaleCubit>().setLocale(locale);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const Locale('en'),
                child: Text(l10n.languageEnglish),
              ),
              PopupMenuItem(
                value: const Locale('ar'),
                child: Text(l10n.languageArabic),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Text(
          l10n.homeTitle,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
