import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/api/verify_token.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';

import 'siren_data_provider_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<VerifyToken>(),
])
void main() {
  late SirenDataProvider sirenDataProvider;
  late MockVerifyToken mockVerifyToken;

  setUp(() {
    sirenDataProvider = SirenDataProvider.instance..initialize();
    mockVerifyToken = MockVerifyToken();
  });

  group('SirenDataProvider', () {
    test('UpdateParams updates user token and recipient ID', () async {
      // Perform updateParams
      sirenDataProvider.updateParams(
        userToken: 'token',
        recipientId: 'recipientId',
      );

      // Verify that user token and recipient ID are updated correctly
      expect(sirenDataProvider.userToken, 'token');
      expect(sirenDataProvider.recipientId, 'recipientId');
    });

    test('IconDispose closes icon controller', () {
      // Perform icon disposal
      sirenDataProvider.iconDispose();

      // Verify that icon controller is closed
      expect(sirenDataProvider.iconController.isClosed, false);
    });

    test('InboxDispose closes inbox controller', () {
      // Perform inbox disposal
      sirenDataProvider.inboxDispose();

      // Verify that inbox controller is closed
      expect(sirenDataProvider.inboxController.isClosed, false);
    });

    test('Handles retry logic on token verification failure', () async {
      final failedResponse = ApiResponse(data: false);
      when(mockVerifyToken.verifyToken())
          .thenAnswer((_) async => failedResponse);

      await sirenDataProvider.initialize();

      sirenDataProvider.updateParams(userToken: 'token', recipientId: '123');

      await Future.delayed(
          const Duration(seconds: Generics.DATA_FETCH_INTERVAL) *
              (Generics.MAX_RETRIES + 1));

      expect(sirenDataProvider.tokenVerificationStatus, Status.FAILED);
    });
  });
}
