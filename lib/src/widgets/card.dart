import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/src/models/notification_model.dart';
import 'package:sirenapp_flutter_inbox/src/models/ui_models.dart';
import 'package:sirenapp_flutter_inbox/src/utils/common_utils.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/common/nullable_text.dart';

class CardWidget extends StatefulWidget {
  /// Widget for displaying a notification card.
  const CardWidget({
    required this.onTap,
    required this.notification,
    required this.cardProps,
    required this.styles,
    required this.onDelete,
    super.key,
  });

  /// Callback function invoked when the card is tapped.
  final Function onTap;

  /// Notification data to be displayed.
  final NotificationDataType notification;

  /// Properties for customizing the card.
  final CardProps cardProps;

  /// Styles to be applied to various elements of the card.
  final CustomStyles? styles;

  /// Callback function invoked when the card is deleted.
  final void Function(String) onDelete;

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
    final currentTheme = Theme.of(context);

    return GestureDetector(
      key: Key('siren-notification-card-${widget.notification.id}'),
      onTap: () {
        widget.onTap(widget.notification);
      },
      child: Container(
        decoration: widget.styles?.cardStyle?.cardContainer?.decoration ??
            _getDefaultContainerDecoration(currentTheme),
        padding: widget.styles?.cardStyle?.cardContainer?.padding ??
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!(widget.cardProps.hideAvatar ?? false))
              _buildDefaultAvatarContainer(currentTheme),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderText(currentTheme),
                    _buildSubHeaderText(currentTheme),
                    _buildBodyText(currentTheme),
                    _buildFooterRow(
                      currentTheme,
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

  BorderSide _getDefaultBorderDecoration(ThemeData theme) {
    return BorderSide(
      color: theme.cardTheme.shadowColor ?? theme.colorScheme.surfaceTint,
      width: 0.5,
    );
  }

  BoxDecoration _getDefaultContainerDecoration(ThemeData theme) {
    return BoxDecoration(
      border: Border(
        left: BorderSide(
          color: widget.notification.isRead
              ? Colors.transparent
              : theme.colorScheme.secondary,
          width: 4,
        ),
        right: _getDefaultBorderDecoration(theme),
        bottom: _getDefaultBorderDecoration(theme),
      ),
      color: widget.notification.cardColor ??
          (widget.notification.isRead
              ? theme.cardTheme.color ?? Colors.transparent
              : theme.colorScheme.secondaryContainer),
    );
  }

  Widget _buildDefaultAvatarContainer(ThemeData theme) {
    final avatarUrl = widget.notification.message.avatar?.url;
    return GestureDetector(
      key: Key('siren-notification-avatar-${widget.notification.id}'),
      onTap: () {
        widget.cardProps.onAvatarClick?.call(widget.notification);
      },
      child: Padding(
        padding: const EdgeInsets.only(
          right: 6,
          left: 6,
        ),
        child: CircleAvatar(
          radius: widget.styles?.cardStyle?.avatarSize ?? 21,
          backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
              ? NetworkImage(avatarUrl)
              : null,
          backgroundColor: theme.colorScheme.onSecondary,
          child: avatarUrl == null || avatarUrl.isEmpty
              ? Icon(
                  Icons.landscape_rounded,
                  color: theme.colorScheme.surfaceVariant,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildHeaderText(ThemeData theme) {
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
                  color: theme.cardTheme.surfaceTintColor ??
                      theme.colorScheme.tertiary,
                ),
          ),
        ),
        if (!(widget.cardProps.hideDelete ?? false)) ...[
          const SizedBox(width: 8),
          GestureDetector(
            key: Key(
              'siren-notification-delete-${widget.notification.id}',
            ),
            onTap: () => widget.onDelete(widget.notification.id),
            child: widget.cardProps.deleteIcon ??
                _buildDefaultDeleteButton(
                  theme,
                  widget.styles?.deleteIconSize ?? 18,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildSubHeaderText(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: NullableText(
        text: widget.notification.message.subHeader,
        style: widget.styles?.cardStyle?.cardSubtitle ??
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: theme.bannerTheme.backgroundColor ??
                  theme.colorScheme.tertiary,
            ),
      ),
    );
  }

  Widget _buildBodyText(ThemeData theme) {
    return Text(
      widget.notification.message.body ?? '',
      style: widget.styles?.cardStyle?.cardDescription ??
          TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: theme.bannerTheme.surfaceTintColor ??
                theme.colorScheme.tertiary,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooterRow(ThemeData theme, double size) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Container(
        child: _buildTimestampText(theme, size),
      ),
    );
  }

  Widget _buildTimestampText(ThemeData theme, double size) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            Icons.access_time_sharp,
            color: theme.colorScheme.scrim,
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
                color: theme.colorScheme.inversePrimary,
              ),
        ),
      ],
    );
  }

  Widget _buildDefaultDeleteButton(ThemeData theme, double size) {
    return Icon(
      Icons.close,
      color: theme.colorScheme.outlineVariant,
      size: size,
    );
  }
}
