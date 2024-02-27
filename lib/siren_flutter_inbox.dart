library siren_flutter_inbox;

import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/widgets/siren_notification_icon.dart';

/// A Demo Text UI.
class CustomText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('THE DEMO TEXT WIDGET');
  }
}

class SirenNotificationIconWidget extends StatelessWidget {
  const SirenNotificationIconWidget({
    super.key,
    this.darkMode,
    this.notificationIcon,
    this.onError,
    this.realTimeUnviewedCountEnabled = true,
  });
  final bool? darkMode;
  final bool? realTimeUnviewedCountEnabled;
  final Function? onError;
  final Widget? notificationIcon;
  @override
  Widget build(BuildContext context) {
    return NotificationIconWidget(
      count: 25,
      darkMode: darkMode,
      enableCount: realTimeUnviewedCountEnabled,
      notificationIcon: notificationIcon,
      onError: onError,
    );
  }
}
