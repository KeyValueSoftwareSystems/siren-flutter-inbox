class Generics {
  Generics._();

  static const String API_DOMAIN = 'https://api.dev.sirenapp.io/';

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
