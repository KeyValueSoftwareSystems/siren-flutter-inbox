import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/models/notification_model.dart';
import 'package:siren_flutter_inbox/src/models/ui_models.dart';
import 'package:siren_flutter_inbox/src/theme/colors.dart';
import 'package:siren_flutter_inbox/src/utils/common_utils.dart';
import 'package:siren_flutter_inbox/src/widgets/common/nullable_text.dart';

class CardWidget extends StatefulWidget {
  /// Widget for displaying a notification card.
  const CardWidget({
    required this.onTap,
    required this.notification,
    required this.cardProps,
    required this.styles,
    required this.onDelete,
    super.key,
    this.deleteWidget,
  });

  /// Callback function invoked when the card is tapped.
  final Function onTap;

  /// Notification data to be displayed.
  final NotificationDataType notification;

  /// Properties for customizing the card.
  final CardProps cardProps;

  /// Styles to be applied to various elements of the card.
  final SirenStyleProps? styles;

  /// Callback function invoked when the card is deleted.
  final void Function(String) onDelete;

  /// Widget to be displayed for deletion, if provided.
  final Widget? deleteWidget;

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
      onTap: () {
        widget.onTap(widget.notification);
      },
      child: Container(
        decoration: widget.styles?.container ??
            _getDefaultContainerDecoration(currentTheme),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: widget.styles?.contentContainer,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!(widget.cardProps.hideAvatar ?? false))
                    _buildDefaultAvatarContainer(currentTheme),
                  Expanded(
                    child: Container(
                      decoration: widget.styles?.cardContentContainer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeaderText(currentTheme),
                            _buildSubHeaderText(currentTheme),
                            _buildBodyText(currentTheme),
                            _buildFooterRow(currentTheme),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.onDelete(widget.notification.id ?? ''),
                    child: widget.deleteWidget ??
                        _buildDefaultDeleteButton(currentTheme),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BorderSide _getDefaultBorderDecoration(ThemeData theme) {
    return BorderSide(
      color: theme.colorScheme.surfaceTint,
      width: 0.5,
    );
  }

  BoxDecoration _getDefaultContainerDecoration(ThemeData theme) {
    return BoxDecoration(
      border: Border(
        left: BorderSide(
          color: widget.notification.isRead ?? true
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary,
          width: 4,
        ),
        right: _getDefaultBorderDecoration(theme),
        bottom: _getDefaultBorderDecoration(theme),
      ),
      color: widget.notification.cardColor ??
          (widget.notification.isRead ?? true
              ? null
              : theme.colorScheme.secondaryContainer),
    );
  }

  Widget _buildDefaultAvatarContainer(ThemeData theme) {
    final avatarUrl = widget.notification.message?.avatar?.url;
    return Container(
      decoration: widget.styles?.cardAvatarContainer,
      child: CircleAvatar(
        radius: 21,
        backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
            ? NetworkImage(avatarUrl)
            : null,
        backgroundColor: AppColors.avatarPlaceholderBg,
        child: avatarUrl == null || avatarUrl.isEmpty
            ? const Icon(
                Icons.landscape_rounded,
                color: AppColors.avatarIcon,
              )
            : null,
      ),
    );
  }

  Widget _buildHeaderText(ThemeData theme) {
    return Text(
      widget.notification.message?.header ?? '',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: widget.styles?.cardTitle ??
          TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.tertiary,
          ),
    );
  }

  Widget _buildSubHeaderText(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: NullableText(
        text: widget.notification.message?.subHeader,
        style: widget.styles?.subHeaderText ??
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.tertiary,
            ),
      ),
    );
  }

  Widget _buildBodyText(ThemeData theme) {
    return Text(
      widget.notification.message?.body ?? '',
      style: widget.styles?.cardDescription ??
          TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.tertiary,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooterRow(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Container(
        decoration: widget.styles?.cardFooterRow,
        child: _buildTimestampText(theme),
      ),
    );
  }

  Widget _buildTimestampText(ThemeData theme) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            Icons.access_time_sharp,
            color: theme.colorScheme.scrim,
            size: 14,
          ),
        ),
        Text(
          generateElapsedTimeText(
            DateTime.parse(widget.notification.createdAt ?? ''),
          ),
          style: widget.styles?.dateStyle ??
              TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.inversePrimary,
              ),
        ),
      ],
    );
  }

  Widget _buildDefaultDeleteButton(ThemeData theme) {
    return Icon(
      Icons.close,
      color: theme.colorScheme.outlineVariant,
      size: 18,
    );
  }
}
