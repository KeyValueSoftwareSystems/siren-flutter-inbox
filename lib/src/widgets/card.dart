import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/src/constants/strings.dart';
import 'package:sirenapp_flutter_inbox/src/models/notification_model.dart';
import 'package:sirenapp_flutter_inbox/src/models/ui_models.dart';
import 'package:sirenapp_flutter_inbox/src/theme/app_colors.dart';
import 'package:sirenapp_flutter_inbox/src/theme/app_theme.dart';
import 'package:sirenapp_flutter_inbox/src/utils/common_utils.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/common/nullable_text.dart';

class CardWidget extends StatefulWidget {
  /// Widget for displaying a notification card.
  const CardWidget({
    required this.onTap,
    required this.notification,
    required this.cardParams,
    required this.styles,
    required this.onDelete,
    this.colors,
    this.isDarkMode,
    super.key,
  });

  /// Callback function invoked when the card is tapped.
  final Function onTap;

  /// Notification data to be displayed.
  final NotificationType notification;

  /// Properties for customizing the card.
  final CardParams cardParams;

  /// Styles to be applied to various elements of the card.
  final CustomStyles? styles;

  /// Callback function invoked when the card is deleted.
  final void Function(String) onDelete;

  /// Colors to be applied to various elements of the card.
  final CustomThemeColors? colors;

  /// Flag to check id dark mode colors are to be applied
  final bool? isDarkMode;

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultColors =
        SirenAppTheme.colors(isDarkMode: widget.isDarkMode ?? false);

    return GestureDetector(
      key: Key('siren-notification-card-${widget.notification.id}'),
      onTap: () {
        widget.onTap(widget.notification);
      },
      child: Container(
        decoration: widget.styles?.cardStyle?.cardContainer?.decoration ??
            _getDefaultContainerDecoration(widget.colors, defaultColors),
        padding: widget.styles?.cardStyle?.cardContainer?.padding ??
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!(widget.cardParams.hideAvatar ?? false))
              _buildDefaultAvatarContainer(widget.colors, defaultColors),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderText(widget.colors, defaultColors),
                    _buildSubHeaderText(widget.colors, defaultColors),
                    _buildBodyText(widget.colors, defaultColors),
                    _buildFooterRow(
                      widget.colors,
                      defaultColors,
                      widget.styles?.dateIconSize ?? 14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BorderSide _getDefaultBorderDecoration(
    CustomThemeColors? colors,
    AppColors defaultColors,
  ) {
    return BorderSide(
      color: colors?.cardColors?.borderColor ?? defaultColors.cardBorderColor,
      width: 0.5,
    );
  }

  BoxDecoration _getDefaultContainerDecoration(
    CustomThemeColors? colors,
    AppColors defaultColors,
  ) {
    return BoxDecoration(
      border: Border(
        left: BorderSide(
          color: widget.notification.isRead
              ? Colors.transparent
              : defaultColors.cardBorderUnread,
          width: 4,
        ),
        right: _getDefaultBorderDecoration(colors, defaultColors),
        bottom: _getDefaultBorderDecoration(colors, defaultColors),
      ),
      color: widget.notification.cardColor ??
          (widget.notification.isRead
              ? colors?.cardColors?.background ?? Colors.transparent
              : defaultColors.cardBackgroundUnread),
    );
  }

  Widget _buildDefaultAvatarContainer(
    CustomThemeColors? colors,
    AppColors defaultColors,
  ) {
    final avatarUrl = widget.notification.message.avatar?.url;
    return GestureDetector(
      key: Key('siren-notification-avatar-${widget.notification.id}'),
      onTap: () {
        widget.cardParams.onAvatarClick?.call(widget.notification);
      },
      child: Padding(
        padding: const EdgeInsets.only(
          right: 6,
          left: 6,
        ),
        child: CircleAvatar(
          radius: widget.styles?.cardStyle?.avatarSize ?? 21,
          backgroundImage: avatarUrl != null &&
                  avatarUrl.isNotEmpty &&
                  avatarUrl != Strings.string_null
              ? NetworkImage(avatarUrl)
              : null,
          backgroundColor: defaultColors.avatarBackground,
          child: avatarUrl == null ||
                  avatarUrl.isEmpty ||
                  avatarUrl == Strings.string_null
              ? Icon(
                  Icons.landscape_rounded,
                  color: defaultColors.avatarIconColor,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildHeaderText(CustomThemeColors? colors, AppColors defaultColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.notification.message.header ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: widget.styles?.cardStyle?.cardTitle ??
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors?.cardColors?.titleColor ??
                      colors?.textColor ??
                      defaultColors.textColor,
                ),
          ),
        ),
        if (!(widget.cardParams.hideDelete ?? false)) ...[
          const SizedBox(width: 8),
          GestureDetector(
            key: Key(
              'siren-notification-delete-${widget.notification.id}',
            ),
            onTap: () => widget.onDelete(widget.notification.id),
            child: widget.cardParams.deleteIcon ??
                _buildDefaultDeleteButton(
                  colors,
                  defaultColors,
                  widget.styles?.deleteIconSize ?? 18,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildSubHeaderText(
    CustomThemeColors? colors,
    AppColors defaultColors,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: NullableText(
        text: widget.notification.message.subHeader,
        style: widget.styles?.cardStyle?.cardSubtitle ??
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colors?.cardColors?.subtitleColor ??
                  colors?.textColor ??
                  defaultColors.textColor,
            ),
      ),
    );
  }

  Widget _buildBodyText(CustomThemeColors? colors, AppColors defaultColors) {
    return Text(
      widget.notification.message.body ?? '',
      style: widget.styles?.cardStyle?.cardDescription ??
          TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: colors?.cardColors?.descriptionColor ??
                colors?.textColor ??
                defaultColors.textColor,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooterRow(
    CustomThemeColors? colors,
    AppColors defaultColors,
    double size,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Container(
        child: _buildTimestampText(colors, defaultColors, size),
      ),
    );
  }

  Widget _buildTimestampText(
    CustomThemeColors? colors,
    AppColors defaultColors,
    double size,
  ) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            Icons.access_time_sharp,
            color: colors?.timerIcon ?? defaultColors.timerIcon,
            size: size,
          ),
        ),
        Text(
          generateElapsedTimeText(
            DateTime.parse(widget.notification.createdAt),
          ),
          style: widget.styles?.cardStyle?.dateStyle ??
              TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: colors?.dateColor ?? defaultColors.dateColor,
              ),
        ),
      ],
    );
  }

  Widget _buildDefaultDeleteButton(
    CustomThemeColors? colors,
    AppColors defaultColors,
    double size,
  ) {
    return Icon(
      Icons.close,
      color: colors?.deleteIcon ?? defaultColors.deleteIcon,
      size: size,
    );
  }
}
