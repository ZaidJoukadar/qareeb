import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/features/quran/presentation/cubit/surah_list_cubit.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/presentation/cubit/surah_list_state.dart';
import 'package:qareeb/features/quran/presentation/pages/ayah_reader_page.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qareeb/features/quran/presentation/utils/arabic_numerals.dart';
import 'package:qareeb/features/quran/presentation/utils/surah_header_text.dart';
import 'package:qareeb/features/quran/presentation/widgets/surah_revelation_type_icon.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart' hide Ayah, Surah;

class SurahListPage extends StatelessWidget {
  const SurahListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.surahListTitle),
      ),
      body: BlocProvider(
        create: (_) => getIt<SurahListCubit>()..load(),
        child: const SurahListView(),
      ),
    );
  }
}

class SurahListView extends StatelessWidget {
  const SurahListView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabicLocale = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            Responsive.horizontalPadding(context),
            8,
            Responsive.horizontalPadding(context),
            8,
          ),
          child: BlocBuilder<SurahListCubit, SurahListState>(
            buildWhen: (previous, current) =>
                previous.searchQuery != current.searchQuery,
            builder: (context, state) {
              return SearchBar(
                hintText: l10n.surahListSearchHint,
                leading: const Icon(Icons.search),
                onChanged: context.read<SurahListCubit>().setSearchQuery,
              );
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<SurahListCubit, SurahListState>(
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
            final surahs = state.filteredSurahs(isArabicLocale: isArabicLocale);
            if (surahs.isEmpty) {
              return Center(child: Text(l10n.surahListNoResults));
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
                vertical: Responsive.spacing(context, 8),
              ),
              itemCount: surahs.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                color: QuranReaderTheme.ornamentBorderOf(context).withValues(
                  alpha: 0.4,
                ),
              ),
              itemBuilder: (context, index) {
                final surah = surahs[index];
                final readCount = state.readCountFor(surah);
                final isFullyRead = state.isSurahFullyRead(surah);

                return InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => AyahReaderPage(surah: surah),
                      ),
                    );
                    if (context.mounted) {
                      context.read<SurahListCubit>().load();
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: isArabicLocale
                        ? _ArabicSurahRow(
                            surah: surah,
                            ayahCountLabel: l10n.ayahCountLabel,
                            readCount: readCount,
                            isFullyRead: isFullyRead,
                            readProgressLabel: l10n.readProgressLabel(
                              readCount,
                              surah.ayahCount,
                            ),
                            makkiLabel: l10n.surahRevelationMakki,
                            madaniLabel: l10n.surahRevelationMadani,
                          )
                        : _EnglishSurahRow(
                            surah: surah,
                            ayahCountLabel: l10n.ayahCountLabel,
                            readCount: readCount,
                            isFullyRead: isFullyRead,
                            readProgressLabel: l10n.readProgressLabel(
                              readCount,
                              surah.ayahCount,
                            ),
                            makkiLabel: l10n.surahRevelationMakki,
                            madaniLabel: l10n.surahRevelationMadani,
                          ),
                  ),
                );
              },
            );
        }
            },
          ),
        ),
      ],
    );
  }
}

class _ArabicSurahRow extends StatelessWidget {
  const _ArabicSurahRow({
    required this.surah,
    required this.ayahCountLabel,
    required this.readCount,
    required this.isFullyRead,
    required this.readProgressLabel,
    required this.makkiLabel,
    required this.madaniLabel,
  });

  final Surah surah;
  final String ayahCountLabel;
  final int readCount;
  final bool isFullyRead;
  final String readProgressLabel;
  final String makkiLabel;
  final String madaniLabel;

  @override
  Widget build(BuildContext context) {
    final shortName = SurahHeaderText.shortSurahName(
      surahNumber: surah.number,
      nameArabic: surah.nameArabic,
      isArabic: true,
    );

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: QuranReaderTheme.markerFillOf(context),
          child: Text(
            '${surah.number}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: QuranReaderTheme.ornamentGoldOf(context),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                shortName,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: QuranTextStyles.hafsStyle(
                  fontSize: 24,
                  color: QuranReaderTheme.arabicTextOf(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${toArabicIndicNumerals(surah.ayahCount)} $ayahCountLabel',
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: QuranReaderTheme.translationTextOf(context),
                ),
              ),
              const SizedBox(height: 2),
              SurahRevelationTypeLabel(
                revelationType: surah.revelationType,
                makkiLabel: makkiLabel,
                madaniLabel: madaniLabel,
                textDirection: TextDirection.rtl,
              ),
              if (readCount > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      readProgressLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: QuranReaderTheme.translationTextOf(context),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isFullyRead ? Icons.flag : Icons.outlined_flag,
                      size: 16,
                      color: QuranReaderTheme.readFlagOf(context),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Icon(
          Icons.chevron_left,
          color: QuranReaderTheme.ornamentGoldOf(context),
        ),
      ],
    );
  }
}

class _EnglishSurahRow extends StatelessWidget {
  const _EnglishSurahRow({
    required this.surah,
    required this.ayahCountLabel,
    required this.readCount,
    required this.isFullyRead,
    required this.readProgressLabel,
    required this.makkiLabel,
    required this.madaniLabel,
  });

  final Surah surah;
  final String ayahCountLabel;
  final int readCount;
  final bool isFullyRead;
  final String readProgressLabel;
  final String makkiLabel;
  final String madaniLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: QuranReaderTheme.markerFillOf(context),
          child: Text(
            '${surah.number}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: QuranReaderTheme.ornamentGoldOf(context),
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
                  color: QuranReaderTheme.arabicTextOf(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${surah.nameTranslated} · ${surah.ayahCount} $ayahCountLabel',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: QuranReaderTheme.translationTextOf(context),
                ),
              ),
              const SizedBox(height: 2),
              SurahRevelationTypeLabel(
                revelationType: surah.revelationType,
                makkiLabel: makkiLabel,
                madaniLabel: madaniLabel,
              ),
              if (readCount > 0) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      isFullyRead ? Icons.flag : Icons.outlined_flag,
                      size: 16,
                      color: QuranReaderTheme.readFlagOf(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      readProgressLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: QuranReaderTheme.readFlagOf(context),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Icon(
          Icons.chevron_right,
          color: QuranReaderTheme.ornamentGoldOf(context),
        ),
      ],
    );
  }
}
