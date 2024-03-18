import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';

class Generics {
  Generics._();

  static const String API_DOMAIN = 'https://api.dev.sirenapp.io/';
  static String API_PATH =
      'api/v2/in-app/recipients/${SirenDataProvider.instance.recipientId}';

  static const int DATA_FETCH_INTERVAL = 5;
  static const String PLACEHOLDER_IMAGE_URL = 'https://picsum.photos/200/300';
  static const int PAGE_SIZE = 10;

  static final DEFAULT_ERROR = ApiErrorDetails(
    errorType: ErrorTypes.DEFAULT_ERROR,
    errorCode: 'INTERNAL SERVER ERROR',
    message:
        'Oops something went wrong, if issue persist please contact Siren Team',
  );
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
  DEFAULT_ERROR,
  AUTHENTICATION_ERROR,
  FETCH_COUNT_ERROR,
  NOTIFICATION_FETCH_ERROR,
  NOTIFICATION_READ_ERROR,
  NOTIFICATION_DELETE_ERROR,
  UPDATE_VIEWED_ERROR,
}
