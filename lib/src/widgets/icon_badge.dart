import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';

class IconBadge extends StatelessWidget {
  const IconBadge({
    required this.badgeStyle,
    required this.notificationsCount,
    required this.hideBadge,
    required this.badgeBackgroundColor,
    required this.color,
    super.key,
  });

  final BadgeStyle? badgeStyle;
  final int notificationsCount;
  final bool hideBadge;
  final Color badgeBackgroundColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return hideBadge
        ? const SizedBox()
        : Positioned(
            right: badgeStyle?.right ?? DefaultIconStyle.defaultRight,
            top: badgeStyle?.top ?? DefaultIconStyle.defaultTop,
            child: Container(
              width: badgeStyle?.size ?? DefaultIconStyle.defaultSize,
              height: badgeStyle?.size ?? DefaultIconStyle.defaultSize,
              padding: const EdgeInsets.all(
                1,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badgeBackgroundColor,
              ),
              child: Align(
                child: Text(
                  notificationsCount > 99
                      ? '99+'
                      : notificationsCount.toString(),
                  style: TextStyle(
                    color: color,
                    fontSize: badgeStyle?.fontSize ??
                        DefaultIconStyle.defaultFontSize,
                  ),
                ),
              ),
            ),
          );
  }
}
