import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qareeb/core/di/injection.dart';
import 'package:qareeb/core/presentation/bottom_sheets/app_bar_modal_bottom_sheet.dart';
import 'package:qareeb/core/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:qareeb/features/quran/data/datasources/quran_remote_data_source.dart';
import 'package:qareeb/features/quran/data/models/audio_edition_dto.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

Future<void> showAudioReciterPickerSheet(BuildContext context) {
  return showAppBarModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => const _AudioReciterPickerSheet(),
  );
}

class _AudioReciterPickerSheet extends StatefulWidget {
  const _AudioReciterPickerSheet();

  @override
  State<_AudioReciterPickerSheet> createState() =>
      _AudioReciterPickerSheetState();
}

class _AudioReciterPickerSheetState extends State<_AudioReciterPickerSheet> {
  late Future<List<AudioEditionDto>> _editionsFuture;

  @override
  void initState() {
    super.initState();
    _editionsFuture = getIt<QuranRemoteDataSource>().fetchAudioEditions();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context);
    final selectedReciter = context.watch<AppSettingsCubit>().state.quranAudioReciter;

    return AppBarModalListBody(
      heightFactor: 0.6,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Text(
          l10n.drawerSelectReciter,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      list: FutureBuilder<List<AudioEditionDto>>(
        future: _editionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.drawerRecitersLoadError),
              ),
            );
          }

          final editions = snapshot.data ?? [];
          return RadioGroup<String>(
            groupValue: selectedReciter,
            onChanged: (identifier) {
              if (identifier == null) return;
              context.read<AppSettingsCubit>().setQuranAudioReciter(identifier);
              Navigator.of(context).pop();
            },
            child: ListView.builder(
              controller: ModalScrollController.of(context),
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom + 8,
              ),
              itemCount: editions.length,
              itemBuilder: (context, index) {
                final edition = editions[index];
                return RadioListTile<String>(
                  title: Text(
                    edition.displayNameForLocale(locale.languageCode),
                  ),
                  subtitle: edition.language != locale.languageCode
                      ? Text(edition.englishName)
                      : null,
                  value: edition.identifier,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
