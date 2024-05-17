class Generics {
  Generics._();

  static const String V2 = 'v2';
  static const String BASE_URL = '/in-app/recipients/';

  static const int DATA_FETCH_INTERVAL = 5;
  static const int PAGE_SIZE = 20;
  static const int AVERAGE_ITEMS_ON_SCREEN = 7;
  static const int MAX_RETRIES = 2;
  static const String ENV_PATH = 'packages/sirenapp_flutter_inbox/env';
}

enum Status {
  PENDING,
  SUCCESS,
  FAILED,
  IN_PROGRESS,
  INVALID_CREDENTIALS,
}

enum InboxTabs { ALL, UNREAD }

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
