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
    this.background,
    this.color,
    this.fontSize,
    this.inset,
    this.size,
    this.top,
    this.right,
  });
  final Color? background;
  final Color? color;
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
    this.subHeaderText,
    this.cardAvatarContainer,
    this.cardContentContainer,
    this.cardTitle,
    this.cardDescription,
    this.cardFooterRow,
    this.dateStyle,
  });
  final BoxDecoration? container;
  final BoxDecoration? contentContainer;
  final BoxDecoration? headerContainer;
  final TextStyle? subHeaderText;
  final BoxDecoration? cardAvatarContainer;
  final BoxDecoration? cardContentContainer;
  final TextStyle? cardTitle;
  final TextStyle? cardDescription;
  final BoxDecoration? cardFooterRow;
  final TextStyle? dateStyle;
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
  });

  final Color? backgroundColor;
  final Color? activeCardBorderColor;
  final Color? activeCardColor;
  final Color? cardBorder;
  final Color? deleteIconColor;
  final Color? clearAllIconColor;
  final Color? textColor;
  final Color? inverseBackground;
}
