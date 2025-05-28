import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/src/constants/strings.dart';
import 'package:sirenapp_flutter_inbox/src/models/ui_models.dart';
import 'package:sirenapp_flutter_inbox/src/theme/app_colors.dart';
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
    this.placeholderText,
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
  final FilterStyles? categoryStyle;
  final String? placeholderText;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (categories.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _CategoryFilter(
                        categories: categories,
                        selectedValues: selectedValues,
                        onSelectionChanged: onCategorySelected,
                        colors: colors,
                        defaultColors: defaultColors,
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
            ],
          ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.categories,
    required this.selectedValues,
    required this.onSelectionChanged,
    required this.colors,
    required this.defaultColors,
  });

  final List<String> categories;
  final List<String> selectedValues;
  final void Function(String)? onSelectionChanged;
  final CustomThemeColors? colors;
  final AppColors defaultColors;

  Future<void> _showFilterMenu(BuildContext context) async {
    final button = context.findRenderObject()! as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final position = button.localToGlobal(Offset.zero, ancestor: overlay);

    await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height,
        position.dx + button.size.width,
        0,
      ),
      color: colors?.filterColors?.filterDropdownBackgroundColor ??
          defaultColors.filterDropdownBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: categories.map((category) {
        final isSelected = selectedValues.contains(category);
        return PopupMenuItem<String>(
          value: category,
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors?.filterColors?.filterCheckboxCheckedColor ??
                          defaultColors.filterCheckboxCheckedColor
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? colors?.filterColors?.filterCheckboxCheckedColor ??
                            defaultColors.filterCheckboxCheckedColor
                        : colors?.filterColors?.filterCheckboxUncheckedColor ??
                            defaultColors.filterCheckboxUncheckedColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: colors?.filterColors?.checkIconColor ??
                            defaultColors.checkIconColor,
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                category,
                style: TextStyle(
                  fontSize: 14,
                  color: colors?.filterColors?.filterActionTextColor ??
                      defaultColors.filterActionTextColor,
                ),
              ),
            ],
          ),
          onTap: () {
            if (onSelectionChanged != null) {
              onSelectionChanged?.call(category);
            }
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            border: Border.all(
              color: colors?.filterColors?.filterIconBorderColor ??
                  defaultColors.filterIconBorderColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(
              Icons.filter_alt_outlined,
              color: colors?.filterColors?.filterIconColor ??
                  defaultColors.filterIconColor,
            ),
            onPressed: () => _showFilterMenu(context),
          ),
        ),
        if (selectedValues.isNotEmpty)
          Positioned(
            right: -11,
            top: -4,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: colors?.filterColors?.filterBadgeColor ??
                    defaultColors.filterBadgeColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${selectedValues.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
