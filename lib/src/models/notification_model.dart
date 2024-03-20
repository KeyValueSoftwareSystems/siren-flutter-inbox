import 'package:flutter/material.dart';

/// Class representing the data structure of a notification.
class NotificationDataType {
  /// Constructs a [NotificationDataType] instance.
  NotificationDataType({
    required this.id,
    required this.createdAt,
    required this.message,
    required this.requestId,
    required this.isRead,
    required this.cardColor,
  });

  /// Factory method to create NotificationDataType from JSON.
  factory NotificationDataType.fromJson(Map<String, dynamic>? json) {
    return NotificationDataType(
      id: json?['id'] as String?,
      createdAt: json?['createdAt'] as String?,
      message: json?['message'] != null
          ? MessageData.fromJson(json?['message'] as Map<String, dynamic>)
          : null,
      requestId: json?['requestId'] as String?,
      isRead: json?['isRead'] as bool?,
      cardColor: json?['cardColor'] as Color?,
    );
  }

  /// The unique identifier of the notification.
  final String? id;

  /// The creation timestamp of the notification.
  final String? createdAt;

  /// The message associated with the notification.
  final MessageData? message;

  /// The request identifier associated with the notification.
  final String? requestId;

  /// Indicates whether the notification has been read.
  bool? isRead;

  /// The color of the notification card.
  Color? cardColor;

  /// Method to mark the notification as read.
  void markAsRead() {
    isRead = true;
    cardColor = Colors.transparent;
  }
}

/// Class representing the data structure of a message.
class MessageData {
  /// Constructs a [MessageData] instance.
  MessageData({
    required this.channel,
    required this.header,
    required this.body,
    required this.actionUrl,
    required this.avatar,
    required this.additionalData,
    this.subHeader,
  });

  /// Factory method to create MessageData from JSON.
  factory MessageData.fromJson(Map<String, dynamic>? json) {
    return MessageData(
      channel: json?['channel'] as String?,
      header: json?['header'] as String?,
      subHeader: json?['subHeader'] as String?,
      body: json?['body'] as String?,
      actionUrl: json?['actionUrl'] as String?,
      avatar: json?['avatar'] != null
          ? AvatarData.fromJson(json?['avatar'] as Map<String, dynamic>)
          : null,
      additionalData: json?['additionalData'] as String?,
    );
  }

  /// The channel of the message.
  final String? channel;

  /// The header of the message.
  final String? header;

  /// The sub-header of the message.
  final String? subHeader;

  /// The body of the message.
  final String? body;

  /// The action URL associated with the message.
  final String? actionUrl;

  /// The avatar data associated with the message.
  final AvatarData? avatar;

  /// Additional data related to the message.
  final String? additionalData;
}

/// Class representing the data structure of an avatar.
class AvatarData {
  AvatarData({
    required this.url,
    required this.altText,
  });

  /// Factory method to create AvatarData from JSON.
  factory AvatarData.fromJson(Map<String, dynamic>? json) {
    return AvatarData(
      url: json?['imageUrl'] as String?,
      altText: json?['altText'] as String?,
    );
  }

  final String? url;
  final String? altText;
}
