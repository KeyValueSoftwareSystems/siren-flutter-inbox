import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({
    required this.hideAvatar,
    super.key,
    this.customLoader,
  });

  final Widget? customLoader;
  final bool hideAvatar;

  @override
  Widget build(BuildContext context) {
    return customLoader ??
        ListView.builder(
          itemCount: Generics.PAGE_SIZE,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CardLoaderWidget(hideAvatar: hideAvatar),
            );
          },
        );
  }
}

class CardLoaderWidget extends StatefulWidget {
  const CardLoaderWidget({
    required this.hideAvatar,
    super.key,
  });

  final bool hideAvatar;

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
          if (!widget.hideAvatar)
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: _buildAnimatedWidget(
                theme: currentTheme,
                builder: (context, child) => Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentTheme.colorScheme.onSecondary
                        .withOpacity(0.5 + 0.5 * _controller.value),
                  ),
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnimatedWidget(
                    theme: currentTheme,
                    builder: (context, child) => Container(
                      height: 18,
                      decoration: BoxDecoration(
                        color: currentTheme.colorScheme.onSecondary
                            .withOpacity(0.5 + 0.5 * _controller.value),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildAnimatedWidget(
                    theme: currentTheme,
                    builder: (context, child) => Container(
                      height: 18,
                      decoration: BoxDecoration(
                        color: currentTheme.colorScheme.onSecondary
                            .withOpacity(0.5 + 0.5 * _controller.value),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildAnimatedWidget(
                    theme: currentTheme,
                    builder: (context, child) => Container(
                      height: 18,
                      decoration: BoxDecoration(
                        color: currentTheme.colorScheme.onSecondary
                            .withOpacity(0.5 + 0.5 * _controller.value),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildAnimatedWidget(
                        theme: currentTheme,
                        builder: (context, child) => Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentTheme.colorScheme.onSecondary
                                .withOpacity(0.5 + 0.5 * _controller.value),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildAnimatedWidget(
                          theme: currentTheme,
                          builder: (context, child) => Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: currentTheme.colorScheme.onSecondary
                                  .withOpacity(0.5 + 0.5 * _controller.value),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildAnimatedWidget(
            theme: currentTheme,
            builder: (context, child) => Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: currentTheme.colorScheme.onSecondary
                    .withOpacity(0.5 + 0.5 * _controller.value),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedWidget({
    required ThemeData theme,
    required Widget Function(BuildContext, Widget?) builder,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: builder,
    );
  }
}
