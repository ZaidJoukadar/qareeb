import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/locale/presentation/cubit/locale_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/surah_list_cubit.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/presentation/cubit/surah_list_state.dart';
import 'package:qareeb/features/quran/presentation/pages/ayah_reader_page.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qareeb/features/quran/presentation/utils/arabic_numerals.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart' hide Ayah, Surah;

class SurahListPage extends StatelessWidget {
  const SurahListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabicLocale = Localizations.localeOf(context).languageCode == 'ar';

    return BlocProvider(
      create: (_) => getIt<SurahListCubit>()..load(),
      child: Scaffold(
        backgroundColor: QuranReaderTheme.pageBackground,
        appBar: AppBar(
          backgroundColor: QuranReaderTheme.pageBackground,
          foregroundColor: QuranReaderTheme.arabicText,
          elevation: 0,
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
        body: BlocBuilder<SurahListCubit, SurahListState>(
          builder: (context, state) {
            switch (state.status) {
              case SurahListStatus.initial:
              case SurahListStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case SurahListStatus.failure:
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.errorMessage ?? l10n.surahListError),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          context.read<SurahListCubit>().load();
                        },
                        child: Text(l10n.quranSyncRetry),
                      ),
                    ],
                  ),
                );
              case SurahListStatus.success:
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: state.surahs.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: QuranReaderTheme.ornamentBorder.withValues(
                      alpha: 0.4,
                    ),
                  ),
                  itemBuilder: (context, index) {
                    final surah = state.surahs[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => AyahReaderPage(surah: surah),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: isArabicLocale
                            ? _ArabicSurahRow(surah: surah)
                            : _EnglishSurahRow(
                                surah: surah,
                                ayahCountLabel: l10n.ayahCountLabel,
                              ),
                      ),
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}

class _ArabicSurahRow extends StatelessWidget {
  const _ArabicSurahRow({required this.surah});

  final Surah surah;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(
            toArabicIndicNumerals(surah.number),
            textAlign: TextAlign.center,
            style: QuranTextStyles.surahHeaderStyle(
              fontSize: 22,
              color: QuranReaderTheme.ornamentGold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            surah.nameArabic,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: QuranTextStyles.hafsStyle(
              fontSize: 24,
              color: QuranReaderTheme.arabicText,
            ),
          ),
        ),
        Icon(
          Icons.chevron_left,
          color: QuranReaderTheme.ornamentGold,
        ),
      ],
    );
  }
}

class _EnglishSurahRow extends StatelessWidget {
  const _EnglishSurahRow({
    required this.surah,
    required this.ayahCountLabel,
  });

  final Surah surah;
  final String ayahCountLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: QuranReaderTheme.markerFill,
          child: Text(
            '${surah.number}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: QuranReaderTheme.ornamentGold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                surah.nameEnglish,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: QuranReaderTheme.arabicText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${surah.nameTranslated} · ${surah.ayahCount} $ayahCountLabel',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: QuranReaderTheme.translationText,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.chevron_right,
          color: QuranReaderTheme.ornamentGold,
        ),
      ],
    );
  }
}
