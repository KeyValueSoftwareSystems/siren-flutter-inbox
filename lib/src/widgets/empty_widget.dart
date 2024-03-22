import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/constants/strings.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

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
            const SizedBox(
              height: 10,
            ),
            Text(
              Strings.empty_title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: currentTheme.colorScheme.tertiary,
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
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.background,
        ),
      ),
      Icon(
        Icons.landscape_rounded,
        size: 84,
        color: theme.colorScheme.outline,
      ),
    ],
  );
}
