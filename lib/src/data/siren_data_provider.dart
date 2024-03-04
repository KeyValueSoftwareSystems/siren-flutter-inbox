class SirenDataProvider {
  factory SirenDataProvider() {
    return instance;
  }

  SirenDataProvider._internal();
  static final SirenDataProvider instance = SirenDataProvider._internal();
  String userToken = '080f749eb36e4d3fa7535112cbcdc0be';
  String recipientId = '4c6bc2b6-b2ca-49cc-8599-39b651d62520';

  void updateParams({
    required String userToken,
    required String recipientId,
  }) {
    instance.userToken = userToken;
    instance.recipientId = recipientId;
  }
}
