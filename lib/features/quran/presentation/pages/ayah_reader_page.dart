import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/presentation/cubit/ayah_reader_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/ayah_reader_state.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_surah_body.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class AyahReaderPage extends StatelessWidget {
  const AyahReaderPage({required this.surah, super.key});

  final Surah surah;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabicLocale = locale.languageCode == 'ar';
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<AyahReaderCubit>(
        param1: surah,
        param2: !isArabicLocale,
      )..load(),
      child: Scaffold(
        backgroundColor: QuranReaderTheme.pageBackground,
        appBar: AppBar(
          backgroundColor: QuranReaderTheme.pageBackground,
          foregroundColor: QuranReaderTheme.arabicText,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            isArabicLocale ? surah.nameArabic : surah.nameEnglish,
            textDirection:
                isArabicLocale ? TextDirection.rtl : TextDirection.ltr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: QuranReaderTheme.ornamentGold,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<AyahReaderCubit, AyahReaderState>(
          builder: (context, state) {
            switch (state.status) {
              case AyahReaderStatus.initial:
              case AyahReaderStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case AyahReaderStatus.failure:
                return Center(child: Text(state.errorMessage ?? ''));
              case AyahReaderStatus.success:
                return Column(
                  children: [
                    if (state.audioError != null)
                      MaterialBanner(
                        content: Text(state.audioError!),
                        backgroundColor: Colors.red.shade50,
                        actions: [
                          TextButton(
                            onPressed: () {
                              context.read<AyahReaderCubit>().stopAudio();
                            },
                            child: Text(l10n.dismiss),
                          ),
                        ],
                      ),
                    Expanded(
                      child: MushafSurahBody(
                        surahNumber: surah.number,
                        surahNameArabic: surah.nameArabic,
                        showTranslation: !isArabicLocale,
                        headerTitle: isArabicLocale ? null : surah.nameEnglish,
                        headerTextDirection:
                            isArabicLocale ? null : TextDirection.ltr,
                        ayahs: state.ayahs,
                        playingAyahNumber: state.playingAyahNumber,
                        loadingAyahNumber: state.isAudioLoading
                            ? state.playingAyahNumber
                            : null,
                        onAyahTap: (ayahNumber) =>
                            _toggleAudio(context, state, ayahNumber),
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }

  void _toggleAudio(
    BuildContext context,
    AyahReaderState state,
    int ayahNumber,
  ) {
    final cubit = context.read<AyahReaderCubit>();
    if (state.playingAyahNumber == ayahNumber && !state.isAudioLoading) {
      cubit.stopAudio();
    } else {
      cubit.playAyah(ayahNumber);
    }
  }
}
