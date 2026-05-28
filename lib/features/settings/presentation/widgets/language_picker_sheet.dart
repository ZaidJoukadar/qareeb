import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/locale/app_supported_languages.dart';
import 'package:qareeb/core/locale/presentation/cubit/locale_cubit.dart';
import 'package:qareeb/core/presentation/bottom_sheets/app_bar_modal_bottom_sheet.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

Future<void> showLanguagePickerSheet(BuildContext context) {
  final currentLocale = Localizations.localeOf(context);

  return showAppBarModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) {
      final l10n = sheetContext.l10n;

      return SafeArea(
        child: RadioGroup<Locale>(
          groupValue: currentLocale,
          onChanged: (locale) {
            if (locale == null) return;
            sheetContext.read<LocaleCubit>().setLocale(locale);
            Navigator.of(sheetContext).pop();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  l10n.settingsSelectLanguage,
                  style: Theme.of(sheetContext).textTheme.titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              ...appSupportedLanguages
                  .map(
                    (language) => RadioListTile<Locale>(
                      title: Text(language.nativeName),
                      value: language.locale,
                    ),
                  ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}
