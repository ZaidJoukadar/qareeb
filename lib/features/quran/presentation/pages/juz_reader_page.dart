import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/locale/presentation/cubit/locale_cubit.dart';
import 'package:qareeb/core/quran/quran_reader_locale.dart';
import 'package:qareeb/features/quran/presentation/cubit/mushaf_book_reader_cubit.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qareeb/features/quran/presentation/utils/juz_label.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_book_reader.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_reader_locale_listener.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class JuzReaderPage extends StatelessWidget {
  const JuzReaderPage({
    required this.juzNumber,
    required this.initialPage,
    super.key,
  });

  final int juzNumber;
  final int initialPage;

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
        final title = JuzLabel.format(
          juzNumber: juzNumber,
          isArabic: isArabicLocale,
        );

        return BlocProvider(
          key: ValueKey('juz-reader-$juzNumber-$languageCode'),
          create: (_) => getIt<MushafBookReaderCubit>(
            param1: MushafBookReaderParams(
              initialPage: initialPage,
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
                title,
                textDirection:
                    isArabicLocale ? TextDirection.rtl : TextDirection.ltr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: QuranReaderTheme.ornamentGoldOf(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              centerTitle: true,
            ),
            body: BlocBuilder<MushafBookReaderCubit, MushafBookReaderState>(
              builder: (context, state) {
                if (state.status == MushafBookReaderStatus.failure) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.errorMessage ?? context.l10n.surahListError,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () {
                            context.read<MushafBookReaderCubit>().load();
                          },
                          child: Text(context.l10n.quranSyncRetry),
                        ),
                      ],
                    ),
                  );
                }

                return const MushafReaderLocaleListener(
                  child: MushafBookReaderContent(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
