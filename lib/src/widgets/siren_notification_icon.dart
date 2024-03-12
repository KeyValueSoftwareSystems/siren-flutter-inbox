// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/api/fetch_unviewed_notification_count.dart';
import 'package:siren_flutter_inbox/src/api/verify_token.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/models/ui_models.dart';


class SirenNotificationIconWidget extends StatefulWidget {

  
  const SirenNotificationIconWidget({
    super.key,
    this.darkMode = false,
    this.onError,
    this.notificationIcon,
    this.onTap,
    this.onFetchCountError,
    this.customStyles,
  });

  final bool? darkMode;
  final void Function(ApiErrorDetails)? onError;
  final Widget? notificationIcon;
  final VoidCallback? onTap;
  final void Function(ApiErrorDetails)? onFetchCountError;
  final SirenStyleProps? customStyles;

  @override
  State<SirenNotificationIconWidget> createState() =>
      _SirenNotificationIconWidgetState();
}

class _SirenNotificationIconWidgetState
    extends State<SirenNotificationIconWidget> {
  int _notificationsCount = 0;

  ApiResponse _tokenVerificationResponse = ApiResponse()..isLoading;
  Status _tokenVerificationStatus = Status.PENDING;

  late Timer _periodicUpdateRef;

  late StreamSubscription<StreamResponse> _subscription;

  @override
  void initState() {
    super.initState();
    initialize();
    _subscribeToStream();
  }

  @override
  void dispose() {
    _periodicUpdateRef.cancel();
    super.dispose();
    _subscription.cancel();
    SirenDataProvider.instance.dispose();
  }

  void _subscribeToStream() {
    _subscription = SirenDataProvider.instance.iconController.stream.listen(
      (streamResponse) async {
        if (streamResponse.response?.isSuccess ?? false) {
          if (streamResponse.api == StateUpdationApi.VIEW_ALL) {
            final response = await FetchUnviewedNotificationsCount.instance
                .fetchUnviewedNotificationsCount();
            setState(() {
              updateNotificationsCount(response.data);
            });
          }
        }
      },
    );
  }

  void updateNotificationsCount(dynamic responseData) {
    if (responseData != null && responseData is int) {
      _notificationsCount = responseData;
    }
  }

  void _startRealTimeUnviewedCountFetch() {
    _periodicUpdateRef = Timer.periodic(
        const Duration(seconds: Generics.DATA_FETCH_INTERVAL), (timer) async {
      final response = await FetchUnviewedNotificationsCount.instance
          .fetchUnviewedNotificationsCount();
      setState(() {
        updateNotificationsCount(response.data);
      });
    });
  }

  Future<void> initialize() async {
    await verifyToken();
    if (_tokenVerificationResponse.isSuccess) {
      if (_tokenVerificationStatus == Status.SUCCESS) {
        final response = await FetchUnviewedNotificationsCount.instance
            .fetchUnviewedNotificationsCount();
        if (response.isSuccess) {
          _startRealTimeUnviewedCountFetch();
          setState(
            () {
              updateNotificationsCount(response.data);
            },
          );
        } else if (response.isError) {
          widget.onFetchCountError?.call(response.error ?? ApiErrorDetails());
        }
      }
    } else if (_tokenVerificationResponse.isError) {
      widget.onError
          ?.call(_tokenVerificationResponse.error ?? ApiErrorDetails());
    }
  }

  Future<void> verifyToken() async {
    _tokenVerificationResponse = await VerifyToken.instance.verifyToken();
    _tokenVerificationStatus = _tokenVerificationResponse.data as Status;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () {},
      child: Stack(
        children: [
          SizedBox(
            width: widget.customStyles?.iconStyle?.size ?? 40,
            height: widget.customStyles?.iconStyle?.size ?? 40,
            child: widget.notificationIcon ??
                Image.asset(
                  Generics.BELL_ICON_PATH,
                  fit: BoxFit.contain,
                ),
          ),
          if (_notificationsCount > 0) _getBadge(),
        ],
      ),
    );
  }

  Widget _getBadge() {
    final badgeStyle = widget.customStyles?.badgeStyle;
    return Positioned(
      right: 0,
      top: 0,
      child: Container(
        width: badgeStyle?.size ?? 15,
        height: badgeStyle?.size ?? 15,
        padding: EdgeInsets.all(badgeStyle?.inset ?? 1),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: badgeStyle?.background ?? Colors.red,
        ),
        child: Align(
          child: Text(
            _notificationsCount.toString(),
            style: TextStyle(
              color: badgeStyle?.color ?? Colors.white,
              fontSize: badgeStyle?.fontSize ?? 8,
            ),
          ),
        ),
      ),
    );
  }
}
