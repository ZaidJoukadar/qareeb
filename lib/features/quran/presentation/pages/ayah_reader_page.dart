import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/locale/presentation/cubit/locale_cubit.dart';
import 'package:qareeb/core/quran/quran_reader_locale.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/presentation/cubit/mushaf_book_reader_cubit.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_book_reader.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_reader_locale_listener.dart';

class AyahReaderPage extends StatelessWidget {
  const AyahReaderPage({required this.surah, super.key});

  final Surah surah;

  @override
  Widget build(BuildContext context) {
    final pageBackground = QuranReaderTheme.pageBackgroundOf(context);

    return BlocBuilder<LocaleCubit, LocaleState>(
      buildWhen: (previous, current) => previous.locale != current.locale,
      builder: (context, localeState) {
        final languageCode = QuranReaderLocale.languageCodeFrom(
          localeState.locale,
          Localizations.localeOf(context),
        );
        final isArabicLocale = languageCode == 'ar';
        final showTranslation =
            QuranReaderLocale.showTranslationFor(languageCode);

        return BlocProvider(
          key: ValueKey('ayah-reader-${surah.number}-$languageCode'),
          create: (_) => getIt<MushafBookReaderCubit>(
            param1: MushafBookReaderParams(
              initialSurahNumber: surah.number,
              showTranslation: showTranslation,
            ),
          )..load(),
          child: Scaffold(
            backgroundColor: pageBackground,
            appBar: AppBar(
              backgroundColor: pageBackground,
              foregroundColor: QuranReaderTheme.arabicTextOf(context),
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text(
                isArabicLocale ? surah.nameArabic : surah.nameEnglish,
                textDirection:
                    isArabicLocale ? TextDirection.rtl : TextDirection.ltr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: QuranReaderTheme.ornamentGoldOf(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              centerTitle: true,
            ),
            body: const MushafReaderLocaleListener(
              child: MushafBookReaderContent(),
            ),
          ),
        );
      },
    );
  }
}
