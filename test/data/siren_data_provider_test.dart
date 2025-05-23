import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/api/verify_token.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/models/api_response.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_client.dart';

import 'siren_data_provider_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ApiClient>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SirenDataProvider sirenDataProvider;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    sirenDataProvider = SirenDataProvider.instance;
    VerifyToken().api = mockApiClient;
    sirenDataProvider.initialize();
  });

  group('SirenDataProvider', () {
    test('UpdateParams updates user token and recipient ID', () async {
      when(mockApiClient.get(path: anyNamed('path'))).thenAnswer(
        (_) async => DioResponse(
          data: {
            'data': {'status': 'SUCCESS'}
          },
          statusCode: 200,
        ),
      );

      sirenDataProvider.updateParams(
        userToken: 'token',
        recipientId: 'recipientId',
      );

      expect(sirenDataProvider.userToken, 'token');
      expect(sirenDataProvider.recipientId, 'recipientId');
    });

    test('IconDispose closes icon controller', () {
      final controller = sirenDataProvider.iconController;
      sirenDataProvider.iconDispose();
      expect(controller.isClosed, true);
    });

    test('InboxDispose closes inbox controller', () {
      final controller = sirenDataProvider.inboxController;
      sirenDataProvider.inboxDispose();
      expect(controller.isClosed, true);
    });

    test('Handles retry logic on token verification failure', () async {
      when(mockApiClient.get(path: anyNamed('path'))).thenAnswer(
        (_) async => DioResponse(
          data: {
            'data': {'status': 'FAILED'}
          },
          statusCode: 401,
        ),
      );

      sirenDataProvider.updateParams(
        userToken: 'token',
        recipientId: 'recipientId',
      );

      await Future<void>.delayed(
        const Duration(seconds: Generics.DATA_FETCH_INTERVAL) *
            (Generics.MAX_RETRIES + 1),
      );

      expect(sirenDataProvider.tokenVerificationStatus, Status.FAILED);
    });
  });
}
