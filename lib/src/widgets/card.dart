import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/models/notification_model.dart';
import 'package:siren_flutter_inbox/src/models/ui_models.dart';
import 'package:siren_flutter_inbox/src/utils/common_utils.dart';
import 'package:siren_flutter_inbox/src/widgets/common/nullable_text.dart';

class CardWidget extends StatelessWidget {
  final Function onCardClick;
  final NotificationDataType notification;
  final CardProps cardProps;
  final SirenStyleProps? styles;
  final Function onDelete;
  final Widget? deleteWidget;

  CardWidget({
    required this.onCardClick,
    required this.notification,
    required this.cardProps,
    required this.styles,
    required this.onDelete,
    this.deleteWidget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCardClick(notification),
      child: Container(
        decoration: styles?.container ?? _getDefaultContainerDecoration(),
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            decoration: styles?.contentContainer,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!(cardProps.hideAvatar ?? false))
                  _buildDefaultAvatarContainer(),
                Expanded(
                  child: Container(
                    decoration: styles?.cardContentContainer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderText(),
                        _buildSubHeaderText(),
                        _buildBodyText(),
                        _buildFooterRow(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDefaultContainerDecoration() {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.blueGrey.withOpacity(0.2),
        ),
      ),
      color: notification.isRead ?? true ? const Color(0xFFFFDADA) : null,
    );
  }

  Container _buildDefaultAvatarContainer() {
    return Container(
      decoration: styles?.cardIconContainer,
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundImage: notification.message?.avatar?.url != null
            ? NetworkImage(
                notification.message!.avatar?.url ?? '',
              )
            : const NetworkImage(
                Generics.PLACEHOLDER_IMAGE_URL,
              ),
      ),
    );
  }

  Text _buildHeaderText() {
    return Text(
      (notification.message?.header ?? '').toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: styles?.cardTitle ??
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildSubHeaderText() {
    return NullableText(
      text: notification.message?.subHeader,
      style: styles?.subHeaderText ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
    );
  }

  Widget _buildBodyText() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          notification.message?.body ?? '',
          style: styles?.cardDescription ??
              const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Container _buildFooterRow() {
    return Container(
      decoration: styles?.cardFooterRow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimestampText(),
          GestureDetector(
            onTap: () => onDelete(notification.id),
            child: deleteWidget ?? _buildDefaultDeleteButton(),
          ),
        ],
      ),
    );
  }

  Text _buildTimestampText() {
    return Text(
      generateElapsedTimeText(DateTime.parse(notification.createdAt ?? '')),
      style: styles?.dateStyle ?? const TextStyle(fontSize: 12),
    );
  }

  IconButton _buildDefaultDeleteButton() {
    return IconButton(
      iconSize: 25,
      onPressed: () {},
      icon: const Icon(
        Icons.delete_outline,
        color: Colors.red,
      ),
    );
  }
}
