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
    code: ErrorTypes.API_ERROR,
    type: Strings.error_type_error,
    message: 'Something went wrong',
  );

  static final authenticationFailed = ApiErrorDetails(
    code: ErrorTypes.AUTHENTICATION_FAILED,
    type: Strings.error_type_error,
    message: 'Failed to authenticate given credentials',
  );

  static final fetchUnViewedCountFailedError = ApiErrorDetails(
    code: ErrorTypes.UNVIEWED_COUNT_FETCH_FAILED,
    type: Strings.error_type_error,
    message: 'Failed to fetch unviewed notifications count',
  );

  static final notificationFetchFailedError = ApiErrorDetails(
    code: ErrorTypes.NOTIFICATION_FETCH_FAILED,
    type: Strings.error_type_error,
    message: 'Failed to fetch notifications',
  );

  static final markAsReadFailedError = ApiErrorDetails(
    code: ErrorTypes.MARK_AS_READ_FAILED,
    type: Strings.error_type_error,
    message: 'Failed to mark notification as read',
  );

  static final deleteFailedError = ApiErrorDetails(
    code: ErrorTypes.DELETE_FAILED,
    type: Strings.error_type_error,
    message: 'Failed to delete notification',
  );

  static final deleteAllFailedError = ApiErrorDetails(
    code: ErrorTypes.BULK_DELETE_FAILED,
    type: Strings.error_type_error,
    message: 'Bulk deletion of notifications failed',
  );

  static final markAllAsViewedError = ApiErrorDetails(
    code: ErrorTypes.MARK_ALL_AS_VIEWED_FAILED,
    type: Strings.error_type_error,
    message: 'Failed to mark notification as viewed',
  );

  static final outsideSirenContextError = ApiErrorDetails(
    code: ErrorTypes.OUTSIDE_SIREN_CONTEXT,
    type: Strings.error_type_error,
    message: 'Trying to invoke function outside the siren context',
  );

  static final authenticationPending = ApiErrorDetails(
    code: ErrorTypes.AUTHENTICATION_PENDING,
    type: Strings.error_type_error,
    message: 'Authentication in progress',
  );

  static final unauthorizedOperationError = ApiErrorDetails(
    code: ErrorTypes.UNAUTHORIZED_OPERATION,
    type: Strings.error_type_error,
    message: 'This operation require valid credentials',
  );

  static const rawResponseError =
      '{"data": null,"error": "AUTHENTICATION FAILED","errors":null,"meta":null}';
}

enum Status {
  PENDING,
  SUCCESS,
  FAILED,
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
