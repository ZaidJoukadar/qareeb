import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/features/quran/data/datasources/ayah_story_remote_data_source.dart';

void main() {
  group('AyahStoryParser', () {
    test('parses raw JSON object', () {
      const raw = '''
{
  "revelationReason": "Reason text.",
  "howRevealed": "Manner text.",
  "miracle": "Miracle text."
}
''';

      final story = AyahStoryParser.parse(raw);

      expect(story.revelationReason, 'Reason text.');
      expect(story.howRevealed, 'Manner text.');
      expect(story.miracle, 'Miracle text.');
    });

    test('parses JSON wrapped in markdown fence', () {
      const raw = '''
```json
{
  "revelationReason": "A",
  "howRevealed": "B",
  "miracle": "C"
}
```
''';

      final story = AyahStoryParser.parse(raw);

      expect(story.revelationReason, 'A');
      expect(story.howRevealed, 'B');
      expect(story.miracle, 'C');
    });
  });
}
