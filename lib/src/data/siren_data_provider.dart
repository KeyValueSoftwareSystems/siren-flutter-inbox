import 'dart:async';

import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';

class SirenDataProvider {
  factory SirenDataProvider() {
    return instance;
  }

  SirenDataProvider._internal() {
    _controller = StreamController<StreamResponse>();
    _iconController = StreamController<StreamResponse>();
  }
  static final SirenDataProvider instance = SirenDataProvider._internal();
  String userToken = '';
  String recipientId = '';

  late StreamController<StreamResponse> _controller;
  late StreamController<StreamResponse> _iconController;

  StreamController<StreamResponse> get controller => _controller;

  StreamController<StreamResponse> get iconController => _iconController;

  void updateParams({
    required String userToken,
    required String recipientId,
  }) {
    instance.userToken = userToken;
    instance.recipientId = recipientId;
  }

  void dispose() {
    _controller.close();
    _iconController.close();
    _controller = StreamController<StreamResponse>();
    _iconController = StreamController<StreamResponse>();
  }
}
