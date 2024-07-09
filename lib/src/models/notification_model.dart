import 'dart:convert';

import 'package:flutter/material.dart';

/// Class representing the data structure of a notification.
class NotificationType {
  /// Constructs a [NotificationType] instance.
  NotificationType({
    required this.id,
    required this.createdAt,
    required this.message,
    required this.requestId,
    required this.isRead,
    required this.cardColor,
  });

  /// Factory method to create NotificationType from JSON.
  factory NotificationType.fromJson(Map<String, dynamic>? json) {
    return NotificationType(
      id: json?['id'] as String,
      createdAt: json?['createdAt'] as String,
      message: MessageData.fromJson(json?['message'] as Map<String, dynamic>),
      requestId: json?['requestId'] as String?,
      isRead: json?['isRead'] as bool,
      cardColor: json?['cardColor'] as Color?,
    );
  }

  /// The unique identifier of the notification.
  final String id;

  /// The creation timestamp of the notification.
  final String createdAt;

  /// The message associated with the notification.
  final MessageData message;

  /// The request identifier associated with the notification.
  final String? requestId;

  /// Indicates whether the notification has been read.
  bool isRead;

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
    this.thumbnailUrl,
    this.subHeader,
  });

  /// Factory method to create MessageData from data.
  factory MessageData.fromJson(Map<String, dynamic>? data) {
    var dataDecoded;
    Map<String, dynamic>? additionalData;
    if (data?['additionalData'] != null) {
      try {
        dataDecoded = json.decode(data?['additionalData'] as String);
        additionalData = dataDecoded as Map<String, dynamic>?;
      } catch (error) {
        additionalData = null;
      }
    }
    return MessageData(
      channel: data?['channel'] as String?,
      header: data?['header'] as String?,
      subHeader: data?['subHeader'] as String?,
      body: data?['body'] as String?,
      actionUrl: data?['actionUrl'] as String?,
      avatar: data?['avatar'] != null
          ? AvatarData.fromJson(data?['avatar'] as Map<String, dynamic>)
          : null,
      thumbnailUrl: data?['thumbnailUrl'] != null
          ? (data?['thumbnailUrl'] as String?)
          : '',
      additionalData: additionalData,
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
  final Map<String, dynamic>? additionalData;

  /// The thumbnail URL associated with the message to display.
  final String? thumbnailUrl;
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
