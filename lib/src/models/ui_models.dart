import 'package:flutter/material.dart';

class CardProps {
  CardProps({
    this.hideAvatar,
    this.showMedia,
  });
  final bool? hideAvatar;
  final bool? showMedia;
}

class NotificationIcon {
  NotificationIcon({this.size = 40});
  final double? size;
}

class BadgeStyle {
  BadgeStyle({
    this.background = Colors.red,
    this.color = Colors.white,
    this.fontSize = 8,
    this.inset = 1,
    this.size = 15,
  });
  final Color? background;
  final Color? color;
  final double? fontSize;
  final double? inset;
  final double? size;
}

class SirenStyleProps {
  SirenStyleProps({
    this.container,
    this.contentContainer,
    this.headerContainer,
    this.headerTitle,
    this.subHeaderText,
    this.cardAvatarContainer,
    this.cardContentContainer,
    this.cardTitle,
    this.cardDescription,
    this.cardImageStyle,
    this.cardFooterRow,
    this.dateStyle,
    this.deleteButton,
    this.deleteButtonText,
    this.cardUnreadColor,
    this.iconStyle,
    this.badgeStyle,
  });
  final BoxDecoration? container;
  final BoxDecoration? contentContainer;
  final BoxDecoration? headerContainer;
  final TextStyle? headerTitle;
  final TextStyle? subHeaderText;
  final BoxDecoration? cardAvatarContainer;
  final BoxDecoration? cardContentContainer;
  final TextStyle? cardTitle;
  final TextStyle? cardDescription;
  final BoxDecoration? cardImageStyle;
  final BoxDecoration? cardFooterRow;
  final TextStyle? dateStyle;
  final BoxDecoration? deleteButton;
  final TextStyle? deleteButtonText;
  final Color? cardUnreadColor;
  final NotificationIcon? iconStyle;
  final BadgeStyle? badgeStyle;
}
