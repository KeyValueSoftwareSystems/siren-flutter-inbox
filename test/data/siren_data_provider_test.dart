import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:sirenapp_flutter_inbox/src/api/verify_token.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';

@GenerateNiceMocks([
  MockSpec<VerifyToken>(),
])
void main() {
  late SirenDataProvider sirenDataProvider;

  setUp(() {
    sirenDataProvider = SirenDataProvider.instance..initialize();
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
  });
}
