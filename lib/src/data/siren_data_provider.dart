import 'dart:async';

import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';

class SirenDataProvider {
  factory SirenDataProvider() {
    return instance;
  }

  SirenDataProvider._internal() {
    _inboxController = StreamController<StreamResponse>();
    _iconController = StreamController<StreamResponse>();
  }
  static final SirenDataProvider instance = SirenDataProvider._internal();
  String userToken = '';
  String recipientId = '';

  late StreamController<StreamResponse> _inboxController;
  late StreamController<StreamResponse> _iconController;

  StreamController<StreamResponse> get controller => _inboxController;

  StreamController<StreamResponse> get iconController => _iconController;

  void updateParams({
    required String userToken,
    required String recipientId,
  }) {
    instance.userToken = userToken;
    instance.recipientId = recipientId;
  }

  void dispose() {
    _inboxController.close();
    _iconController.close();
    _inboxController = StreamController<StreamResponse>();
    _iconController = StreamController<StreamResponse>();
  }
}
