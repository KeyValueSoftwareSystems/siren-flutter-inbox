import 'package:flutter/material.dart';

class CardProps {
  CardProps({
    this.hideAvatar,
    this.showMedia,
  });
  final bool? hideAvatar;
  final bool? showMedia;
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
}
