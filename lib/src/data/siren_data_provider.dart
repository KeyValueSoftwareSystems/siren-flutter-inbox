import 'dart:async';

import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';

class SirenDataProvider {
  factory SirenDataProvider() {
    return instance;
  }

  SirenDataProvider._internal();
  static final SirenDataProvider instance = SirenDataProvider._internal();
  String userToken = '';
  String recipientId = '';

  StreamController<StreamResponse> controller =
      StreamController<StreamResponse>();
  StreamController<StreamResponse> iconController =
      StreamController<StreamResponse>();

  void updateParams({
    required String userToken,
    required String recipientId,
  }) {
    instance.userToken = userToken;
    instance.recipientId = recipientId;
  }
}
