import 'package:flutter/material.dart';

class SirenNotificationIconWidget extends StatelessWidget {
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

  final iconSize = 40.0;
  final count = 10;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        notificationIcon ??
            Icon(
              Icons.notifications_none_outlined,
              size: iconSize,
            ),
        if (realTimeUnviewedCountEnabled ?? false) _getBadge(),
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
          count! > 99 ? '99+' : count.toString(), // Badge count
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
