import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';

class Generics {
  Generics._();

  static const String API_DOMAIN = 'https://api.dev.sirenapp.io/';
  static String API_PATH =
      'api/v2/in-app/recipients/${SirenDataProvider.instance.recipientId}';

  static const int DATA_FETCH_INTERVAL = 5;
  static const String PLACEHOLDER_IMAGE_URL = 'https://picsum.photos/200/300';
  static const int PAGE_SIZE = 10;
}

enum VerificationStatus {
  PENDING,
  SUCCESS,
  FAILED,
}

enum BulkUpdateType {
  MARK_AS_READ,
  MARK_AS_DELETED,
}
