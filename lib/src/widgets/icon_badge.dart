import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';

class IconBadge extends StatelessWidget {
  const IconBadge({
    required this.badgeStyle,
    required this.notificationsCount,
    required this.hideBadge,
    super.key,
  });

  final BadgeStyle? badgeStyle;
  final int notificationsCount;
  final bool hideBadge;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return hideBadge
        ? const SizedBox()
        : Positioned(
            right: badgeStyle?.right ?? DefaultIconStyle.defaultRight,
            top: badgeStyle?.top ?? DefaultIconStyle.defaultTop,
            child: Container(
              width: badgeStyle?.size ?? DefaultIconStyle.defaultSize,
              height: badgeStyle?.size ?? DefaultIconStyle.defaultSize,
              padding: EdgeInsets.all(
                badgeStyle?.inset ?? DefaultIconStyle.defaultInset,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentTheme.colorScheme.tertiaryContainer,
              ),
              child: Align(
                child: Text(
                  notificationsCount > 99
                      ? '99+'
                      : notificationsCount.toString(),
                  style: TextStyle(
                    color: currentTheme.colorScheme.onTertiary,
                    fontSize: badgeStyle?.fontSize ??
                        DefaultIconStyle.defaultFontSize,
                  ),
                ),
              ),
            ),
          );
  }
}
