import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/src/models/notification_model.dart';

void main() {
  group('NotificationType', () {
    test('fromJson() should parse JSON correctly', () {
      final json = {
        'id': 'notificationId',
        'createdAt': '2022-01-01T00:00:00Z',
        'message': {
          'channel': 'channel',
          'header': 'header',
          'subHeader': 'subHeader',
          'body': 'body',
          'actionUrl': 'actionUrl',
          'avatar': {'imageUrl': 'avatarUrl', 'altText': 'altText'},
          'additionalData': 'additionalData',
        },
        'requestId': 'requestId',
        'isRead': true,
        'cardColor': Colors.blue,
      };
      final notification = NotificationType.fromJson(json);

      expect(notification.id, 'notificationId');
      expect(notification.createdAt, '2022-01-01T00:00:00Z');
      expect(notification.requestId, 'requestId');
      expect(notification.isRead, true);
      expect(notification.cardColor, Colors.blue);
      expect(notification.message.channel, 'channel');
      expect(notification.message.header, 'header');
      expect(notification.message.subHeader, 'subHeader');
      expect(notification.message.body, 'body');
      expect(notification.message.actionUrl, 'actionUrl');
      expect(notification.message.avatar?.url, 'avatarUrl');
      expect(notification.message.avatar?.altText, 'altText');
      expect(notification.message.additionalData, 'additionalData');
    });

    test('markAsRead() should mark the notification as read', () {
      final notification = NotificationType(
        id: 'notificationId',
        createdAt: '2022-01-01T00:00:00Z',
        message: MessageData(
          channel: 'channel',
          header: 'header',
          subHeader: 'subHeader',
          body: 'body',
          actionUrl: 'actionUrl',
          avatar: AvatarData(url: 'avatarUrl', altText: 'altText'),
          additionalData: 'additionalData',
        ),
        requestId: 'requestId',
        isRead: false,
        cardColor: Colors.blue,
      );

      expect(notification.isRead, false);
      expect(notification.cardColor, Colors.blue);

      notification.markAsRead();

      expect(notification.isRead, true);
      expect(notification.cardColor, Colors.transparent);
    });
  });

  group('MessageData', () {
    test('fromJson() should parse JSON correctly', () {
      final json = {
        'channel': 'channel',
        'header': 'header',
        'subHeader': 'subHeader',
        'body': 'body',
        'actionUrl': 'actionUrl',
        'avatar': {'imageUrl': 'avatarUrl', 'altText': 'altText'},
        'additionalData': 'additionalData',
      };
      final message = MessageData.fromJson(json);

      expect(message.channel, 'channel');
      expect(message.header, 'header');
      expect(message.subHeader, 'subHeader');
      expect(message.body, 'body');
      expect(message.actionUrl, 'actionUrl');
      expect(message.avatar?.url, 'avatarUrl');
      expect(message.avatar?.altText, 'altText');
      expect(message.additionalData, 'additionalData');
    });
  });

  group('AvatarData', () {
    test('fromJson() should parse JSON correctly', () {
      final json = {'imageUrl': 'avatarUrl', 'altText': 'altText'};
      final avatar = AvatarData.fromJson(json);

      expect(avatar.url, 'avatarUrl');
      expect(avatar.altText, 'altText');
    });
  });
}
