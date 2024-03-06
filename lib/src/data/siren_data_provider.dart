class SirenDataProvider {
  factory SirenDataProvider() {
    return instance;
  }

  SirenDataProvider._internal();
  static final SirenDataProvider instance = SirenDataProvider._internal();
  String userToken = '';
  String recipientId = '';

  void updateParams({
    required String userToken,
    required String recipientId,
  }) {
    instance.userToken = userToken;
    instance.recipientId = recipientId;
  }
}
