import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/features/quran/domain/usecases/get_first_page_for_juz.dart';
import 'package:qareeb/features/quran/presentation/cubit/juz_list_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/juz_list_state.dart';
import 'package:qareeb/features/quran/presentation/pages/juz_reader_page.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qareeb/features/quran/presentation/utils/juz_label.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class JuzListPage extends StatelessWidget {
  const JuzListPage({super.key});

  static const _juzCount = 30;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.juzListTitle),
      ),
      body: BlocProvider(
        create: (_) => getIt<JuzListCubit>()..load(),
        child: const JuzListView(),
      ),
    );
  }
}

class JuzListView extends StatelessWidget {
  const JuzListView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabicLocale = Localizations.localeOf(context).languageCode == 'ar';

    return BlocBuilder<JuzListCubit, JuzListState>(
      builder: (context, state) {
        if (state.status == JuzListStatus.loading &&
            state.surahCountByJuz.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == JuzListStatus.failure &&
            state.surahCountByJuz.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.errorMessage ?? l10n.surahListError),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.read<JuzListCubit>().load(),
                  child: Text(l10n.quranSyncRetry),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
            vertical: Responsive.spacing(context, 8),
          ),
          itemCount: JuzListPage._juzCount,
          separatorBuilder: (_, _) => Divider(
            height: 1,
            color: QuranReaderTheme.ornamentBorderOf(context).withValues(
              alpha: 0.4,
            ),
          ),
          itemBuilder: (context, index) {
            final juzNumber = index + 1;
            final label = JuzLabel.format(
              juzNumber: juzNumber,
              isArabic: isArabicLocale,
            );
            final surahCount = state.surahCountFor(juzNumber);
            final subtitle = surahCount == null
                ? null
                : l10n.juzSurahCountLabel(surahCount);

            return InkWell(
              onTap: () => _openJuz(context, juzNumber),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: QuranReaderTheme.markerFillOf(context),
                      child: Text(
                        '$juzNumber',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: QuranReaderTheme.ornamentGoldOf(context),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: isArabicLocale
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            textAlign: isArabicLocale
                                ? TextAlign.right
                                : TextAlign.start,
                            textDirection: isArabicLocale
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: QuranReaderTheme.arabicTextOf(context),
                                ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              textAlign: isArabicLocale
                                  ? TextAlign.right
                                  : TextAlign.start,
                              textDirection: isArabicLocale
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: QuranReaderTheme.translationTextOf(
                                      context,
                                    ),
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      isArabicLocale
                          ? Icons.chevron_left
                          : Icons.chevron_right,
                      color: QuranReaderTheme.ornamentGoldOf(context),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openJuz(BuildContext context, int juzNumber) async {
    final l10n = context.l10n;
    final page = await getIt<GetFirstPageForJuz>()(juzNumber);
    if (!context.mounted) return;

    if (page == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.surahListError)),
      );
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => JuzReaderPage(
          juzNumber: juzNumber,
          initialPage: page,
        ),
      ),
    );
  }
}
