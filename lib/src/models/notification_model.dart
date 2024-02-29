// models.dart

class NotificationDataType {
  NotificationDataType({
    required this.id,
    required this.createdAt,
    required this.message,
    required this.requestId,
    required this.isRead,
  });

  factory NotificationDataType.fromJson(Map<String, dynamic>? json) {
    return NotificationDataType(
      id: json?['id'] as String?,
      createdAt: json?['createdAt'] as String?,
      message: MessageData.fromJson(json?['message'] as Map<String, dynamic>?),
      requestId: json?['requestId'] as String?,
      isRead: json?['isRead'] as bool?,
    );
  }

  final String? id;
  final String? createdAt;
  final MessageData? message;
  final String? requestId;
  final bool? isRead;
}

class MessageData {
  MessageData({
    required this.channel,
    required this.header,
    this.subHeader,
    required this.body,
    required this.actionUrl,
    required this.avatar,
    required this.additionalData,
  });

  factory MessageData.fromJson(Map<String, dynamic>? json) {
    return MessageData(
      channel: json?['channel'] as String?,
      header: json?['header'] as String?,
      subHeader: json?['subHeader'] as String?,
      body: json?['body'] as String?,
      actionUrl: json?['actionUrl'] as String?,
      avatar: AvatarData.fromJson(json?['avatar'] as Map<String, dynamic>?),
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
      url: json?['url'] as String?,
      altText: json?['altText'] as String?,
    );
  }

  final String? url;
  final String? altText;
}
