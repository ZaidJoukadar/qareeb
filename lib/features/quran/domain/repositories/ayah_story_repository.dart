import 'package:qareeb/features/quran/domain/entities/ayah_story.dart';

abstract class AyahStoryRepository {
  Future<AyahStory> getAyahStory({
    required int surahNumber,
    required int ayahNumber,
    required String languageCode,
  });
}
