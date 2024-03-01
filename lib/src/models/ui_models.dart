import 'package:flutter/material.dart';

class CardProps {
  final bool? hideAvatar;
  final bool? showMedia;

  CardProps({
    this.hideAvatar,
    this.showMedia,
  });
}

class SirenStyleProps {
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
}
