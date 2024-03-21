import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';

class Generics {
  Generics._();

  static const String V2 = 'v2';
  static const String BASE_URL = '/in-app/recipients/';

  static const int DATA_FETCH_INTERVAL = 5;
  static const String PLACEHOLDER_IMAGE_URL = 'https://picsum.photos/200/300';
  static const int PAGE_SIZE = 20;
  static const int MAX_RETRIES = 3;
  static const String ENV_PATH = 'packages/siren_flutter_inbox/.env';

  static final defaultError = ApiErrorDetails(
    errorType: ErrorTypes.GENERIC_API_ERROR,
    errorCode: 'INTERNAL SERVER ERROR',
    message:
        'Oops something went wrong, if issue persist please contact Siren Team',
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
}

enum ErrorTypes {
  GENERIC_API_ERROR,
  AUTHENTICATION_FAILED,
  FETCH_COUNT_FAILED,
  NOTIFICATION_FETCH_FAILED,
  NOTIFICATION_READ_FAILED,
  NOTIFICATION_DELETE_FAILED,
  UPDATE_VIEWED_FAILED,
}
