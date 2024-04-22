import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/constants/strings.dart';

class Generics {
  Generics._();

  static const String V2 = 'v2';
  static const String BASE_URL = '/in-app/recipients/';

  static const int DATA_FETCH_INTERVAL = 5;
  static const int PAGE_SIZE = 20;
  static const int MAX_RETRIES = 2;
  static const String ENV_PATH = 'packages/sirenapp_flutter_inbox/env';

  static final defaultError = ApiErrorDetails(
    code: ErrorTypes.API_ERROR.name,
    type: Strings.error_type_error,
    message: 'Something went wrong',
  );

  static final authenticationFailed = ApiErrorDetails(
    code: ErrorTypes.AUTHENTICATION_FAILED.name,
    type: Strings.error_type_error,
    message: Strings.authenticationFailed,
  );

  static final fetchUnViewedCountFailedError = ApiErrorDetails(
    code: ErrorTypes.UNVIEWED_COUNT_FETCH_FAILED.name,
    type: Strings.error_type_error,
    message: Strings.fetchUnViewedCountFailedError,
  );

  static final notificationFetchFailedError = ApiErrorDetails(
    code: ErrorTypes.NOTIFICATION_FETCH_FAILED.name,
    type: Strings.error_type_error,
    message: Strings.notificationFetchFailedError,
  );

  static final markAsReadFailedError = ApiErrorDetails(
    code: ErrorTypes.MARK_AS_READ_FAILED.name,
    type: Strings.error_type_error,
    message: Strings.markAsReadFailedError,
  );

  static final deleteFailedError = ApiErrorDetails(
    code: ErrorTypes.DELETE_FAILED.name,
    type: Strings.error_type_error,
    message: Strings.deleteFailedError,
  );

  static final deleteAllFailedError = ApiErrorDetails(
    code: ErrorTypes.BULK_DELETE_FAILED.name,
    type: Strings.error_type_error,
    message: Strings.deleteAllFailedError,
  );

  static final markAllAsViewedError = ApiErrorDetails(
    code: ErrorTypes.MARK_ALL_AS_VIEWED_FAILED.name,
    type: Strings.error_type_error,
    message: Strings.markAllAsViewedError,
  );

  static final outsideSirenContextError = ApiErrorDetails(
    code: ErrorTypes.OUTSIDE_SIREN_CONTEXT.name,
    type: Strings.error_type_error,
    message: Strings.outsideSirenContextError,
  );

  static final authenticationPending = ApiErrorDetails(
    code: ErrorTypes.AUTHENTICATION_PENDING.name,
    type: Strings.error_type_error,
    message: Strings.authenticationPending,
  );

  static final unauthorizedOperationError = ApiErrorDetails(
    code: ErrorTypes.UNAUTHORIZED_OPERATION.name,
    type: Strings.error_type_error,
    message: Strings.unauthorizedOperationError,
  );

  static const rawResponseError =
      '{"data": null,"error": "AUTHENTICATION FAILED","errors":null,"meta":null}';
}

enum Status {
  PENDING,
  SUCCESS,
  FAILED,
  IN_PROGRESS,
}

enum BulkUpdateType {
  MARK_AS_READ,
  MARK_AS_DELETED,
}

enum UpdateEvents {
  READ_BY_ID,
  READ_ALL,
  DELETE_BY_ID,
  DELETE_ALL,
  VIEW_ALL,
  PARAMS_CHANGED,
  TOKEN_VERIFIED,
  SHOW_ERROR,
}

enum ErrorTypes {
  API_ERROR,
  AUTHENTICATION_FAILED,
  UNVIEWED_COUNT_FETCH_FAILED,
  NOTIFICATION_FETCH_FAILED,
  NOTIFICATION_READ_FAILED,
  DELETE_FAILED,
  MARK_ALL_AS_VIEWED_FAILED,
  MARK_AS_READ_FAILED,
  OUTSIDE_SIREN_CONTEXT,
  AUTHENTICATION_PENDING,
  UNAUTHORIZED_OPERATION,
  BULK_DELETE_FAILED,
  MARK_ALL_AS_READ_FAILED,
}
