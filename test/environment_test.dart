import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/core/config/app_flavor.dart';
import 'package:qareeb/core/config/environment.dart';

void main() {
  test('Environment.init uses dev defaults when no dart-defines', () {
    Environment.init();

    expect(Environment.current.flavor, AppFlavor.dev);
    expect(Environment.current.apiBaseUrl, contains('dev.qareeb.app'));
    expect(Environment.current.isSentryEnabled, isTrue);
    expect(
      Environment.current.quranApiBaseUrl,
      'https://api.alquran.cloud/v1',
    );
  });
}
