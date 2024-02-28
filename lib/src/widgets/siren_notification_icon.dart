import 'package:flutter/material.dart';

import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/api/fetch_unviewed_notification_count.dart';
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

  int count = 10;

  late final String token;
  late final String id;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access the inherited widget and perform initialization tasks
    final sirenProvider = SirenProvider.of(context);
    token = sirenProvider?.userToken ?? '';
    id = sirenProvider?.recipientId ?? '';
    SirenDataProvider.instance.updateParams(userToken: token, recipientId: id);

    // TODO: need to change this
    callApi();
  }

  Future<void> callApi() async {
    final data = await FetchUnviewedNotificationsCount.instance
        .fetchUnviewedNotificationsCount();
    count = data;
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
        if (widget.realTimeUnviewedCountEnabled ?? false) _getBadge(),
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
          count.toString(), // Badge count
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
