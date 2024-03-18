import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/constants/strings.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCircle(currentTheme),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: Text(
                Strings.error_title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: currentTheme.colorScheme.tertiary,
                ),
              ),
            ),
            Text(
              Strings.error_desc,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: currentTheme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCircle(ThemeData theme) {
  return Container(
    width: 160,
    height: 160,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: theme.colorScheme.surfaceTint.withOpacity(0.2),
    ),
    child: Icon(
      Icons.warning_rounded,
      size: 84,
      color: theme.colorScheme.surfaceTint,
    ),
  );
}
