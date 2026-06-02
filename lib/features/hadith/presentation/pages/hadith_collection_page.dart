import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/hadith/domain/entities/hadith_collection.dart';
import 'package:qareeb/features/hadith/presentation/cubit/hadith_collection_cubit.dart';
import 'package:qareeb/features/hadith/presentation/cubit/hadith_collection_state.dart';
import 'package:qareeb/features/hadith/presentation/widgets/hadith_detail_sheet.dart';
import 'package:qareeb/features/hadith/presentation/widgets/hadith_list_tile.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class HadithCollectionPage extends StatelessWidget {
  const HadithCollectionPage({super.key, required this.collection});

  final HadithCollection collection;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<HadithCollectionCubit>()..load(collection.id),
      child: _HadithCollectionView(collection: collection),
    );
  }
}

class _HadithCollectionView extends StatefulWidget {
  const _HadithCollectionView({required this.collection});

  final HadithCollection collection;

  @override
  State<_HadithCollectionView> createState() => _HadithCollectionViewState();
}

class _HadithCollectionViewState extends State<_HadithCollectionView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      context.read<HadithCollectionCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabicLocale =
        Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collection.nameFor(isArabicLocale: isArabicLocale)),
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
            child: BlocBuilder<HadithCollectionCubit, HadithCollectionState>(
              buildWhen: (previous, current) =>
                  previous.searchQuery != current.searchQuery,
              builder: (context, state) {
                return SearchBar(
                  hintText: l10n.hadithSearchCollectionHint,
                  leading: const Icon(Icons.search),
                  onChanged:
                      context.read<HadithCollectionCubit>().setSearchQuery,
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<HadithCollectionCubit, HadithCollectionState>(
              builder: (context, state) {
                if (state.status == HadithCollectionStatus.loading &&
                    state.visibleHadiths.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.gold),
                  );
                }

                if (state.status == HadithCollectionStatus.failure &&
                    state.visibleHadiths.isEmpty) {
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
                              .read<HadithCollectionCubit>()
                              .load(widget.collection.id),
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
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.horizontalPadding(context),
                    vertical: 8,
                  ),
                  itemCount:
                      hadiths.length + (state.isLoadingMore && !state.isSearchActive ? 1 : 0),
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: AppColors.navy.withValues(alpha: 0.12),
                  ),
                  itemBuilder: (context, index) {
                    if (index >= hadiths.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.gold,
                          ),
                        ),
                      );
                    }

                    final hadith = hadiths[index];
                    return HadithListTile(
                      hadith: hadith,
                      isArabicLocale: isArabicLocale,
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
