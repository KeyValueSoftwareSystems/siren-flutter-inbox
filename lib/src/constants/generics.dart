class Generics {
  Generics._();

  static const String BASE_URL = 'https://api.dev.sirenapp.io/';
  static const String API_PATH = 'api/v2/in-app/';
  static const int DATA_FETCH_INTERVAL = 5;
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
