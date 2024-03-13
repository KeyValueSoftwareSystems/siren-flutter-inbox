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
  NotificationIcon({this.size});
  final double? size;
}

class BadgeStyle {
  BadgeStyle({
    this.fontSize,
    this.inset,
    this.size,
    this.top,
    this.right,
  });
  final double? fontSize;
  final double? inset;
  final double? size;
  final double? top;
  final double? right;
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
  final NotificationIcon? iconStyle;
  final BadgeStyle? badgeStyle;
}

class CustomThemeColors {
  CustomThemeColors({
    this.backgroundColor,
    this.activeCardBorderColor,
    this.activeCardColor,
    this.cardBorder,
    this.deleteIconColor,
    this.clearAllIconColor,
    this.textColor,
    this.inverseBackground,
    this.badgeBackgroundColor,
    this.badgeColor,
  });

  final Color? backgroundColor;
  final Color? activeCardBorderColor;
  final Color? activeCardColor;
  final Color? cardBorder;
  final Color? deleteIconColor;
  final Color? clearAllIconColor;
  final Color? textColor;
  final Color? inverseBackground;
  final Color? badgeBackgroundColor;
  final Color? badgeColor;
}
