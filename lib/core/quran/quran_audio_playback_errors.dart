import 'package:dio/dio.dart';
import 'package:qareeb/core/network/network_errors.dart';
import 'package:qareeb/l10n/generated/app_localizations.dart';

/// Localization keys surfaced by [QuranSurahPlaybackService] and reader cubits.
abstract final class QuranAudioPlaybackErrors {
  static const unavailable = 'quranAudioUnavailable';
  static const network = 'quranAudioNetworkError';
  static const generic = 'quranAudioLoadError';
  static const nextAyahDownloading = 'quranAudioNextAyahDownloading';

  static String keyFor(Object error) {
    if (error is DioException && error.response?.statusCode == 404) {
      return unavailable;
    }
    if (isNetworkError(error)) {
      return network;
    }
    if (error is StateError &&
        error.message.contains('Audio not available')) {
      return unavailable;
    }
    return generic;
  }

  static String message(AppLocalizations l10n, String key) {
    return switch (key) {
      unavailable => l10n.quranAudioUnavailable,
      network => l10n.quranAudioNetworkError,
      nextAyahDownloading => l10n.quranAudioNextAyahDownloading,
      generic => l10n.quranAudioLoadError,
      _ => key,
    };
  }
}
