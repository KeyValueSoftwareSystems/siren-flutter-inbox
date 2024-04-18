import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/src/constants/strings.dart';
import 'package:sirenapp_flutter_inbox/src/models/ui_models.dart';

class SirenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SirenAppBar({
    required this.theme,
    required this.isNonEmptyNotifications,
    super.key,
    this.onClearAllPressed,
    this.headerParams,
    this.styles,
  });
  final ThemeData theme;
  final VoidCallback? onClearAllPressed;
  final bool isNonEmptyNotifications;
  final HeaderParams? headerParams;
  final CustomStyles? styles;

  @override
  Size get preferredSize {
    return headerParams?.hideHeader ?? false
        ? Size.zero
        : const Size.fromHeight(kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    if (headerParams?.hideHeader ?? false) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor ?? theme.colorScheme.primary,
        border: Border(
          bottom: BorderSide(
            width: styles?.appBarStyle?.borderWidth ?? 1,
            color:
                theme.appBarTheme.shadowColor ?? theme.colorScheme.surfaceTint,
          ),
        ),
      ),
      height: preferredSize.height,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 20),
        child: headerParams?.customHeader ??
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (headerParams?.showBackButton ?? false)
                      Semantics(
                        label: 'siren-header-back',
                        hint: 'Tap to view navigate back',
                        child: GestureDetector(
                          key: const Key('siren-header-back'),
                          onTap: headerParams?.onBackPress,
                          child: headerParams?.backButton ??
                              Icon(
                                Icons.arrow_back_ios,
                                color: theme.bannerTheme.dividerColor ??
                                    theme.colorScheme.onBackground,
                                size: 20,
                              ),
                        ),
                      ),
                    Padding(
                      padding:
                          styles?.appBarStyle?.titlePadding ?? EdgeInsets.zero,
                      child: Text(
                        headerParams?.title ?? Strings.notifications,
                        style: styles?.appBarStyle?.headerTextStyle ??
                            TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: theme.bannerTheme.dividerColor ??
                                  theme.colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ],
                ),
                if (!(headerParams?.hideClearAll ?? false))
                  Semantics(
                    label: 'siren-header-clear-all',
                    hint: 'Tap to clear all notifications',
                    child: GestureDetector(
                      key: const Key('siren-header-clear-all'),
                      onTap: () {
                        if (isNonEmptyNotifications &&
                            onClearAllPressed != null) {
                          onClearAllPressed!();
                        }
                      },
                      child: Opacity(
                        opacity: isNonEmptyNotifications ? 1 : 0.4,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                Icons.clear_all,
                                size: styles?.clearAllIconSize ?? 24,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            Text(
                              Strings.clear_all,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: theme.appBarTheme.foregroundColor ??
                                    theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      ),
    );
  }
}
