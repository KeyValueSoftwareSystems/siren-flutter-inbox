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
    this.filterIconWidget,
    this.hideBadge = false,
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
  final Widget? filterIconWidget;
  final bool hideBadge;

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
      child: Container(
        margin: const EdgeInsets.only(right: 16, left: 20),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (categories.isNotEmpty)
                      Semantics(
                        label: 'siren-filter',
                        hint: 'Tap to filter notifications by categories',
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            key: const Key('siren-filter'),
                            width: 44,
                            height: 44,
                            child: _CategoryFilter(
                              categories: categories,
                              selectedValues: selectedValues,
                              onSelectionChanged: onCategorySelected,
                              colors: colors,
                              defaultColors: defaultColors,
                              styles: styles,
                              filterIconWidget: filterIconWidget,
                              hideBadge: hideBadge,
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
      ),
    );
  }
}

class _CategoryFilter extends StatefulWidget {
  const _CategoryFilter({
    required this.categories,
    required this.selectedValues,
    required this.onSelectionChanged,
    required this.colors,
    required this.defaultColors,
    required this.styles,
    this.filterIconWidget,
    this.hideBadge = false,
  });

  final List<String> categories;
  final List<String> selectedValues;
  final void Function(String)? onSelectionChanged;
  final CustomThemeColors? colors;
  final AppColors defaultColors;
  final Widget? filterIconWidget;
  final CustomStyles? styles;
  final bool hideBadge;

  @override
  State<_CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<_CategoryFilter> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isDropdownOpen = true;
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isDropdownOpen = false;
  }

  void _handleItemSelection(String category) {
    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged?.call(category);
      // Update the overlay to reflect the new selection
      _overlayEntry?.markNeedsBuild();
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _removeOverlay,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: offset.dy + size.height + 8,
                width: 220,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(-220 + size.width, size.height),
                  child: Material(
                    color: widget.colors?.filterColors?.categoryFilterColors
                            ?.filterDropdownBackgroundColor ??
                        widget.defaultColors.filterDropdownBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (_) => true,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.categories.length,
                            itemBuilder: (context, index) {
                              final category = widget.categories[index];
                              final isSelected =
                                  widget.selectedValues.contains(category);

                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _handleItemSelection(category),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? widget
                                                      .colors
                                                      ?.filterColors
                                                      ?.categoryFilterColors
                                                      ?.filterCheckboxCheckedColor ??
                                                  widget.defaultColors
                                                      .filterCheckboxCheckedColor
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: isSelected
                                                ? widget
                                                        .colors
                                                        ?.filterColors
                                                        ?.categoryFilterColors
                                                        ?.filterCheckboxCheckedColor ??
                                                    widget.defaultColors
                                                        .filterCheckboxCheckedColor
                                                : widget
                                                        .colors
                                                        ?.filterColors
                                                        ?.categoryFilterColors
                                                        ?.filterCheckboxUncheckedColor ??
                                                    widget.defaultColors
                                                        .filterCheckboxUncheckedColor,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: isSelected
                                            ? Center(
                                                child: Icon(
                                                  Icons.check,
                                                  color: widget
                                                          .colors
                                                          ?.filterColors
                                                          ?.categoryFilterColors
                                                          ?.checkIconColor ??
                                                      widget.defaultColors
                                                          .checkIconColor,
                                                  size: 16,
                                                ),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          category.isEmpty
                                              ? 'Others'
                                              : category,
                                          overflow: TextOverflow.ellipsis,
                                          style: widget
                                                  .styles
                                                  ?.filterStyles
                                                  ?.categoryFilterStyles
                                                  ?.dropdownTextStyle
                                                  ?.copyWith(
                                                color: widget
                                                        .colors
                                                        ?.filterColors
                                                        ?.categoryFilterColors
                                                        ?.filterActionTextColor ??
                                                    widget.defaultColors
                                                        .filterActionTextColor,
                                              ) ??
                                              TextStyle(
                                                fontSize: 14,
                                                color: widget
                                                        .colors
                                                        ?.filterColors
                                                        ?.categoryFilterColors
                                                        ?.filterActionTextColor ??
                                                    widget.defaultColors
                                                        .filterActionTextColor,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.colors?.filterColors?.categoryFilterColors
                          ?.filterIconBorderColor ??
                      widget.defaultColors.filterIconBorderColor,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: widget.filterIconWidget ??
                  Icon(
                    Icons.filter_alt_outlined,
                    color: widget.colors?.filterColors?.categoryFilterColors
                            ?.filterIconColor ??
                        widget.defaultColors.filterIconColor,
                    size: 24,
                  ),
            ),
          ),
          if (widget.selectedValues.isNotEmpty && !widget.hideBadge)
            Positioned(
              right: -11,
              top: -4,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: widget.colors?.filterColors?.categoryFilterColors
                          ?.filterBadgeColor ??
                      widget.defaultColors.filterBadgeColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${widget.selectedValues.length > 99 ? '99+' : widget.selectedValues.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
