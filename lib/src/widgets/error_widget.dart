import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/src/constants/strings.dart';
import 'package:sirenapp_flutter_inbox/src/theme/app_colors.dart';
import 'package:sirenapp_flutter_inbox/src/theme/app_theme.dart';

class DefaultErrorWidget extends StatelessWidget {
  const DefaultErrorWidget({
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
              Strings.error_title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.errorWidgetText1,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              Strings.error_desc,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: colors.errorWidgetText1,
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
  return Container(
    width: 160,
    height: 160,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: colors.errorWidgetIconContainer,
    ),
    child: Icon(
      Icons.warning_rounded,
      size: 84,
      color: colors.errorWidgetIconColor,
    ),
  );
}
