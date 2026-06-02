import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/widgets/app_drawer.dart';
import 'package:qareeb/core/quran/quran_reader_locale.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/domain/usecases/get_surahs.dart';
import 'package:qareeb/features/quran/presentation/cubit/mushaf_book_reader_cubit.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_book_reader.dart';
import 'package:qareeb/features/quran/presentation/widgets/mushaf_reader_locale_listener.dart';
import 'package:qareeb/features/quran/presentation/utils/surah_search_filter.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

class HomeShellPage extends StatefulWidget {
  const HomeShellPage({super.key});

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  final _searchController = TextEditingController();
  bool _isSearchActive = false;
  String _searchQuery = '';
  late final Future<List<Surah>> _surahsFuture;

  @override
  void initState() {
    super.initState();
    _surahsFuture = getIt<GetSurahs>()();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageBackground = QuranReaderTheme.pageBackgroundOf(context);
    final showTranslation = QuranReaderLocale.showTranslationFor(
      Localizations.localeOf(context).languageCode,
    );
    final isArabicLocale = Localizations.localeOf(context).languageCode == 'ar';
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<MushafBookReaderCubit>(
        param1: MushafBookReaderParams(
          initialPage: 1,
          showTranslation: showTranslation,
        ),
      )..load(),
      child: Scaffold(
        backgroundColor: pageBackground,
        drawer: const AppDrawer(),
        appBar: AppBar(
          backgroundColor: pageBackground,
          foregroundColor: QuranReaderTheme.arabicTextOf(context),
          elevation: 0,
          title: _isSearchActive
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: l10n.surahListSearchHint,
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                )
              : null,
          actions: [
            IconButton(
              icon: Icon(_isSearchActive ? Icons.close : Icons.search),
              tooltip: l10n.surahListSearchTooltip,
              onPressed: () {
                setState(() {
                  _isSearchActive = !_isSearchActive;
                  if (!_isSearchActive) {
                    _searchController.clear();
                    _searchQuery = '';
                  }
                });
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            const MushafReaderLocaleListener(
              child: MushafBookReaderContent(),
            ),
            if (_isSearchActive && _searchQuery.trim().isNotEmpty)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxHeight: 360),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: FutureBuilder<List<Surah>>(
                      future: _surahsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(l10n.surahListError),
                            ),
                          );
                        }
                        final surahs = filterSurahs(
                          surahs: snapshot.data ?? const [],
                          query: _searchQuery,
                          isArabicLocale: isArabicLocale,
                        );
                        if (surahs.isEmpty) {
                          return Center(child: Text(l10n.surahListNoResults));
                        }
                        final cubit = context.read<MushafBookReaderCubit>();
                        return ListView.separated(
                          itemCount: surahs.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final surah = surahs[index];
                            return ListTile(
                              onTap: () async {
                                await cubit.navigateToSurah(surah.number);
                                if (!mounted) return;
                                setState(() {
                                  _isSearchActive = false;
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                              leading: CircleAvatar(
                                child: Text('${surah.number}'),
                              ),
                              title: Text(
                                isArabicLocale
                                    ? surah.nameArabic
                                    : surah.nameEnglish,
                              ),
                              subtitle: Text(
                                isArabicLocale
                                    ? '${surah.ayahCount} ${l10n.ayahCountLabel}'
                                    : surah.nameTranslated,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
