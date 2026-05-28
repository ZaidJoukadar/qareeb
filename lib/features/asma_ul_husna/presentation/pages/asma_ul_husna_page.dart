import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/asma_ul_husna/domain/entities/allah_name.dart';
import 'package:qareeb/features/asma_ul_husna/presentation/cubit/asma_ul_husna_cubit.dart';
import 'package:qareeb/features/asma_ul_husna/presentation/cubit/asma_ul_husna_state.dart';
import 'package:qareeb/features/asma_ul_husna/presentation/widgets/allah_name_detail_sheet.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class AsmaUlHusnaPage extends StatelessWidget {
  const AsmaUlHusnaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AsmaUlHusnaCubit>()..load(),
      child: const _AsmaUlHusnaView(),
    );
  }
}

class _AsmaUlHusnaView extends StatelessWidget {
  const _AsmaUlHusnaView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.asmaUlHusnaTitle),
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
            child: BlocBuilder<AsmaUlHusnaCubit, AsmaUlHusnaState>(
              buildWhen: (previous, current) =>
                  previous.searchQuery != current.searchQuery ||
                  previous.names != current.names,
              builder: (context, state) {
                return SearchBar(
                  hintText: l10n.asmaUlHusnaSearchHint,
                  leading: const Icon(Icons.search),
                  onChanged: context.read<AsmaUlHusnaCubit>().setSearchQuery,
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<AsmaUlHusnaCubit, AsmaUlHusnaState>(
              builder: (context, state) {
                if (state.status == AsmaUlHusnaStatus.loading &&
                    state.names.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.gold),
                  );
                }

                if (state.status == AsmaUlHusnaStatus.failure &&
                    state.names.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.errorMessage ?? l10n.asmaUlHusnaError,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () =>
                              context.read<AsmaUlHusnaCubit>().load(),
                          child: Text(l10n.quranSyncRetry),
                        ),
                      ],
                    ),
                  );
                }

                final names = state.filteredNames;
                if (names.isEmpty) {
                  return Center(child: Text(l10n.asmaUlHusnaNoResults));
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.horizontalPadding(context),
                    vertical: 8,
                  ),
                  itemCount: names.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.12),
                  ),
                  itemBuilder: (context, index) {
                    final name = names[index];
                    return _AllahNameTile(
                      name: name,
                      onTap: () => showAllahNameDetailSheet(
                        context: context,
                        name: name,
                      ),
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

class _AllahNameTile extends StatelessWidget {
  const _AllahNameTile({
    required this.name,
    required this.onTap,
  });

  final AllahName name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final isArabicLocale =
        Localizations.localeOf(context).languageCode == 'ar';
    final translation = name.translationFor(isArabicLocale: isArabicLocale);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.gold.withValues(alpha: 0.2),
              child: Text(
                '${name.number}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.arabic,
                    style: theme.textTheme.titleLarge?.copyWith(
                      height: 1.4,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  if (!isArabicLocale) ...[
                    const SizedBox(height: 4),
                    Text(
                      name.transliteration,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    translation,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: onSurface.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                    ),
                    textDirection:
                        isArabicLocale ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: onSurface.withValues(alpha: 0.35),
            ),
          ],
        ),
      ),
    );
  }
}
