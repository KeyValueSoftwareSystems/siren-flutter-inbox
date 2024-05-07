// ignore_for_file: cascade_invocations

import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/src/theme/app_theme.dart';

class MediaErrorWidget extends StatelessWidget {
  const MediaErrorWidget({
    required this.isDarkMode,
    super.key,
  });

  final bool isDarkMode;
  @override
  Widget build(BuildContext context) {
    final defaultColors = SirenAppTheme.colors(isDarkMode: isDarkMode);
    return Align(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                6,
              ),
              border: Border.all(
                color: defaultColors.avatarIconColor,
                width: 3,
              ),
            ),
            width: 30,
            height: 27,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Icon(
              Icons.landscape_sharp,
              size: 27,
              color: defaultColors.avatarIconColor,
            ),
          ),
          CustomPaint(
            size: const Size(30, 27),
            painter: DiagonalPainter(
              defaultColors.avatarBackground,
              defaultColors.avatarIconColor,
            ),
          ),
        ],
      ),
    );
  }
}

class DiagonalPainter extends CustomPainter {
  DiagonalPainter(this.lightLineColor, this.darkLineColor);
  final Color lightLineColor;
  final Color darkLineColor;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    const lineWidth = 3.0;
    const gap = 4.0;

    final lightColorPaint = Paint()
      ..color = lightLineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final darkColorPaint = Paint()
      ..color = darkLineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final lightColorPath = Path();
    lightColorPath
      ..moveTo(
        size.width + 2,
        size.height + 2,
      )
      ..lineTo(-2, -2);

    final darkColorPath = Path();
    darkColorPath
      ..moveTo(
        size.width + gap,
        size.height,
      )
      ..lineTo(-2 + gap, -2);

    canvas
      ..drawPath(lightColorPath, lightColorPaint)
      ..drawPath(darkColorPath, darkColorPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
