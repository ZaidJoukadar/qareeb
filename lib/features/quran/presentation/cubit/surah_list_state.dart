import 'package:equatable/equatable.dart';
import 'package:qareeb/features/quran/domain/entities/surah.dart';
import 'package:qareeb/features/quran/presentation/utils/surah_search_filter.dart';

enum SurahListStatus { initial, loading, success, failure }

class SurahListState extends Equatable {
  const SurahListState({
    this.status = SurahListStatus.initial,
    this.surahs = const [],
    this.readAyahCounts = const {},
    this.errorMessage,
    this.searchQuery = '',
  });

  final SurahListStatus status;
  final List<Surah> surahs;
  final Map<int, int> readAyahCounts;
  final String? errorMessage;
  final String searchQuery;

  List<Surah> filteredSurahs({required bool isArabicLocale}) {
    return filterSurahs(
      surahs: surahs,
      query: searchQuery,
      isArabicLocale: isArabicLocale,
    );
  }

  int readCountFor(Surah surah) => readAyahCounts[surah.number] ?? 0;

  bool hasReadProgress(Surah surah) => readCountFor(surah) > 0;

  bool isSurahFullyRead(Surah surah) => readCountFor(surah) >= surah.ayahCount;

  SurahListState copyWith({
    SurahListStatus? status,
    List<Surah>? surahs,
    Map<int, int>? readAyahCounts,
    String? errorMessage,
    String? searchQuery,
  }) {
    return SurahListState(
      status: status ?? this.status,
      surahs: surahs ?? this.surahs,
      readAyahCounts: readAyahCounts ?? this.readAyahCounts,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    status,
    surahs,
    readAyahCounts,
    errorMessage,
    searchQuery,
  ];
}
