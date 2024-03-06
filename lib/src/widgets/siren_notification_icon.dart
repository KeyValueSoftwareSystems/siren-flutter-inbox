import 'dart:async';

import 'package:flutter/material.dart';

import 'package:siren_flutter_inbox/src/api/fetch_unviewed_notification_count.dart';
import 'package:siren_flutter_inbox/src/api/verify_token.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';

class SirenNotificationIconWidget extends StatefulWidget {
  const SirenNotificationIconWidget({
    super.key,
    this.darkMode = false,
    this.notificationIcon,
    this.onError,
    this.realTimeUnviewedCountEnabled = true,
    this.onTap,
  });

  final bool? realTimeUnviewedCountEnabled;
  final bool? darkMode;
  final void Function(ApiErrorDetails)? onError;
  final Widget? notificationIcon;
  final VoidCallback? onTap;

  @override
  State<SirenNotificationIconWidget> createState() =>
      _SirenNotificationIconWidgetState();
}

class _SirenNotificationIconWidgetState
    extends State<SirenNotificationIconWidget> {
  final iconSize = 40.0;

  int _notificationsCount = 0;

  ApiResponse _tokenVerificationResponse = ApiResponse()..isLoading;
  VerificationStatus _tokenVerificationStatus = VerificationStatus.PENDING;

  late Timer _periodicUpdateRef;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _periodicUpdateRef.cancel();
    super.dispose();
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
      if (_tokenVerificationStatus == VerificationStatus.SUCCESS) {
        final response = await FetchUnviewedNotificationsCount.instance
            .fetchUnviewedNotificationsCount();
        _startRealTimeUnviewedCountFetch();
        setState(() {
          updateNotificationsCount(response.data);
        });
      }
    } else if (_tokenVerificationResponse.isError) {
      widget.onError
          ?.call(_tokenVerificationResponse.error ?? ApiErrorDetails());
    }
    ;
  }

  Future<void> verifyToken() async {
    _tokenVerificationResponse = await VerifyToken.instance.verifyToken();
    _tokenVerificationStatus =
        _tokenVerificationResponse.data as VerificationStatus;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () {},
      child: Stack(
        children: [
          widget.notificationIcon ??
              Icon(
                Icons.notifications_none_outlined,
                size: iconSize,
              ),
          if ((widget.realTimeUnviewedCountEnabled ?? true) &&
              _notificationsCount > 0)
            _getBadge(),
        ],
      ),
    );
  }

  Widget _getBadge() {
    return Positioned(
      right: 0,
      top: iconSize / 12,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: Text(
          _notificationsCount.toString(), // Badge count
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
