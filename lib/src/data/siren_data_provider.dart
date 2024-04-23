import 'dart:async';

import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/api/verify_token.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/utils/common_utils.dart';

/// Singleton class responsible for providing data to the Siren Inbox and Icon.
class SirenDataProvider {
  factory SirenDataProvider() {
    return instance;
  }

  /// Private constructor to prevent instantiation from outside.
  SirenDataProvider._internal() {
    _inboxController = StreamController<StreamResponse>.broadcast();
    _iconController = StreamController<StreamResponse>.broadcast();
  }

  /// Singleton instance of [SirenDataProvider].
  static final SirenDataProvider instance = SirenDataProvider._internal();

  /// User token for API authentication.
  String userToken = '';

  /// Recipient ID for identifying the user.
  String recipientId = '';

  /// Domain of the API.
  String apiDomain = '';

  int _retryCount = 0;
  Status _tokenVerificationStatus = Status.PENDING;
  ApiResponse _tokenVerificationResponse = ApiResponse()..isLoading;
  bool _isProviderInitialized = false;

  late StreamController<StreamResponse> _inboxController;
  late StreamController<StreamResponse> _iconController;

  /// Getter for the inbox controller stream.
  StreamController<StreamResponse> get inboxController => _inboxController;

  /// Getter for the icon controller stream.
  StreamController<StreamResponse> get iconController => _iconController;

  /// Getter for the token verification status.
  Status get tokenVerificationStatus => _tokenVerificationStatus;

  /// Getter to check if provider initialized
  bool get isProviderInitialized => _isProviderInitialized;

  /// Initializes the Siren Data Provider.
  Future<void> initialize() async {
    _isProviderInitialized = true;
    apiDomain = await getApiDomain();
  }

  /// Updates the user token and recipient ID.
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

  /// Verifies the user token.
  Future<void> _verifyToken() async {
    _tokenVerificationStatus = Status.IN_PROGRESS;
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
        _retryCount++;
        if (SirenDataProvider.instance.userToken.isEmpty ||
            SirenDataProvider.instance.recipientId.isEmpty) {
          _retryCount = Generics.MAX_RETRIES;
          _tokenVerificationStatus = Status.INVALID_CREDENTIALS;
          triggerError();
          return;
        }
        Future.delayed(
          const Duration(seconds: Generics.DATA_FETCH_INTERVAL),
          _verifyToken,
        );
      } else if (_retryCount >= Generics.MAX_RETRIES) {
        _tokenVerificationStatus = Status.FAILED;
        triggerError();
      }
    }
  }

  void triggerError() {
    SirenDataProvider.instance.inboxController.sink.add(
      StreamResponse(
        _tokenVerificationResponse,
        UpdateEvents.SHOW_ERROR,
        '',
      ),
    );
    SirenDataProvider.instance.iconController.sink.add(
      StreamResponse(
        _tokenVerificationResponse,
        UpdateEvents.SHOW_ERROR,
        '',
      ),
    );
  }

  ApiErrorDetails getVerificationErrorType() {
    if (_tokenVerificationStatus == Status.PENDING) {
      return Generics.outsideSirenContextError;
    } else if (_tokenVerificationStatus == Status.IN_PROGRESS) {
      return Generics.authenticationPending;
    } else if (_tokenVerificationStatus == Status.FAILED) {
      return Generics.unauthorizedOperationError;
    } else if (_tokenVerificationStatus == Status.INVALID_CREDENTIALS) {
      return Generics.invalidCredentialsError;
    }
    return Generics.authenticationFailed;
  }

  /// Disposes the icon controller.
  void iconDispose() {
    _iconController.close();
    _iconController = StreamController<StreamResponse>();
  }

  /// Disposes the inbox controller.
  void inboxDispose() {
    _inboxController.close();
    _inboxController = StreamController<StreamResponse>();
  }
}
