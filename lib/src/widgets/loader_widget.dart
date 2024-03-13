import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/theme/colors.dart';

class CardLoaderWidget extends StatefulWidget {
  const CardLoaderWidget({
    super.key,
  });

  @override
  CardLoaderWidgetState createState() => CardLoaderWidgetState();
}

class CardLoaderWidgetState extends State<CardLoaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedCircleAvatar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnimatedContainer(height: 18),
                  const SizedBox(height: 8),
                  _buildAnimatedContainer(height: 18),
                  const SizedBox(height: 8),
                  _buildAnimatedContainer(height: 18),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildAnimatedCircleAvatar(radius: 5),
                      const SizedBox(width: 8),
                      Expanded(child: _buildAnimatedContainer(height: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildAnimatedDeleteIcon(),
        ],
      ),
    );
  }

  Widget _buildAnimatedCircleAvatar({double radius = 21}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.grey300.withOpacity(0.5 + 0.5 * _controller.value),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedContainer({required double height}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.grey300.withOpacity(0.5 + 0.5 * _controller.value),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedDeleteIcon() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.grey300.withOpacity(0.5 + 0.5 * _controller.value),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}
