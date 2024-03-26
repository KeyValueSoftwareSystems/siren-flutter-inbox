import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';

void main() {
  group('Generics', () {
    test('Constants are correct', () {
      expect(Generics.V2, 'v2');
      expect(Generics.BASE_URL, '/in-app/recipients/');
      expect(Generics.DATA_FETCH_INTERVAL, 5);
      expect(Generics.PAGE_SIZE, 20);
      expect(Generics.MAX_RETRIES, 2);
      expect(Generics.ENV_PATH, 'packages/sirenapp_flutter_inbox/env');
      expect(Generics.defaultError.errorType, ErrorTypes.GENERIC_API_ERROR);
      expect(Generics.defaultError.errorCode, 'INTERNAL SERVER ERROR');
      expect(
        Generics.defaultError.message,
        'Oops something went wrong, if issue persist please contact Siren Team',
      );
    });
  });

  group('Enums', () {
    test('Status enum values are correct', () {
      expect(Status.PENDING.index, 0);
      expect(Status.SUCCESS.index, 1);
      expect(Status.FAILED.index, 2);
    });

    test('BulkUpdateType enum values are correct', () {
      expect(BulkUpdateType.MARK_AS_READ.index, 0);
      expect(BulkUpdateType.MARK_AS_DELETED.index, 1);
    });

    test('UpdateEvents enum values are correct', () {
      expect(UpdateEvents.READ_BY_ID.index, 0);
      expect(UpdateEvents.READ_ALL.index, 1);
      expect(UpdateEvents.DELETE_BY_ID.index, 2);
      expect(UpdateEvents.DELETE_ALL.index, 3);
      expect(UpdateEvents.VIEW_ALL.index, 4);
      expect(UpdateEvents.PARAMS_CHANGED.index, 5);
      expect(UpdateEvents.TOKEN_VERIFIED.index, 6);
    });

    test('ErrorTypes enum values are correct', () {
      expect(ErrorTypes.GENERIC_API_ERROR.index, 0);
      expect(ErrorTypes.AUTHENTICATION_FAILED.index, 1);
      expect(ErrorTypes.FETCH_COUNT_FAILED.index, 2);
      expect(ErrorTypes.NOTIFICATION_FETCH_FAILED.index, 3);
      expect(ErrorTypes.NOTIFICATION_READ_FAILED.index, 4);
      expect(ErrorTypes.NOTIFICATION_DELETE_FAILED.index, 5);
      expect(ErrorTypes.UPDATE_VIEWED_FAILED.index, 6);
    });
  });
}
