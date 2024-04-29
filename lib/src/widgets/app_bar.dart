import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/src/constants/strings.dart';
import 'package:sirenapp_flutter_inbox/src/models/ui_models.dart';
import 'package:sirenapp_flutter_inbox/src/theme/app_theme.dart';

class SirenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SirenAppBar({
    required this.isNonEmptyNotifications,
    this.onClearAllPressed,
    this.headerParams,
    this.styles,
    this.colors,
    this.isDarkMode,
    super.key,
  });
  final VoidCallback? onClearAllPressed;
  final bool isNonEmptyNotifications;
  final HeaderParams? headerParams;
  final CustomStyles? styles;
  final CustomThemeColors? colors;
  final bool? isDarkMode;

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
    final defaultColors = SirenAppTheme.colors(isDarkMode: isDarkMode ?? false);
    return Container(
      decoration: BoxDecoration(
        color: colors?.inboxHeaderColors?.background ??
            defaultColors.backgroundColor,
        border: Border(
          bottom: BorderSide(
            width: styles?.appBarStyle?.borderWidth ?? 1,
            color: colors?.inboxHeaderColors?.borderColor ??
                defaultColors.appBarBorderColor,
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
                                color: colors?.inboxHeaderColors?.titleColor ??
                                    defaultColors.appBarBackIcon,
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
                              color: colors?.inboxHeaderColors?.titleColor ??
                                  colors?.textColor ??
                                  defaultColors.appBarTextColor,
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
                                color: colors?.clearAllIcon ??
                                    defaultColors.appBarActionText,
                              ),
                            ),
                            Text(
                              Strings.clear_all,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colors?.inboxHeaderColors
                                        ?.headerActionColor ??
                                    defaultColors.appBarActionText,
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
