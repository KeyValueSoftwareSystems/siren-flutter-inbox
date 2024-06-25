import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/errors/errors.dart';

void main() {
  group('Generics', () {
    test('Constants are correct', () {
      expect(Generics.V2, 'v2');
      expect(Generics.BASE_URL, '/in-app/recipients/');
      expect(Generics.DATA_FETCH_INTERVAL, 5);
      expect(Generics.PAGE_SIZE, 20);
      expect(Generics.MAX_RETRIES, 2);
      expect(Generics.ENV_PATH, 'packages/sirenapp_flutter_inbox/env');
      expect(Errors.defaultError.code, ErrorCodes.API_ERROR.name);
      expect(Errors.defaultError.type, 'ERROR');
      expect(
        Errors.defaultError.message,
        'Something went wrong',
      );
    });
  });

  group('Enums', () {
    test('Status enum values are correct', () {
      expect(Status.PENDING.index, 0);
      expect(Status.SUCCESS.index, 1);
      expect(Status.FAILED.index, 2);
      expect(Status.IN_PROGRESS.index, 3);
    });

    test('BulkUpdateType enum values are correct', () {
      expect(BulkUpdateType.MARK_AS_READ.index, 0);
      expect(BulkUpdateType.MARK_AS_DELETED.index, 1);
    });

    test('UpdateEvents enum values are correct', () {
      expect(UpdateEvents.DELETE_ALL.index, 0);
      expect(UpdateEvents.DELETE_BY_ID.index, 1);
      expect(UpdateEvents.PARAMS_CHANGED.index, 2);
      expect(UpdateEvents.READ_ALL.index, 3);
      expect(UpdateEvents.READ_BY_ID.index, 4);
      expect(UpdateEvents.SHOW_ERROR.index, 5);
      expect(UpdateEvents.TOKEN_VERIFIED.index, 6);
      expect(UpdateEvents.VIEW_ALL.index, 7);
    });

    test('ErrorTypes enum values are correct', () {
      expect(ErrorCodes.API_ERROR.index, 0);
      expect(ErrorCodes.AUTHENTICATION_FAILED.index, 1);
      expect(ErrorCodes.AUTHENTICATION_PENDING.index, 2);
      expect(ErrorCodes.BULK_DELETE_FAILED.index, 3);
      expect(ErrorCodes.DELETE_FAILED.index, 4);
      expect(ErrorCodes.INVALID_CREDENTIALS.index, 5);
      expect(ErrorCodes.MARK_ALL_AS_READ_FAILED.index, 6);
      expect(ErrorCodes.MARK_ALL_AS_VIEWED_FAILED.index, 7);
      expect(ErrorCodes.MARK_AS_READ_FAILED.index, 8);
      expect(ErrorCodes.NOTIFICATION_FETCH_FAILED.index, 9);
      expect(ErrorCodes.NOTIFICATION_READ_FAILED.index, 10);
      expect(ErrorCodes.OUTSIDE_SIREN_CONTEXT.index, 11);
      expect(ErrorCodes.UNAUTHORIZED_OPERATION.index, 12);
      expect(ErrorCodes.UNVIEWED_COUNT_FETCH_FAILED.index, 13);
    });
  });
}
