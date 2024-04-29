import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/constants/strings.dart';

class Generics {
  Generics._();

  static const String V2 = 'v2';
  static const String BASE_URL = '/in-app/recipients/';

  static const int DATA_FETCH_INTERVAL = 5;
  static const int PAGE_SIZE = 20;
  static const int AVERAGE_ITEMS_ON_SCREEN = 7;
  static const int MAX_RETRIES = 2;
  static const String ENV_PATH = 'packages/sirenapp_flutter_inbox/env';

  static final defaultError = SirenErrorType(
    code: ErrorCodes.API_ERROR.name,
    type: Strings.error_type_error,
    message: Strings.something_went_wrong,
  );

  static final authenticationFailed = SirenErrorType(
    code: ErrorCodes.AUTHENTICATION_FAILED.name,
    type: Strings.error_type_error,
    message: Strings.authenticationFailed,
  );

  static final fetchUnViewedCountFailedError = SirenErrorType(
    code: ErrorCodes.UNVIEWED_COUNT_FETCH_FAILED.name,
    type: Strings.error_type_error,
    message: Strings.fetchUnViewedCountFailedError,
  );

  static final notificationFetchFailedError = SirenErrorType(
    code: ErrorCodes.NOTIFICATION_FETCH_FAILED.name,
    type: Strings.error_type_error,
    message: Strings.notificationFetchFailedError,
  );

  static final markAsReadFailedError = SirenErrorType(
    code: ErrorCodes.MARK_AS_READ_FAILED.name,
    type: Strings.error_type_error,
    message: Strings.markAsReadFailedError,
  );

  static final deleteFailedError = SirenErrorType(
    code: ErrorCodes.DELETE_FAILED.name,
    type: Strings.error_type_error,
    message: Strings.deleteFailedError,
  );

  static final deleteAllFailedError = SirenErrorType(
    code: ErrorCodes.BULK_DELETE_FAILED.name,
    type: Strings.error_type_error,
    message: Strings.deleteAllFailedError,
  );

  static final markAllAsViewedError = SirenErrorType(
    code: ErrorCodes.MARK_ALL_AS_VIEWED_FAILED.name,
    type: Strings.error_type_error,
    message: Strings.markAllAsViewedError,
  );

  static final outsideSirenContextError = SirenErrorType(
    code: ErrorCodes.OUTSIDE_SIREN_CONTEXT.name,
    type: Strings.error_type_error,
    message: Strings.outsideSirenContextError,
  );

  static final authenticationPending = SirenErrorType(
    code: ErrorCodes.AUTHENTICATION_PENDING.name,
    type: Strings.error_type_error,
    message: Strings.authenticationPending,
  );

  static final unauthorizedOperationError = SirenErrorType(
    code: ErrorCodes.UNAUTHORIZED_OPERATION.name,
    type: Strings.error_type_error,
    message: Strings.unauthorizedOperationError,
  );

  static final invalidCredentialsError = SirenErrorType(
    code: ErrorCodes.INVALID_CREDENTIALS.name,
    type: Strings.error_type_error,
    message: Strings.invalidCredentialsError,
  );

  static const rawResponseError =
      '{"data": null,"error": "AUTHENTICATION FAILED","errors":null,"meta":null}';
}

enum Status {
  PENDING,
  SUCCESS,
  FAILED,
  IN_PROGRESS,
  INVALID_CREDENTIALS,
}

enum BulkUpdateType {
  MARK_AS_READ,
  MARK_AS_DELETED,
}

enum UpdateEvents {
  DELETE_ALL,
  DELETE_BY_ID,
  PARAMS_CHANGED,
  READ_ALL,
  READ_BY_ID,
  SHOW_ERROR,
  TOKEN_VERIFIED,
  VIEW_ALL,
}

enum ErrorCodes {
  API_ERROR,
  AUTHENTICATION_FAILED,
  AUTHENTICATION_PENDING,
  BULK_DELETE_FAILED,
  DELETE_FAILED,
  INVALID_CREDENTIALS,
  MARK_ALL_AS_READ_FAILED,
  MARK_ALL_AS_VIEWED_FAILED,
  MARK_AS_READ_FAILED,
  NOTIFICATION_FETCH_FAILED,
  NOTIFICATION_READ_FAILED,
  OUTSIDE_SIREN_CONTEXT,
  UNAUTHORIZED_OPERATION,
  UNVIEWED_COUNT_FETCH_FAILED,
}
