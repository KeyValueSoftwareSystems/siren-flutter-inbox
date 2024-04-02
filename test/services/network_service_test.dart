import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_client.dart';
import 'package:sirenapp_flutter_inbox/src/services/network_service.dart';

import 'network_service_test.mocks.dart';

// class MockApiClient extends Mock implements ApiClient {}

@GenerateNiceMocks([
  MockSpec<ApiClient>(),
])
void main() {
  late NetworkService networkService;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    networkService = NetworkService.instance;
    networkService.api = mockApiClient;
  });

  group('NetworkService', () {
    test('NetworkService instance is a singleton', () {
      // Ensure that the instance is singleton
      final networkServiceInstance1 = NetworkService.instance;
      final networkServiceInstance2 = NetworkService.instance;

      expect(networkServiceInstance1, equals(networkServiceInstance2));
    });

    test('ApiClient is correctly injected into NetworkService', () {
      // Verify that the ApiClient is correctly injected into NetworkService
      expect(networkService.api, equals(mockApiClient));
    });
  });
}
