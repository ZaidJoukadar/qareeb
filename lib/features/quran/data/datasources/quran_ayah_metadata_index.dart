import 'package:dio/dio.dart';
import 'package:qareeb/core/constants/ummah_quran_mappings.dart';
import 'package:qareeb/core/network/ummah_api_response.dart';

/// Builds `(surah, ayah) -> mushaf page` lookup from UmmahAPI page endpoints.
class QuranAyahMetadataIndex {
  QuranAyahMetadataIndex(this._dio);

  final Dio _dio;

  Map<String, int>? _pageByVerseKey;
  Future<void>? _loading;

  Future<void> ensureLoaded() {
    return _loading ??= _loadPages();
  }

  Future<int> pageFor({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    await ensureLoaded();
    return _pageByVerseKey!['$surahNumber:$ayahNumber'] ?? 1;
  }

  Future<void> _loadPages() async {
    final pageByVerseKey = <String, int>{};
    const batchSize = 40;
    final totalPages = UmmahQuranMappings.totalMushafPages;
    final batchStarts = List.generate(
      (totalPages / batchSize).ceil(),
      (batchIndex) => batchIndex * batchSize + 1,
    );

    await batchStarts.fold(
      Future<void>.value(),
      (previousBatch, startPage) => previousBatch.then((_) async {
        final endPage = (startPage + batchSize - 1).clamp(1, totalPages);
        final pages = await Future.wait(
          List.generate(
            endPage - startPage + 1,
            (offset) => _fetchPageVerseKeys(startPage + offset),
          ),
        );
        pages
            .expand((pageMap) => pageMap.entries)
            .forEach(
              (entry) =>
                  pageByVerseKey.putIfAbsent(entry.key, () => entry.value),
            );
      }),
    );

    _pageByVerseKey = pageByVerseKey;
  }

  Future<Map<String, int>> _fetchPageVerseKeys(int page) async {
    final response = await _dio.get<Map<String, dynamic>>('/quran/page/$page');
    final body = response.data;
    if (body == null) {
      throw StateError('Empty UmmahAPI page response for page $page');
    }

    final parsed = UmmahApiResponse.fromJson(
      body,
      (data) => data as Map<String, dynamic>,
    );
    ensureUmmahSuccess(parsed.success, message: 'UmmahAPI page $page failed');

    final words = parsed.data['words'] as List<dynamic>? ?? [];

    return Map.fromEntries(
      words
          .cast<Map<String, dynamic>>()
          .where(
            (wordJson) =>
                wordJson['surah_number'] != null &&
                wordJson['ayah_number'] != null,
          )
          .map(
            (wordJson) => MapEntry(
              '${wordJson['surah_number']}:${wordJson['ayah_number']}',
              page,
            ),
          ),
    );
  }
}
