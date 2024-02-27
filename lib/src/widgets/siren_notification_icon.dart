import 'package:flutter/material.dart';

class NotificationIconWidget extends StatelessWidget {
  const NotificationIconWidget({
    super.key,
    this.count,
    this.darkMode = false,
    this.notificationIcon,
    this.onError,
    this.enableCount = true,
  });

  final bool? enableCount;
  final int? count;
  final bool? darkMode;
  final Function? onError;
  final Widget? notificationIcon;

  final iconSize = 40.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        notificationIcon ??
            Icon(
              Icons.notifications_none_outlined,
              size: iconSize,
            ),
        if (enableCount ?? false) _getBadge(),
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
