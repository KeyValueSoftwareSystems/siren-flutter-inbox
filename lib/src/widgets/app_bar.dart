import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/src/constants/strings.dart';
import 'package:sirenapp_flutter_inbox/src/models/ui_models.dart';

class SirenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SirenAppBar({
    required this.theme,
    required this.showClearAllButton,
    super.key,
    this.onClearAllPressed,
    this.inboxHeaderProps,
  });
  final ThemeData theme;
  final VoidCallback? onClearAllPressed;
  final bool showClearAllButton;
  final InboxHeaderProps? inboxHeaderProps;

  @override
  Size get preferredSize {
    return inboxHeaderProps?.hideHeader ?? false
        ? Size.zero
        : const Size.fromHeight(kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    if (inboxHeaderProps?.hideHeader ?? false) {
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
      child: inboxHeaderProps?.customHeader ??
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (inboxHeaderProps?.showBackButton ?? false)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 16,
                      ),
                      child: IconButton(
                        onPressed: inboxHeaderProps?.handleBackNavigation,
                        icon: inboxHeaderProps?.backButton ??
                            const Icon(Icons.arrow_back_ios),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          (inboxHeaderProps?.showBackButton ?? false) ? 2 : 24,
                    ),
                    child: Text(
                      inboxHeaderProps?.title ?? 'Notifications',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (!(inboxHeaderProps?.hideClearAll ?? false) &&
                  showClearAllButton)
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
                          Strings.clear_all,
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
