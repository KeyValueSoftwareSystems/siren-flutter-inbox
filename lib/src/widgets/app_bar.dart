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
    this.categories = const [],
    this.selectedValues = const [],
    this.onCategorySelected,
    this.dropdownItemBuilder,
    this.categoryStyle,
    super.key,
  });

  final VoidCallback? onClearAllPressed;
  final bool isNonEmptyNotifications;
  final HeaderParams? headerParams;
  final CustomStyles? styles;
  final CustomThemeColors? colors;
  final bool? isDarkMode;
  final List<String> categories;
  final List<String> selectedValues;
  final void Function(String)? onCategorySelected;
  final Widget Function(String)? dropdownItemBuilder;
  final CategoryStyle? categoryStyle;

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
        border: styles?.hideTabMargin?.upper != true
            ? Border(
                bottom: BorderSide(
                  width: styles?.appBarStyle?.borderWidth ?? 1,
                  color: colors?.inboxHeaderColors?.borderColor ??
                      defaultColors.appBarBorderColor,
                ),
              )
            : null,
      ),
      height: preferredSize.height,
      child: headerParams?.customHeader ??
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 20),
                child: Row(
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
                        style: styles?.appBarStyle?.headerTextStyle?.copyWith(
                              color: colors?.inboxHeaderColors?.titleColor ??
                                  colors?.textColor ??
                                  defaultColors.appBarTextColor,
                            ) ??
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
              ),
              if (categories.isNotEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: categoryStyle?.container?.padding ??
                          const EdgeInsets.symmetric(horizontal: 12),
                      margin: categoryStyle?.container?.margin,
                      decoration: categoryStyle?.container?.decoration ??
                          BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: null,
                          hint: Row(
                            children: [
                              Expanded(
                                child: selectedValues.isEmpty
                                    ? Text(
                                        'Select Options',
                                        style: categoryStyle
                                                ?.placeholderTextStyle ??
                                            const TextStyle(color: Colors.grey),
                                      )
                                    : Text(
                                        selectedValues.join(', '),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: categoryStyle?.selectedTextStyle,
                                      ),
                              ),
                            ],
                          ),
                          isExpanded: true,
                          items: categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: dropdownItemBuilder?.call(category) ??
                                  Text(
                                    category,
                                    style: categoryStyle?.dropdownTextStyle,
                                  ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            if (value != null && onCategorySelected != null) {
                              onCategorySelected!(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
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
                              size: styles?.clearAllIconStyle?.size ?? 24,
                              color: colors?.clearAllIcon ??
                                  defaultColors.appBarActionText,
                            ),
                          ),
                          Text(
                            Strings.clear_all,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: colors
                                      ?.inboxHeaderColors?.headerActionColor ??
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
    );
  }
}
