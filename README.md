# Siren Flutter Inbox

![Siren Logo](https://app.dev.sirenapp.io/assets/Siren-b2f89b52.svg)

## Table of Contents
<!-- MarkdownTOC -->
- [Overview](#overview)
- [Quick Start Guide](#quick-start-guide)
    - [Install SDK](#1-install-sdk)
    - [Siren Provider](#2-siren-provider)
    - [Siren Notification Icon](#3-siren-notification-icon)
    - [Siren Inbox](#4-siren-inbox)
    - [Siren Class](#5-siren-class)
    - [Error Codes](#6-error-codes)
    - [Complete Code Example](#complete-code-example)
- [I want to know more!](#i-want-to-know-more)

<!-- /MarkdownTOC -->


<a name="introduction"></a>
## Overview

The siren_flutter_inbox is a comprehensive and customizable Flutter UI kit for displaying and managing notifications. This documentation provides comprehensive information on how to install, configure, and use the sdk effectively.

## Quick Start Guide

### 1. Install Package
To install the `siren_flutter_inbox` package, add it to your `pubspec.yaml` file.

1. Open your `pubspec.yaml` file.
2. Add `siren_flutter_inbox` to your dependencies:
   ```
   dependencies:
     siren_flutter_inbox: ^1.0.0
   ```
3. Run `flutter pub get` in your terminal to install the package.

### 2. Siren Provider
The `SirenProvider` initializes the Siren SDK with the specified configuration, including arguments like the user token and recipient id. Wrap the `SirenProvider` around the root of your application.

```dart
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';

void main() {
  runApp(
    SirenProvider(
      config: SirenConfig(
        userToken: 'your_user_token',
        recipientId: 'your_recipient_id',
      ),
      child: MyApp(),
    ),
  );
}
```
The user token and recipient id in SirenProvider widget is used to authenticate and initialize the sdk.

### 3. Siren Notification Icon
The `SirenInboxIcon` widget includes a customizable notification icon and a badge for indicating the number of unread notifications.

```dart
SirenInboxIcon(
  notificationIcon: Icon(
    Icons.notifications_active_rounded,
    color: Colors.white,
    size: 30,
  ),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Window()),
    );
  },
  onError: (ApiErrorDetails error) {
    print(error.message);
  },
  darkMode: false,
  disabled: false,
  hideBadge: false,
  theme: CustomThemeColors(
    badgeBackgroundColor: Colors.deepPurpleAccent,
    iconColor: Colors.white,
    badgeColor: Colors.white,
  ),
  customStyles: SirenStyleProps(
    iconStyle: IconStyle(size: 35),
    badgeStyle: BadgeStyle(
      fontSize: 10,
      size: 18,
      inset: 1,
      top: 2,
      right: 0,
    ),
  ),
),
```
#### Siren Notification Icon Arguments
Given below are the arguments of notification icon widget.

Arguments | Description | Type | Default value |
--- | --- | --- | --- |
customStyles | Style properties for custom styling |  SirenStyleProps | null |
darkMode | Flag to enable dark mode |  boolean | false |
disabled | Flag to disable click handler of icon |  boolean | false |
hideBadge | Flag to hide badge|  boolean | false |
notificationIcon | Option to use custom notification Icon |  Widget | null |
onError | Callback for handling errors | Function(ApiErrorDetails)? | null |
onTap | Function for handling press of icon | VoidCallback? | null |
theme | Theme properties for custom color theme |  CustomThemeColors | null |

#### Theming options
Customize the unread badge of the notification icon, and choose between dark and light theming options. 
```dart
theme: CustomThemeColors(
    badgeBackgroundColor: Colors.deepPurpleAccent,
    iconColor: Colors.white,
    badgeColor: Colors.white)
```
#### Styling options
Customize the notification icon style properties which includes size of icon and badge,
```dart
customStyles: SirenStyleProps(
    iconStyle: IconStyle(size: 35),
        badgeStyle: BadgeStyle(
        fontSize: 10,
        size: 18,
        inset: 1,
        top: 2,
        right: 0,
        ))
```

### 4. Siren Inbox
The `SirenInbox` widget is a paginated list view for displaying notifications.

```dart
SirenInbox(
  theme: customTheme,
  title: 'Notifications',
  hideHeader: false,
  darkMode: true,
  onError: (error) => print(error),
);
```
#### Siren Inbox Arguments
Given below are the arguments of Siren Inbox Widget.

Arguments | Description | Type | Default value |
--- | --- | --- | --- |
customStyles | Style properties for custom styling |  SirenStyleProps | null |
hideAvatar | Flag to hide avatar |  boolean | false |
deleteWidget | Custom widget for custom delete icon in notification card |  Widget | null |
hideHeader | Flag to hide the default Inbox app bar|  boolean | false |
listEmptyWidget | Custom widget to display when the notification list is empty  |  Widget | null |
title | Title displayed for Inbox app bar |  String | null |
defaultHeaderTextStyle | TextStyle for the title in default app bar|  TextStyle | null |
showDefaultHeaderBackButton | Flag to determine whether to display back button in default Inbox app bar |  boolean | false |
defaultBackButton | Custom icon to be used as back button in Inbox app bar |  Icon | null |
customNotificationCard | Custom widget to display the notification card |  Widget | null |
onNotificationCardClick | Function to handle notification card click |  Function(NotificationDataType) | null |
onError | Callback for handling errors |  Function(ApiErrorDetails) | null |
hideClearAll | Flag to hide clear all CTA in Inbox app bar |  boolean | false |
theme | Theme properties for custom color theme |  boolean | false |
customLoader | Custom widget to display the initial loading state in the Inbox |  Widget | null |
customErrorWidget | Custom widget to display error state |  Widget | null |
customHeader | Custom widget to display the app bar in Inbox |  Widget | null |
handleBackNavigation | Function to handle the back button click |  Function() | null |
disableAutoMarkAsRead | Flag to disable the mark as read functionality on notification card click |  boolean | false |
itemsPerFetch | Items fetched in a request |  int | 20 |

#### Theming options
Customizable theme option for notification inbox, with dark and light theme options. 

```dart
theme: CustomThemeColors(
    backgroundColor: const Color.fromRGBO(218, 223, 254, 1),
    activeCardBorderColor: const Color.fromRGBO(103, 58, 183, 1),
    activeCardColor: const Color.fromRGBO(171, 242, 251, 1),
    cardBorder: const Color.fromRGBO(133, 146, 230, 1),
    deleteIconColor: const Color.fromRGBO(103, 58, 183, 1),
    clearAllIconColor: const Color.fromRGBO(103, 58, 183, 1),
    textColor: const Color.fromRGBO(0, 0, 0, 1),
    windowTitleColor: const Color.fromRGBO(0, 0, 0, 1),
    ),
```
#### Styling options
Customizable Styling option for notification inbox.

```dart
customStyles: SirenStyleProps(
    cardAvatarContainer: BoxDecoration(
        border: Border.all(
            color: AppColors.primaryBlue,
            width: 1,
            ),
            shape: BoxShape.circle,
        ),
        container: BoxDecoration(
            border: Border.all(
              color: Colors.black,
        ),
    ),
    contentContainer: BoxDecoration(
        border: Border.all(
            color: Colors.red,
        ),
    ),
    subHeaderText: TextStyle(
        color: Colors.red,
    ),
    cardTitle: TextStyle(
        color: Colors.black,
    ),
    dateStyle: TextStyle(
        color: Colors.green,
    ),
)
```

### 5. Siren Class
The `Siren Class` class provides utility functions for modifying notifications.

```dart
Siren.markAsRead(id: 'notification-id');
```

Function | Arguments | Description |
--- | --- | --- |
markAllNotificationsAsReadByDate | startDate: string | Set all notification read status to true until given date |
markAsRead | id: string | Set read status of a specific notification to true |
deleteNotification |  id: string  | Delete a specific notification by id |
deleteNotificationsByDate | startDate: string | Delete all notifications until given date |
markNotificationsAsViewed | startDate: string | Set all notification viewed status to true until given date |

### 6. Error Codes
The package may throw various error codes, which includes:

Error code | Description |
GENERIC_API_ERROR | This error occurs when an unspecified error occurs |
AUTHENTICATION_FAILED | This error occurs when authentication fails, either the token or the recipient id provided might be incorrect |
FETCH_COUNT_FAILED | This error occurs when there is an issue fetching the count of notifications |
NOTIFICATION_FETCH_FAILED | This error occurs when there is an issue fetching notifications |
NOTIFICATION_READ_FAILED | This error occurs when there is an issue marking notifications as read |
NOTIFICATION_DELETE_FAILED | This error occurs when there is an issue deleting notifications |
UPDATE_VIEWED_FAILED | This error occurs when there is an issue updating the viewed status of notifications |

## Complete Code Example
Here's a complete code example demonstrating the usage of the package.

```dart
import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SirenProvider(
        userToken: 'your-token',
        recipientId: 'your-recipient-id',
        child: MaterialApp(
          title: 'Siren Flutter Inbox',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'Home Page'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(''),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                SirenInboxIcon(),
              ],
            ),
          ),
        ],
      ),
      body: SirenInbox(),
    );
  }
}
```

## Learn More
For more information and advanced guides, you can refer to the [Flutter documentation](https://flutter.dev/docs).
