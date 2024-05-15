import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/theme/app_theme.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({
    required this.hideAvatar,
    this.customLoader,
    this.isDarkMode,
    super.key,
  });

  final Widget? customLoader;
  final bool hideAvatar;
  final bool? isDarkMode;

  @override
  Widget build(BuildContext context) {
    final defaultColors = SirenAppTheme.colors(isDarkMode: isDarkMode ?? false);
    return customLoader ??
        ListView.builder(
          itemCount: Generics.PAGE_SIZE,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                padding: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: defaultColors.cardBorderColor,
                      width: 0.25,
                    ),
                  ),
                ),
                child: CardLoaderWidget(
                  hideAvatar: hideAvatar,
                  isDarkMode: isDarkMode,
                ),
              ),
            );
          },
        );
  }
}

class CardLoaderWidget extends StatefulWidget {
  const CardLoaderWidget({
    required this.hideAvatar,
    this.isDarkMode,
    super.key,
  });

  final bool hideAvatar;
  final bool? isDarkMode;

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
    final defaultColors =
        SirenAppTheme.colors(isDarkMode: widget.isDarkMode ?? false);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.hideAvatar)
            Padding(
              padding: const EdgeInsets.only(right: 6, left: 6),
              child: _buildAnimatedWidget(
                builder: (context, child) => Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: defaultColors.skeletonLoaderColor
                        .withOpacity(0.5 + 0.5 * _controller.value),
                  ),
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnimatedWidget(
                    builder: (context, child) => Container(
                      height: 18,
                      decoration: BoxDecoration(
                        color: defaultColors.skeletonLoaderColor
                            .withOpacity(0.5 + 0.5 * _controller.value),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAnimatedWidget(
                    builder: (context, child) => Container(
                      height: 18,
                      decoration: BoxDecoration(
                        color: defaultColors.skeletonLoaderColor
                            .withOpacity(0.5 + 0.5 * _controller.value),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAnimatedWidget(
                    builder: (context, child) => Container(
                      height: 18,
                      decoration: BoxDecoration(
                        color: defaultColors.skeletonLoaderColor
                            .withOpacity(0.5 + 0.5 * _controller.value),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildAnimatedWidget(
                        builder: (context, child) => Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: defaultColors.skeletonLoaderColor
                                .withOpacity(0.5 + 0.5 * _controller.value),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildAnimatedWidget(
                          builder: (context, child) => Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: defaultColors.skeletonLoaderColor
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
            builder: (context, child) => Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: defaultColors.skeletonLoaderColor
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
    required Widget Function(BuildContext, Widget?) builder,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: AnimatedBuilder(
        animation: _controller,
        builder: builder,
      ),
    );
  }
}
