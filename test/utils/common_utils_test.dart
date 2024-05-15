import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sirenapp_flutter_inbox/src/utils/common_utils.dart';

class MockRootBundle extends Mock implements AssetBundle {}

void main() {
  group('generateElapsedTimeText', () {
    test('should return correct elapsed time text', () {
      expect(
        generateElapsedTimeText(
          DateTime.now().subtract(const Duration(seconds: 10)),
        ),
        'Just now',
      );
      expect(
        generateElapsedTimeText(
          DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        '5 minutes ago',
      );
      expect(
        generateElapsedTimeText(
          DateTime.now().subtract(const Duration(hours: 1)),
        ),
        '1 hour ago',
      );
      expect(
        generateElapsedTimeText(
          DateTime.now().subtract(const Duration(days: 2)),
        ),
        '2 days ago',
      );
      expect(
        generateElapsedTimeText(
          DateTime.now().subtract(const Duration(days: 35)),
        ),
        '1 month ago',
      );
      expect(
        generateElapsedTimeText(
          DateTime.now().subtract(const Duration(days: 370)),
        ),
        '1 year ago',
      );
    });
  });

  group('modifyAndConvertToISOString', () {
    test('should modify and convert date string to ISO string', () {
      const dateString = '2022-01-01T00:00:00Z';
      final isoString = modifyAndConvertToISOString(dateString);

      expect(
        DateTime.parse(isoString),
        DateTime.parse(dateString).add(const Duration(milliseconds: 1)),
      );
    });
  });

  group('convertToISOString', () {
    test('should convert date string to ISO string', () {
      const dateString = '2022-01-01T00:00:00Z';
      final isoString = convertToISOString(dateString);

      expect(DateTime.parse(isoString), DateTime.parse(dateString));
    });
  });

  group('loadEnv', () {
    test('API_DOMAIN', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final envVariables = await loadEnv();
      expect(envVariables.keys.first, 'API_DOMAIN');
      await getApiDomain();
    });
  });
}
