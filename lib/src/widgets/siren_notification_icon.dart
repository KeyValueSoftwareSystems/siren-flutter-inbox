import 'dart:async';

import 'package:flutter/material.dart';

import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/api/fetch_unviewed_notification_count.dart';
import 'package:siren_flutter_inbox/src/api/verify_token.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';

class SirenNotificationIconWidget extends StatefulWidget {
  const SirenNotificationIconWidget({
    super.key,
    this.darkMode = false,
    this.notificationIcon,
    this.onError,
    this.realTimeUnviewedCountEnabled = true,
  });

  final bool? realTimeUnviewedCountEnabled;
  final bool? darkMode;
  final Function? onError;
  final Widget? notificationIcon;

  @override
  State<SirenNotificationIconWidget> createState() =>
      _SirenNotificationIconWidgetState();
}

class _SirenNotificationIconWidgetState
    extends State<SirenNotificationIconWidget> {
  final iconSize = 40.0;

  bool _hasInitialized = false;

  int _notificationsCount = 0;

  VerificationStatus _tokenVerificationStatus = VerificationStatus.PENDING;

  late Timer _periodicUpdateRef;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access the inherited widget and perform initialization tasks
    final sirenProvider = SirenProvider.of(context);
    final token = sirenProvider?.userToken ?? '';
    final id = sirenProvider?.recipientId ?? '';
    SirenDataProvider.instance.updateParams(userToken: token, recipientId: id);

    if (!_hasInitialized) {
      initialize();
      _hasInitialized = true;
    }
  }

  @override
  void dispose() {
    _periodicUpdateRef.cancel();
    super.dispose();
  }

  void _startRealTimeUnviewedCountFetch() {
    _periodicUpdateRef = Timer.periodic(
        const Duration(seconds: Generics.DATA_FETCH_INTERVAL), (timer) async {
      final val = await FetchUnviewedNotificationsCount.instance
          .fetchUnviewedNotificationsCount();
      setState(() {
        _notificationsCount = val;
      });
    });
  }

  Future<void> initialize() async {
    await verifyToken();
    if (_tokenVerificationStatus.name == VerificationStatus.SUCCESS.name) {
      final data = await FetchUnviewedNotificationsCount.instance
          .fetchUnviewedNotificationsCount();
      // _startRealTimeUnviewedCountFetch();
      setState(() {
        _notificationsCount = data;
      });
    }
  }

  Future<void> verifyToken() async {
    _tokenVerificationStatus = await VerifyToken.instance.verifyToken();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
