import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/duaa/domain/entities/dua_category.dart';
import 'package:qareeb/features/duaa/presentation/cubit/duaa_categories_cubit.dart';
import 'package:qareeb/features/duaa/presentation/cubit/duaa_categories_state.dart';
import 'package:qareeb/features/duaa/presentation/pages/duaa_category_page.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class DuaaCategoriesPage extends StatelessWidget {
  const DuaaCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DuaaCategoriesCubit>()..load(),
      child: const _DuaaCategoriesView(),
    );
  }
}

class _DuaaCategoriesView extends StatelessWidget {
  const _DuaaCategoriesView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.duaaTitle),
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
            child: BlocBuilder<DuaaCategoriesCubit, DuaaCategoriesState>(
              buildWhen: (previous, current) =>
                  previous.searchQuery != current.searchQuery ||
                  previous.categories != current.categories,
              builder: (context, state) {
                return SearchBar(
                  hintText: l10n.duaaSearchCategoriesHint,
                  leading: const Icon(Icons.search),
                  onChanged: context.read<DuaaCategoriesCubit>().setSearchQuery,
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<DuaaCategoriesCubit, DuaaCategoriesState>(
              builder: (context, state) {
                if (state.status == DuaaCategoriesStatus.loading &&
                    state.categories.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.gold),
                  );
                }

                if (state.status == DuaaCategoriesStatus.failure &&
                    state.categories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.errorMessage ?? l10n.duaaError,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () =>
                              context.read<DuaaCategoriesCubit>().load(),
                          child: Text(l10n.quranSyncRetry),
                        ),
                      ],
                    ),
                  );
                }

                final categories = state.filteredCategories;
                if (categories.isEmpty) {
                  return Center(child: Text(l10n.duaaNoResults));
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.horizontalPadding(context),
                    vertical: 8,
                  ),
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: AppColors.navy.withValues(alpha: 0.12),
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _CategoryTile(category: category);
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

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final DuaCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isArabicLocale =
        Localizations.localeOf(context).languageCode == 'ar';

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DuaaCategoryPage(category: category),
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
                    category.nameFor(isArabicLocale: isArabicLocale),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection:
                        isArabicLocale ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.descriptionFor(isArabicLocale: isArabicLocale),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.navy.withValues(alpha: 0.65),
                    ),
                    textDirection:
                        isArabicLocale ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.duaaCountLabel(category.count),
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
