import 'package:flutter/material.dart';

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
    final currentTheme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedCircleAvatar(theme: currentTheme),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnimatedContainer(height: 18, theme: currentTheme),
                  const SizedBox(height: 8),
                  _buildAnimatedContainer(height: 18, theme: currentTheme),
                  const SizedBox(height: 8),
                  _buildAnimatedContainer(height: 18, theme: currentTheme),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildAnimatedCircleAvatar(
                        theme: currentTheme,
                        radius: 5,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildAnimatedContainer(
                          theme: currentTheme,
                          height: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildAnimatedDeleteIcon(theme: currentTheme),
        ],
      ),
    );
  }

  Widget _buildAnimatedCircleAvatar({
    required ThemeData theme,
    double radius = 21,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.outlineVariant
                .withOpacity(0.5 + 0.5 * _controller.value),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedContainer({
    required ThemeData theme,
    required double height,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: theme.colorScheme.outlineVariant
                .withOpacity(0.5 + 0.5 * _controller.value),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedDeleteIcon({
    required ThemeData theme,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: theme.colorScheme.outlineVariant
                .withOpacity(0.5 + 0.5 * _controller.value),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}
