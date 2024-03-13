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

  static const BELL_ICON_PATH =
      'packages/siren_flutter_inbox/assets/images/bell.png';

  static final DEFAULT_ERROR = ApiErrorDetails(
    errorCode: 'DEFAULT',
    message: 'default error message',
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

enum StateUpdationApi {
  READ_BY_ID,
  READ_ALL,
  DELETE_BY_ID,
  DELETE_ALL,
  VIEW_ALL
}
