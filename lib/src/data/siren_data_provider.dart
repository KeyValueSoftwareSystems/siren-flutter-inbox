class SirenDataProvider {
  factory SirenDataProvider() {
    return instance;
  }

  SirenDataProvider._internal();
  static final SirenDataProvider instance = SirenDataProvider._internal();
  String userToken = '95d5544c106543e799084e19a988fd31';
  String recipientId = '64a0811d-982b-4f8e-9601-d5adcc1fe7e2';

  void updateParams({
    required String userToken,
    required String recipientId,
  }) {
    instance.userToken = userToken;
    instance.recipientId = recipientId;
  }
}
