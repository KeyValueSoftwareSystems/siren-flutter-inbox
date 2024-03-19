import 'dart:async';

import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/api/verify_token.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/utils/common_utils.dart';

class SirenDataProvider {
  factory SirenDataProvider() {
    return instance;
  }

  SirenDataProvider._internal() {
    _inboxController = StreamController<StreamResponse>.broadcast();
    _iconController = StreamController<StreamResponse>.broadcast();
  }
  static final SirenDataProvider instance = SirenDataProvider._internal();
  String userToken = '';
  String recipientId = '';
  String apiDomain = '';
  int _retryCount = 0;

  Status _tokenVerificationStatus = Status.PENDING;
  ApiResponse _tokenVerificationResponse = ApiResponse()..isLoading;

  late StreamController<StreamResponse> _inboxController;
  late StreamController<StreamResponse> _iconController;

  StreamController<StreamResponse> get inboxController => _inboxController;

  StreamController<StreamResponse> get iconController => _iconController;

  Status get tokenVerificationStatus => _tokenVerificationStatus;

  Future<void> initialize() async {
    apiDomain = await getApiDomain();
  }

  void updateParams({
    required String userToken,
    required String recipientId,
  }) {
    instance.userToken = userToken;
    instance.recipientId = recipientId;
    _tokenVerificationStatus = Status.PENDING;
    _retryCount = 0;
    _verifyToken();
  }

  Future<void> _verifyToken() async {
    _tokenVerificationResponse = await VerifyToken.instance.verifyToken();
    if (_tokenVerificationResponse.isSuccess) {
      _retryCount = 0;
      _tokenVerificationStatus = _tokenVerificationResponse.data as Status;
      SirenDataProvider.instance.iconController.sink.add(
        StreamResponse(
          _tokenVerificationResponse,
          UpdateEvents.TOKEN_VERIFIED,
          '',
        ),
      );
      SirenDataProvider.instance.inboxController.sink.add(
        StreamResponse(
          _tokenVerificationResponse,
          UpdateEvents.TOKEN_VERIFIED,
          '',
        ),
      );
    } else {
      if (_retryCount < Generics.MAX_RETRIES &&
          _tokenVerificationStatus != Status.SUCCESS) {
        _tokenVerificationStatus = Status.FAILED;
        _retryCount++;
        Future.delayed(
          const Duration(seconds: Generics.DATA_FETCH_INTERVAL),
          _verifyToken,
        );
      }
    }
  }

  void iconDispose() {
    _iconController.close();
    _iconController = StreamController<StreamResponse>();
  }

  void inboxDispose() {
    _inboxController.close();
    _inboxController = StreamController<StreamResponse>();
  }
}
