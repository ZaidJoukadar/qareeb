import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qareeb/core/presentation/bottom_sheets/app_bar_modal_bottom_sheet.dart';
import 'package:qareeb/core/theme/app_theme.dart';
import 'package:qareeb/features/adhan/domain/entities/city_search_result.dart';
import 'package:qareeb/features/adhan/presentation/cubit/adhan_cubit.dart';
import 'package:qareeb/l10n/extensions/l10n_extension.dart';

Future<void> showCitySearchSheet(BuildContext context) {
  final cubit = context.read<AdhanCubit>();

  return showAppBarModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.cream,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: const _CitySearchSheet(),
    ),
  );
}

class _CitySearchSheet extends StatefulWidget {
  const _CitySearchSheet();

  @override
  State<_CitySearchSheet> createState() => _CitySearchSheetState();
}

class _CitySearchSheetState extends State<_CitySearchSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<CitySearchResult> _results = const [];
  bool _isSearching = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (!mounted) {
        return;
      }

      if (query.trim().length < 2) {
        setState(() {
          _results = const [];
          _isSearching = false;
          _hasSearched = false;
        });
        return;
      }

      setState(() {
        _isSearching = true;
        _hasSearched = true;
      });

      final results = await context.read<AdhanCubit>().searchCities(query);

      if (!mounted) {
        return;
      }

      setState(() {
        _results = results;
        _isSearching = false;
      });
    });
  }

  Future<void> _selectCity(CitySearchResult city) async {
    final cubit = context.read<AdhanCubit>();
    Navigator.of(context).pop();
    await cubit.selectCity(city);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Text(
            l10n.adhanSearchCityTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: l10n.adhanSearchCityHint,
              prefixIcon: const Icon(Icons.search, color: AppColors.gold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.gold, width: 2),
              ),
            ),
            onChanged: _onQueryChanged,
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.my_location, color: AppColors.gold),
            title: Text(l10n.adhanUseMyLocation),
            onTap: () {
              final cubit = context.read<AdhanCubit>();
              Navigator.of(context).pop();
              cubit.load(useDeviceLocation: true);
            },
          ),
          const Divider(),
          if (_isSearching)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              ),
            )
          else if (_hasSearched && _results.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                l10n.adhanSearchCityEmpty,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.navy.withValues(alpha: 0.7),
                ),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                controller: ModalScrollController.of(context),
                shrinkWrap: true,
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final city = _results[index];
                  return ListTile(
                    leading: const Icon(
                      Icons.location_city_outlined,
                      color: AppColors.navy,
                    ),
                    title: Text(city.city),
                    subtitle: Text(city.country),
                    onTap: () => _selectCity(city),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
