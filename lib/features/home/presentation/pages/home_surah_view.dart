import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/locale/presentation/cubit/locale_cubit.dart';
import 'package:qareeb/core/quran/quran_reader_locale.dart';
import 'package:qareeb/features/quran/presentation/cubit/ayah_reader_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/home_surah_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/home_surah_state.dart';
import 'package:qareeb/features/quran/presentation/widgets/surah_reader_body.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class HomeSurahView extends StatelessWidget {
  const HomeSurahView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<HomeSurahCubit>()..load(),
      child: BlocBuilder<HomeSurahCubit, HomeSurahState>(
        builder: (context, state) {
          switch (state.status) {
            case HomeSurahStatus.initial:
            case HomeSurahStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case HomeSurahStatus.failure:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.errorMessage ?? l10n.surahListError),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        context.read<HomeSurahCubit>().load();
                      },
                      child: Text(l10n.quranSyncRetry),
                    ),
                  ],
                ),
              );
            case HomeSurahStatus.success:
              final surah = state.surah!;

              return BlocBuilder<LocaleCubit, LocaleState>(
                buildWhen: (previous, current) =>
                    previous.locale != current.locale,
                builder: (context, localeState) {
                  final languageCode = QuranReaderLocale.languageCodeFrom(
                    localeState.locale,
                    Localizations.localeOf(context),
                  );
                  final showTranslation =
                      QuranReaderLocale.showTranslationFor(languageCode);

                  return BlocProvider(
                    key: ValueKey('home-surah-$languageCode'),
                    create: (_) => getIt<AyahReaderCubit>(
                      param1: surah,
                      param2: showTranslation,
                    )..load(),
                    child: SurahReaderBody(
                      surah: surah,
                      showTranslation: showTranslation,
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
