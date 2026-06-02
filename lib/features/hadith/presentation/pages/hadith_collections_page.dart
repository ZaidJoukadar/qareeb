import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith_category.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith_collection.dart';
import 'package:qareeb/features/hadith/presentation/cubit/hadith_collections_cubit.dart';
import 'package:qareeb/features/hadith/presentation/cubit/hadith_collections_state.dart';
import 'package:qareeb/features/hadith/presentation/pages/hadith_category_page.dart';
import 'package:qareeb/features/hadith/presentation/pages/hadith_collection_page.dart';
import 'package:qareeb/features/hadith/presentation/widgets/hadith_detail_sheet.dart';
import 'package:qareeb/features/hadith/presentation/widgets/hadith_list_tile.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class HadithCollectionsPage extends StatelessWidget {
  const HadithCollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HadithCollectionsCubit>()..load(),
      child: const _HadithCollectionsView(),
    );
  }
}

class _HadithCollectionsView extends StatelessWidget {
  const _HadithCollectionsView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabicLocale =
        Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.hadithTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              Responsive.horizontalPadding(context),
              8,
              Responsive.horizontalPadding(context),
              8,
            ),
            child: BlocBuilder<HadithCollectionsCubit, HadithCollectionsState>(
              buildWhen: (previous, current) =>
                  previous.searchQuery != current.searchQuery,
              builder: (context, state) {
                return SearchBar(
                  hintText: l10n.hadithSearchHint,
                  leading: const Icon(Icons.search),
                  onChanged:
                      context.read<HadithCollectionsCubit>().setSearchQuery,
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<HadithCollectionsCubit, HadithCollectionsState>(
              builder: (context, state) {
                if (state.isSearchActive) {
                  return _GlobalSearchResults(
                    state: state,
                    isArabicLocale: isArabicLocale,
                  );
                }

                if (state.status == HadithCollectionsStatus.loading &&
                    state.collections.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.gold),
                  );
                }

                final categories = state.filteredCategories;
                final collections = state.filteredCollections;

                if (categories.isEmpty && collections.isEmpty) {
                  return Center(child: Text(l10n.hadithNoResults));
                }

                return ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.horizontalPadding(context),
                    vertical: 8,
                  ),
                  children: [
                    if (categories.isNotEmpty) ...[
                      _SectionHeader(title: l10n.hadithSectionsTitle),
                      ...categories.map(
                        (category) => _CategoryTile(
                          category: category,
                          isArabicLocale: isArabicLocale,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (collections.isNotEmpty) ...[
                      _SectionHeader(title: l10n.hadithBooksTitle),
                      ...collections.map(
                        (collection) => _CollectionTile(
                          collection: collection,
                          isArabicLocale: isArabicLocale,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.gold,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _GlobalSearchResults extends StatelessWidget {
  const _GlobalSearchResults({
    required this.state,
    required this.isArabicLocale,
  });

  final HadithCollectionsState state;
  final bool isArabicLocale;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (state.status == HadithCollectionsStatus.loading &&
        state.searchResults.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.gold),
      );
    }

    if (state.status == HadithCollectionsStatus.failure &&
        state.searchResults.isEmpty) {
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
                  .read<HadithCollectionsCubit>()
                  .setSearchQuery(state.searchQuery),
              child: Text(l10n.quranSyncRetry),
            ),
          ],
        ),
      );
    }

    if (state.searchResults.isEmpty) {
      return Center(child: Text(l10n.hadithNoResults));
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: 8,
      ),
      itemCount: state.searchResults.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        color: AppColors.navy.withValues(alpha: 0.12),
      ),
      itemBuilder: (context, index) {
        final hadith = state.searchResults[index];
        return HadithListTile(
          hadith: hadith,
          isArabicLocale: isArabicLocale,
          showCollectionName: true,
          onTap: () => showHadithDetailSheet(context: context, hadith: hadith),
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.isArabicLocale,
  });

  final HadithCategory category;
  final bool isArabicLocale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => HadithCategoryPage(category: category),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.titleFor(isArabicLocale: isArabicLocale),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: isArabicLocale
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.descriptionFor(isArabicLocale: isArabicLocale),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.navy.withValues(alpha: 0.65),
                    ),
                    textDirection: isArabicLocale
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.navy.withValues(alpha: 0.35),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionTile extends StatelessWidget {
  const _CollectionTile({
    required this.collection,
    required this.isArabicLocale,
  });

  final HadithCollection collection;
  final bool isArabicLocale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => HadithCollectionPage(collection: collection),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    collection.nameFor(isArabicLocale: isArabicLocale),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: isArabicLocale
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.hadithCountLabel(collection.total),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.navy.withValues(alpha: 0.35),
            ),
          ],
        ),
      ),
    );
  }
}
