import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith_category.dart';
import 'package:qareeb/features/hadith/presentation/cubit/hadith_category_cubit.dart';
import 'package:qareeb/features/hadith/presentation/cubit/hadith_category_state.dart';
import 'package:qareeb/features/hadith/presentation/widgets/hadith_detail_sheet.dart';
import 'package:qareeb/features/hadith/presentation/widgets/hadith_list_tile.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class HadithCategoryPage extends StatelessWidget {
  const HadithCategoryPage({super.key, required this.category});

  final HadithCategory category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HadithCategoryCubit>()..load(category),
      child: _HadithCategoryView(category: category),
    );
  }
}

class _HadithCategoryView extends StatelessWidget {
  const _HadithCategoryView({required this.category});

  final HadithCategory category;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabicLocale =
        Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(category.titleFor(isArabicLocale: isArabicLocale)),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              Responsive.horizontalPadding(context),
              8,
              Responsive.horizontalPadding(context),
              0,
            ),
            child: Text(
              category.descriptionFor(isArabicLocale: isArabicLocale),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.navy.withValues(alpha: 0.65),
              ),
              textDirection:
                  isArabicLocale ? TextDirection.rtl : TextDirection.ltr,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              Responsive.horizontalPadding(context),
              8,
              Responsive.horizontalPadding(context),
              8,
            ),
            child: BlocBuilder<HadithCategoryCubit, HadithCategoryState>(
              buildWhen: (previous, current) =>
                  previous.searchQuery != current.searchQuery,
              builder: (context, state) {
                return SearchBar(
                  hintText: l10n.hadithFilterCategoryHint,
                  leading: const Icon(Icons.search),
                  onChanged: context.read<HadithCategoryCubit>().setSearchQuery,
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<HadithCategoryCubit, HadithCategoryState>(
              builder: (context, state) {
                if (state.status == HadithCategoryStatus.loading &&
                    state.hadiths.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.gold),
                  );
                }

                if (state.status == HadithCategoryStatus.failure &&
                    state.hadiths.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.errorMessage ?? l10n.hadithError,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => context
                              .read<HadithCategoryCubit>()
                              .load(category),
                          child: Text(l10n.quranSyncRetry),
                        ),
                      ],
                    ),
                  );
                }

                final hadiths = state.visibleHadiths;
                if (hadiths.isEmpty) {
                  return Center(child: Text(l10n.hadithNoResults));
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.horizontalPadding(context),
                    vertical: 8,
                  ),
                  itemCount: hadiths.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: AppColors.navy.withValues(alpha: 0.12),
                  ),
                  itemBuilder: (context, index) {
                    final hadith = hadiths[index];
                    return HadithListTile(
                      hadith: hadith,
                      isArabicLocale: isArabicLocale,
                      showCollectionName: true,
                      onTap: () =>
                          showHadithDetailSheet(context: context, hadith: hadith),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
