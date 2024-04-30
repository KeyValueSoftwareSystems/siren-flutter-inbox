import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/constants/strings.dart';

class Errors {
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
