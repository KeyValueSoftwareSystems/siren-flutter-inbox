import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/src/constants/strings.dart';
import 'package:sirenapp_flutter_inbox/src/theme/app_colors.dart';
import 'package:sirenapp_flutter_inbox/src/theme/app_theme.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    this.isDarkMode,
    super.key,
  });

  final bool? isDarkMode;

  @override
  Widget build(BuildContext context) {
    final colors = SirenAppTheme.colors(isDarkMode: isDarkMode ?? false);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCircle(colors),
            const SizedBox(
              height: 10,
            ),
            Text(
              Strings.empty_title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.emptyScreenTitle,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              Strings.empty_desc,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: colors.emptyScreenDescription,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCircle(AppColors colors) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.emptyWidgetBackground,
        ),
      ),
      Icon(
        Icons.notifications,
        size: 84,
        color: colors.emptyWidgetIconColor,
      ),
      Positioned(
        right: 50,
        top: 55,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.emptyWidgetNotificationIconColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.emptyWidgetBorderColor,
              width: 3,
            ),
          ),
          child: const Text(
            '0',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    ],
  );
}
