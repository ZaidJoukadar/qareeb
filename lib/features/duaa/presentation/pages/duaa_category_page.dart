import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/duaa/domain/entities/dua.dart';
import 'package:qareeb/features/duaa/domain/entities/dua_category.dart';
import 'package:qareeb/features/duaa/presentation/cubit/duaa_category_cubit.dart';
import 'package:qareeb/features/duaa/presentation/cubit/duaa_category_state.dart';
import 'package:qareeb/features/duaa/presentation/widgets/dua_detail_sheet.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class DuaaCategoryPage extends StatelessWidget {
  const DuaaCategoryPage({super.key, required this.category});

  final DuaCategory category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DuaaCategoryCubit>()..load(category.id),
      child: _DuaaCategoryView(category: category),
    );
  }
}

class _DuaaCategoryView extends StatelessWidget {
  const _DuaaCategoryView({required this.category});

  final DuaCategory category;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabicLocale =
        Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(category.nameFor(isArabicLocale: isArabicLocale)),
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
            child: BlocBuilder<DuaaCategoryCubit, DuaaCategoryState>(
              buildWhen: (previous, current) =>
                  previous.searchQuery != current.searchQuery ||
                  previous.duas != current.duas,
              builder: (context, state) {
                return SearchBar(
                  hintText: l10n.duaaSearchDuasHint,
                  leading: const Icon(Icons.search),
                  onChanged: context.read<DuaaCategoryCubit>().setSearchQuery,
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<DuaaCategoryCubit, DuaaCategoryState>(
              builder: (context, state) {
                if (state.status == DuaaCategoryStatus.loading &&
                    state.duas.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.gold),
                  );
                }

                if (state.status == DuaaCategoryStatus.failure &&
                    state.duas.isEmpty) {
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
                          onPressed: () => context
                              .read<DuaaCategoryCubit>()
                              .load(category.id),
                          child: Text(l10n.quranSyncRetry),
                        ),
                      ],
                    ),
                  );
                }

                final duas = state.filteredDuas;
                if (duas.isEmpty) {
                  return Center(child: Text(l10n.duaaNoResults));
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.horizontalPadding(context),
                    vertical: 8,
                  ),
                  itemCount: duas.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: AppColors.navy.withValues(alpha: 0.12),
                  ),
                  itemBuilder: (context, index) {
                    final dua = duas[index];
                    return _DuaTile(
                      dua: dua,
                      isArabicLocale: isArabicLocale,
                      onTap: () => showDuaDetailSheet(context: context, dua: dua),
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

class _DuaTile extends StatelessWidget {
  const _DuaTile({
    required this.dua,
    required this.isArabicLocale,
    required this.onTap,
  });

  final Dua dua;
  final bool isArabicLocale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
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
                    dua.titleFor(isArabicLocale: isArabicLocale),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection:
                        isArabicLocale ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dua.arabic,
                    style: theme.textTheme.titleLarge?.copyWith(
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
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
