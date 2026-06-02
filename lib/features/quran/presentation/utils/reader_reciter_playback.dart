import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/quran/presentation/cubit/ayah_reader_cubit.dart';
import 'package:qareeb/features/quran/presentation/cubit/mushaf_book_reader_cubit.dart';

/// Returns the active Quran reader playback hook when a reader screen is open.
Future<void> Function()? readerReciterPlaybackHandler(BuildContext context) {
  try {
    return context.read<MushafBookReaderCubit>().onReciterChanged;
  } catch (_) {}

  try {
    return context.read<AyahReaderCubit>().onReciterChanged;
  } catch (_) {}

  return null;
}
