import 'package:flutter/material.dart';

/// Properties for configuring the appearance of the notification card.
class CardProps {
  /// Constructs a [CardProps] with optional parameters.
  const CardProps({
    this.hideAvatar,
    this.showMedia,
    this.disableAutoMarkAsRead,
    this.deleteWidget,
    this.hideDelete,
  });

  /// Determines whether to hide the avatar in the notification card in Siren inbox.
  final bool? hideAvatar;

  /// Determines whether to show media content in the notification card in Siren inbox.
  final bool? showMedia;

  /// The flag to turn on and off the mark as read functionality
  final bool? disableAutoMarkAsRead;

  /// Custom widget that can be used instead of default delete in the card (x)
  final Widget? deleteWidget;

  /// Determines whether to hide the avatar in the notification card in Siren inbox.
  final bool? hideDelete;
}

/// Customizable style for the Siren notification icon.
class IconStyle {
  /// Constructs an [IconStyle] with optional parameters.
  const IconStyle({this.size});

  /// Size of the notification icon.
  final double? size;
}

/// Default styles for the Siren notification icon.
class DefaultIconStyle {
  /// Default font size for the badge count.
  static double get defaultFontSize => 10;

  /// Default inset for the badge count.
  static double get defaultInset => 1;

  /// Default size for the badge count.
  static double get defaultSize => 20;

  /// Default top position for the badge count.
  static double get defaultTop => 0;

  /// Default right position for the badge count.
  static double get defaultRight => 2;

  /// Default size for the notification icon.
  static double get iconSize => 35;
}

/// Properties for configuring the appearance of the badge.
class BadgeStyle {
  /// Constructs a [BadgeStyle] with optional parameters.
  const BadgeStyle({
    this.fontSize,
    this.inset,
    this.size,
    this.top,
    this.right,
  });

  /// The font size of the notification icon badge.
  final double? fontSize;

  /// The inset of the notification icon badge.
  final double? inset;

  /// The size of the notification icon badge.
  final double? size;

  /// The top position of the notification icon badge.
  final double? top;

  /// The right position of the notification icon badge.
  final double? right;
}

/// Style properties for customizing the appearance of various UI elements in the Siren theme.
class SirenStyleProps {
  /// Constructs a [SirenStyleProps] with optional parameters.
  const SirenStyleProps({
    this.container,
    this.contentContainer,
    this.subHeaderText,
    this.cardAvatarContainer,
    this.cardContentContainer,
    this.cardTitle,
    this.cardDescription,
    this.cardFooterRow,
    this.dateStyle,
    this.iconStyle,
    this.badgeStyle,
    this.defaultHeaderTextStyle,
  });

  /// The decoration for the outer container of the card in Siren inbox.
  final BoxDecoration? container;

  /// The decoration for the content container of the card in Siren inbox.
  final BoxDecoration? contentContainer;

  /// The text style for the sub-header text in Siren inbox.
  final TextStyle? subHeaderText;

  /// The decoration for the avatar container of the card in Siren inbox.
  final BoxDecoration? cardAvatarContainer;

  /// The decoration for the content container of the card in Siren inbox.
  final BoxDecoration? cardContentContainer;

  /// The text style for the card title in Siren inbox.
  final TextStyle? cardTitle;

  /// The text style for the card description in Siren inbox.
  final TextStyle? cardDescription;

  /// The decoration for the footer row of the card in Siren inbox.
  final BoxDecoration? cardFooterRow;

  /// The text style for the date text in Siren inbox.
  final TextStyle? dateStyle;

  /// The style for the notification icon.
  final IconStyle? iconStyle;

  /// The style for the notification icon badge.
  final BadgeStyle? badgeStyle;

  /// Text style for the header provided by the sdk.
  final TextStyle? defaultHeaderTextStyle;
}

/// Custom theme colors to configure the appearance of UI elements.
class CustomThemeColors {
  /// Constructs a [CustomThemeColors] with optional parameters.
  CustomThemeColors({
    this.backgroundColor,
    this.highlightedCardBorderColor,
    this.highlightedCardColor,
    this.borderColor,
    this.deleteIcon,
    this.clearAllIcon,
    this.textColor,
    this.dateColor,
    this.timerIcon,
    this.badgeBackgroundColor,
    this.badgeColor,
    this.iconColor,
    this.inboxTitleColor,
  });

  /// The background color for Siren inbox.
  final Color? backgroundColor;

  /// The color for the border of active cards in Siren inbox.
  final Color? highlightedCardBorderColor;

  /// The color for active cards in Siren inbox.
  final Color? highlightedCardColor;

  /// The color for card borders in Siren inbox.
  final Color? borderColor;

  /// The color for delete icon in Siren inbox.
  final Color? deleteIcon;

  /// The color for clear all icon in Siren inbox.
  final Color? clearAllIcon;

  /// The text color in Siren inbox.
  final Color? textColor;

  /// The color notification created at time
  final Color? dateColor;

  /// The color of timer icon
  final Color? timerIcon;

  /// The background color for notification icon badge.
  final Color? badgeBackgroundColor;

  /// The text color for notification icon badge.
  final Color? badgeColor;

  /// The color for notification icon.
  final Color? iconColor;

  /// The color for window title in Siren inbox.
  final Color? inboxTitleColor;
}

/// Properties for configuring the appearance of the notification window app bar.
class InboxHeaderProps {
  InboxHeaderProps({
    this.hideHeader,
    this.showBackButton,
    this.backButton,
    this.hideClearAll,
    this.customHeader,
    this.handleBackNavigation,
  });

  /// Flag to hide the header.
  final bool? hideHeader;

  /// Flag to show the header back button provided by the sdk.
  final bool? showBackButton;

  /// Default back button widget for the header provided by the sdk.
  final Icon? backButton;

  /// Flag to hide the "Clear All" button.
  final bool? hideClearAll;

  /// Custom header or appBar widget.
  final Widget? customHeader;

  /// Callback function for handling back navigation.
  final void Function()? handleBackNavigation;
}
