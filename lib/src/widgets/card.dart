import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/models/ui_models.dart';
import 'package:siren_flutter_inbox/src/utils/common_utils.dart';
import 'package:siren_flutter_inbox/src/widgets/common/nullable_text.dart';

// Define a CardWidget class to display notification cards
class CardWidget extends StatelessWidget {
  // Define required parameters for the card
  final Function onCardClick;
  final NotificationDataType notification;
  final CardProps cardProps;
  final SirenStyleProps? styles;
  final Function onDelete;
  final Widget? deleteWidget;
  final Widget? avatarWidget;

  // Constructor to initialize the card with required parameters
  CardWidget({
    required this.onCardClick,
    required this.notification,
    required this.cardProps,
    required this.styles,
    required this.onDelete,
    this.deleteWidget,
    this.avatarWidget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCardClick(notification),
      child: Container(
        decoration: styles?.container ?? _getDefaultContainerDecoration(),
        child: Container(
          decoration: styles?.contentContainer,
          child: Row(
            children: [
              // Display avatar if not hidden
              if (!(cardProps.hideAvatar ?? false))
                avatarWidget ?? _buildDefaultAvatarContainer(),
              Expanded(
                child: Container(
                  decoration: styles?.cardContentContainer,
                  padding: const EdgeInsets.all(8),
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
    );
  }

  // Private method to get default container decoration
  BoxDecoration _getDefaultContainerDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: notification.isRead ? Colors.transparent : Colors.black,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  // Private method to build default avatar container
  Container _buildDefaultAvatarContainer() {
    return Container(
      decoration: styles?.cardIconContainer,
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundImage: notification.message.avatar.imageUrl != null
            ? NetworkImage(notification.message.avatar.imageUrl ?? '')
            : null,
      ),
    );
  }

  // Private method to build header text widget
  Text _buildHeaderText() {
    return Text(
      notification.message.header,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: styles?.cardTitle ??
          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  // Private method to build subheader text widget
  Widget _buildSubHeaderText() {
    return NullableText(
      text: notification.message.subHeader,
      style: styles?.subHeaderText ??
          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    );
  }

  // Private method to build body text widget
  Text _buildBodyText() {
    return Text(
      notification.message.body,
      style: styles?.cardDescription ??
          TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
    );
  }

  // Private method to build footer row containing timestamp and delete button
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

  // Private method to build timestamp text widget
  Text _buildTimestampText() {
    return Text(
      generateElapsedTimeText(DateTime.parse(notification.createdAt)),
      style: styles?.dateStyle,
    );
  }

  // Private method to build default delete button container
  Container _buildDefaultDeleteButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: styles?.deleteButton ??
          BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Text(
        'Delete',
        style: styles?.deleteButtonText ?? const TextStyle(color: Colors.red),
      ),
    );
  }
}
