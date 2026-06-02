import 'package:qareeb/features/quran/domain/entities/ayah_story.dart';
import 'package:qareeb/features/quran/domain/repositories/ayah_story_repository.dart';

class GetAyahStory {
  const GetAyahStory(this._repository);

  final AyahStoryRepository _repository;

  Future<AyahStory> call({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  }) {
    return _repository.getAyahStory(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      languageCode: languageCode,
    );
  }
}
