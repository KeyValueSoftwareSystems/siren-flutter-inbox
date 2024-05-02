import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/src/models/notification_model.dart';

/// Properties for configuring the appearance of the notification card.
class CardParams {
  /// Constructs a [CardParams] with optional parameters.
  const CardParams({
    this.hideAvatar,
    this.disableAutoMarkAsRead,
    this.deleteIcon,
    this.hideDelete,
    this.onAvatarClick,
    this.hideMediaThumbnail,
    this.onMediaThumbnailClick,
  });

  /// Determines whether to hide the avatar in the notification card in Siren inbox.
  final bool? hideAvatar;

  /// The flag to turn on and off the mark as read functionality
  final bool? disableAutoMarkAsRead;

  /// Custom widget that can be used instead of default delete in the card (x)
  final Widget? deleteIcon;

  /// Determines whether to hide the avatar in the notification card in Siren inbox.
  final bool? hideDelete;

  /// Callback function when a notification card is clicked.
  final void Function(NotificationType)? onAvatarClick;

  /// The flag to show media thumbnail
  final bool? hideMediaThumbnail;

  /// Callback function when a thumbnail media is clicked.
  final void Function(NotificationType)? onMediaThumbnailClick;
}

/// Customizable style for the Siren notification icon.
class NotificationIconStyle {
  /// Constructs an [NotificationIconStyle] with optional parameters.
  const NotificationIconStyle({this.size});

  /// Size of the notification icon.
  final double? size;
}

/// Default styles for the Siren notification icon.
class DefaultIconStyle {
  /// Default font size for the badge count.
  static double get defaultFontSize => 10;

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
    this.size,
    this.top,
    this.right,
  });

  /// The font size of the notification icon badge.
  final double? fontSize;

  /// The size of the notification icon badge.
  final double? size;

  /// The top position of the notification icon badge.
  final double? top;

  /// The right position of the notification icon badge.
  final double? right;
}

/// Style properties for customizing the appearance of various UI elements in the Siren theme.
class CustomStyles {
  /// Constructs a [CustomStyles] with optional parameters.
  const CustomStyles({
    this.container,
    this.cardStyle,
    this.appBarStyle,
    this.notificationIconStyle,
    this.badgeStyle,
    this.deleteIconSize,
    this.dateIconSize,
    this.clearAllIconSize,
  });

  /// The decoration for the Siren inbox list.
  final ContainerStyle? container;

  // The styles for inbox list item
  final CardStyle? cardStyle;

  /// The style for default app bar
  final InboxHeaderStyle? appBarStyle;

  /// The style for the notification icon.
  final NotificationIconStyle? notificationIconStyle;

  /// The style for the notification icon badge.
  final BadgeStyle? badgeStyle;

  /// Size of delete icon in inbox list card
  final double? deleteIconSize;

  /// Size of date icon in inbox list card
  final double? dateIconSize;

  /// Size of clear all icon in inbox default header
  final double? clearAllIconSize;
}

/// Custom theme colors to configure the appearance of UI elements.
class CustomThemeColors {
  /// Constructs a [CustomThemeColors] with optional parameters.
  CustomThemeColors({
    this.backgroundColor,
    this.primary,
    this.highlightedCardColor,
    this.borderColor,
    this.deleteIcon,
    this.clearAllIcon,
    this.textColor,
    this.dateColor,
    this.timerIcon,
    this.notificationIconColor,
    this.loaderColor,
    this.inboxHeaderColors,
    this.badgeColors,
    this.cardColors,
  });

  /// The background color for Siren inbox.
  final Color? backgroundColor;

  /// The color for the border of active cards in Siren inbox.
  final Color? primary;

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

  /// The color for notification icon.
  final Color? notificationIconColor;

  /// The color for refresh indicator in inbox list.
  final Color? loaderColor;

  /// The colors for inbox list card
  final CardColors? cardColors;

  /// The colors for inbox header
  final InboxHeaderColors? inboxHeaderColors;

  /// The colors for inbox list card
  final BadgeColors? badgeColors;
}

/// Custom theme colors to configure the appearance inbox list item.
class CardColors {
  CardColors({
    this.borderColor,
    this.background,
    this.titleColor,
    this.subtitleColor,
    this.descriptionColor,
  });

  /// The border color inbox  of list item
  final Color? borderColor;

  /// The default background color of inbox list item
  final Color? background;

  /// The title color inbox of list item
  final Color? titleColor;

  /// The sub title color of inbox list item
  final Color? subtitleColor;

  /// The description text color of inbox list item
  final Color? descriptionColor;
}

/// Custom theme colors to configure the inbox header
class InboxHeaderColors {
  InboxHeaderColors({
    this.background,
    this.titleColor,
    this.headerActionColor,
    this.borderColor,
  });

  /// The background color of inbox header
  final Color? background;

  /// The title color of inbox header
  final Color? titleColor;

  /// The action texts color of inbox header
  final Color? headerActionColor;

  /// The border color of inbox header
  final Color? borderColor;
}

/// Custom theme colors to configure icon badge
class BadgeColors {
  BadgeColors({
    this.backgroundColor,
    this.color,
  });

  /// The icon badge background color
  final Color? backgroundColor;

  /// The text color of icon badge
  final Color? color;
}

/// Properties for configuring the appearance of the notification window app bar.
class HeaderParams {
  HeaderParams({
    this.title,
    this.hideHeader,
    this.showBackButton,
    this.backButton,
    this.hideClearAll,
    this.customHeader,
    this.onBackPress,
  });

  /// Title of the inbox page or window.
  final String? title;

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
  final void Function()? onBackPress;
}

/// Properties to configure the style of container
class ContainerStyle {
  ContainerStyle({this.padding, this.decoration});

  /// The padding values for all sides of a container
  final EdgeInsetsGeometry? padding;

  /// The appearance of the container, including
  /// properties like background color, border, border radius, etc. of a container
  final BoxDecoration? decoration;
}

/// Properties to configure the style of default inbox header
class InboxHeaderStyle {
  InboxHeaderStyle({this.headerTextStyle, this.titlePadding, this.borderWidth});

  /// Text style for the default header text
  final TextStyle? headerTextStyle;

  /// Padding values for all sides for header text
  final EdgeInsetsGeometry? titlePadding;

  /// Border bottom with of default header container
  final double? borderWidth;
}

class CardStyle {
  CardStyle({
    this.cardContainer,
    this.cardTitle,
    this.cardSubtitle,
    this.cardDescription,
    this.dateStyle,
    this.avatarSize,
  });

  /// The decoration for each card in Siren inbox.
  final ContainerStyle? cardContainer;

  /// The text style for the card title in Siren inbox.
  final TextStyle? cardTitle;

  /// The text style for the sub-header text in Siren inbox.
  final TextStyle? cardSubtitle;

  /// The text style for the card description in Siren inbox.
  final TextStyle? cardDescription;

  /// The text style for the date text in Siren inbox.
  final TextStyle? dateStyle;

  /// The size of avatar image
  final double? avatarSize;
}
