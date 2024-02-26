import 'package:flutter/material.dart';

class NotificationDataType {
  final String id;
  final String createdAt;
  final MessageData message;
  final String requestId;
  final bool isRead;

  NotificationDataType({
    required this.id,
    required this.createdAt,
    required this.message,
    required this.requestId,
    required this.isRead,
  });
}

class AvatarData {
  final String? imageUrl;
  final String? actionUrl;

  AvatarData({
    this.imageUrl,
    this.actionUrl,
  });
}

class CardProps {
  final bool? hideAvatar;
  final bool? showMedia;

  CardProps({
    this.hideAvatar,
    this.showMedia,
  });
}

class MessageData {
  final String channel;
  final String header;
  final String? subHeader;
  final String body;
  final String actionUrl;
  final AvatarData avatar;
  final String additionalData;

  MessageData({
    required this.channel,
    required this.header,
    this.subHeader,
    required this.body,
    required this.actionUrl,
    required this.avatar,
    required this.additionalData,
  });
}

class SirenStyleProps {
  final BoxDecoration? container;
  final BoxDecoration? contentContainer;
  final BoxDecoration? headerContainer;
  final TextStyle? headerTitle;
  final TextStyle? subHeaderText;
  final BoxDecoration? cardContainer;
  final BoxDecoration? cardIconContainer;
  final BoxDecoration? cardIconRound;
  final BoxDecoration? cardAvatarStyle;
  final BoxDecoration? cardContentContainer;
  final TextStyle? cardTitle;
  final TextStyle? cardDescription;
  final BoxDecoration? cardImageStyle;
  final BoxDecoration? cardFooterRow;
  final TextStyle? dateStyle;
  final BoxDecoration? deleteButton;
  final TextStyle? deleteButtonText;

  SirenStyleProps({
    this.container,
    this.contentContainer,
    this.headerContainer,
    this.headerTitle,
    this.subHeaderText,
    this.cardContainer,
    this.cardIconContainer,
    this.cardIconRound,
    this.cardAvatarStyle,
    this.cardContentContainer,
    this.cardTitle,
    this.cardDescription,
    this.cardImageStyle,
    this.cardFooterRow,
    this.dateStyle,
    this.deleteButton,
    this.deleteButtonText,
  });
}
