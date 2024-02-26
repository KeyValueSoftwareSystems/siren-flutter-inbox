library siren_flutter_inbox;

import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/models/ui_models.dart';
import 'package:siren_flutter_inbox/src/widgets/card.dart';

///Dummy Notification
final notification = NotificationDataType(
  id: '1',
  createdAt: '2024-01-01T00:00:00Z',
  message: MessageData(
    channel: '',
    header: 'Title of the notification',
    subHeader: 'Subheader of the notification',
    body: 'You have a new message. This is the body',
    actionUrl: '',
    avatar: AvatarData(
      imageUrl: 'https://picsum.photos/200',
      actionUrl: null,
    ),
    additionalData: '',
  ),
  requestId: '',
  isRead: false,
);

class CustomText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          //Dummy Widget
          const Text('THE DEMO TEXT WIDGET'),
          CardWidget(
            onCardClick: (notification) {
              // Handle card click
            },
            notification: NotificationDataType(
              id: notification.id,
              createdAt: notification.createdAt,
              message: MessageData(
                channel: '',
                header: notification.message.header,
                subHeader: notification.message.subHeader,
                body: notification.message.body,
                actionUrl: '',
                avatar: AvatarData(
                  imageUrl: notification.message.avatar.imageUrl,
                  actionUrl: null,
                ),
                additionalData: '',
              ),
              requestId: '',
              isRead: notification.isRead,
            ),
            cardProps: CardProps(
              hideAvatar: false,
              showMedia: true,
            ),
            onDelete: (id) {
              // Handle delete action
            },
            deleteWidget: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
            styles: null,
          ),
        ],
      ),
    );
  }
}
