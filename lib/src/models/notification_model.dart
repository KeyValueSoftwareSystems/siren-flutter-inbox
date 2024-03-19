import 'package:flutter/material.dart';

class NotificationDataType {
  NotificationDataType({
    required this.id,
    required this.createdAt,
    required this.message,
    required this.requestId,
    required this.isRead,
    required this.cardColor,
  });

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

  final String? id;
  final String? createdAt;
  final MessageData? message;
  final String? requestId;
  bool? isRead;
  Color? cardColor;

  void markAsRead() {
    isRead = true;
    cardColor = Colors.transparent;
  }
}

class MessageData {
  MessageData({
    required this.channel,
    required this.header,
    required this.body,
    required this.actionUrl,
    required this.avatar,
    required this.additionalData,
    this.subHeader,
  });

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

  final String? channel;
  final String? header;
  final String? subHeader;
  final String? body;
  final String? actionUrl;
  final AvatarData? avatar;
  final String? additionalData;
}

class AvatarData {
  AvatarData({
    required this.url,
    required this.altText,
  });

  factory AvatarData.fromJson(Map<String, dynamic>? json) {
    return AvatarData(
      url: json?['imageUrl'] as String?,
      altText: json?['altText'] as String?,
    );
  }

  final String? url;
  final String? altText;
}
