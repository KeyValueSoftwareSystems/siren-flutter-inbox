import 'package:flutter/material.dart';

class SirenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SirenAppBar({
    required this.theme,
    required this.title,
    required this.showBackButton,
    required this.showClearAllButton,
    super.key,
    this.onBackButtonPressed,
    this.hideClearAll = false,
    this.onClearAllPressed,
    this.hideHeader = false,
  });
  final ThemeData theme;
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;
  final bool hideClearAll;
  final VoidCallback? onClearAllPressed;
  final bool hideHeader;
  final bool showClearAllButton;

  @override
  Size get preferredSize {
    return hideHeader ? Size.zero : const Size.fromHeight(kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    if (hideHeader) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.surfaceTint,
          ),
        ),
      ),
      height: preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (showBackButton)
                IconButton(
                  onPressed:
                      onBackButtonPressed ?? () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: showBackButton ? 2 : 24),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (!hideClearAll && showClearAllButton)
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: GestureDetector(
                onTap: onClearAllPressed,
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.clear_all,
                        size: 24,
                      ),
                    ),
                    Text(
                      'Clear All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
