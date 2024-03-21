import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart'; // Import mockito
import 'package:siren_flutter_inbox/src/utils/common_utils.dart';

void main() {
  group('generateElapsedTimeText', () {
    test('should return correct elapsed time text', () {
      // Test cases for different time differences
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

      // Assert the modified date is one millisecond after the original date
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

      // Assert the converted date is equal to the original date
      expect(DateTime.parse(isoString), DateTime.parse(dateString));
    });
  });

  // group('loadEnv', () {
  // Inside the test group for loadEnv
  // test('should load environment variables from .env file', () async {
  //   // Mock the rootBundle.loadString method
  //   const envContents = 'API_DOMAIN=test.com';
  //   const expectedEnvVariables = {
  //     'API_DOMAIN': 'test.com',
  //   };
  //   final mockBundle = MockAssetBundle();

  //   // Use when to define behavior for the method call
  //   // when(mockBundle.loadString(Generics.ENV_PATH))
  //   //     .thenAnswer((_) => Future.value(envContents));

  //   // Load environment variables
  //   final envVariables = await loadEnv();
  //   print('envVariables $envVariables');
  //   print('expectedEnvVariables $expectedEnvVariables');

  //   // Assert that the loaded environment variables match the expected ones
  //   expect(envVariables, expectedEnvVariables);
  // });

  // test('should return empty map if failed to load .env file', () async {
  //   // Mock the rootBundle.loadString method to throw an error
  //   final mockBundle = MockAssetBundle();
  //   when(mockBundle.loadString(Generics.ENV_PATH))
  //       .thenThrow(Exception('Failed to load'));

  //   // Load environment variables
  //   final envVariables = await loadEnv();

  //   // Assert that an empty map is returned
  //   expect(envVariables, {});
  // });
  // });

  // group('getApiDomain', () {
  // test('should return API domain from environment variables', () async {
  //   // Mock the loadEnv function to return environment variables
  //   const expectedApiDomain = 'test.com';
  //   final mockEnv = {'API_DOMAIN': expectedApiDomain};
  //   when(loadEnv()).thenAnswer((_) => Future.value(mockEnv));
  //   // when(loadEnv()).thenAnswer((_) async => mockEnv);

  //   // Get API domain
  //   final apiDomain = await getApiDomain();

  //   // Assert that the returned API domain matches the expected one
  //   expect(apiDomain, expectedApiDomain);
  // });

  // test(
  //     'should return empty string if API domain is not found in environment variables',
  //     () async {
  //   // Mock the loadEnv function to return empty environment variables
  //   // when(loadEnv()).thenAnswer((_) => Future.value({}));

  //   // Get API domain
  //   final apiDomain = await getApiDomain();

  //   // Assert that an empty string is returned
  //   expect(apiDomain, '');
  // });
  // });
}

// Mock class for AssetBundle
class MockAssetBundle extends Mock implements AssetBundle {}
