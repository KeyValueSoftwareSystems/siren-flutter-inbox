// ignore_for_file: constant_identifier_names

class Generics {
  Generics._();

  static const String BASE_URL = 'https://api.dev.sirenapp.io/';
  static const String API_PATH = 'api/v2/in-app/';
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
