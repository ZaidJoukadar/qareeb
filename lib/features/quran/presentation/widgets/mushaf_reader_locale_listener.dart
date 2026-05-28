import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/locale/presentation/cubit/locale_cubit.dart';
import 'package:qareeb/core/quran/quran_reader_locale.dart';
import 'package:qareeb/features/quran/presentation/cubit/mushaf_book_reader_cubit.dart';

/// Keeps [MushafBookReaderCubit] translation visibility aligned with [LocaleCubit].
class MushafReaderLocaleListener extends StatelessWidget {
  const MushafReaderLocaleListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocaleCubit, LocaleState>(
      listenWhen: (previous, current) =>
          previous.locale?.languageCode != current.locale?.languageCode,
      listener: (context, localeState) {
        final languageCode = QuranReaderLocale.languageCodeFrom(
          localeState.locale,
          Localizations.localeOf(context),
        );
        context.read<MushafBookReaderCubit>().setShowTranslation(
          QuranReaderLocale.showTranslationFor(languageCode),
        );
      },
      child: child,
    );
  }
}
