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
    - [Siren Class](#5-Siren class)
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
The `SirenProvider` initializes the Siren SDK with the specified configuration, including parameters like the user token and recipient id. Wrap the `SirenProvider` around the root of your application.

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
The user token and recipient id in SirenProvider component is used to authenticate and initialize the sdk.

### 3. Siren Notification Icon
The `SirenInboxIcon` widget includes a customizable notification icon and a badge for indicating the number of unread notifications.

```dart
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';

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

### 4. Siren Inbox
The `SirenInbox` widget is a paginated list view for displaying notifications.

```dart
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';

SirenInbox(
  theme: customTheme,
  title: 'Notifications',
  hideHeader: false,
  darkMode: true,
  onError: (error) => print(error),
);
```


### 5. Siren Class
The `Siren` class provides utility functions for modifying notifications.

```dart
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';

Siren.markAsRead(id: 'notification-id');
```

Function name | Parameters type | Description |
--- | --- | --- |
markAllNotificationsAsReadByDate | startDate: string | Set all notification read status to true until given date |
markAsRead | id: string | Set read status of a specific notification to true |
deleteNotification |  id: string  | Delete a specific notification by id |
deleteNotificationsByDate | startDate: string | Delete all notifications until given date |
markNotificationsAsViewed | startDate: string | Set all notification viewed status to true until given date |

### 6. Error Codes
The package may throw various error codes, including:
- `DEFAULT_ERROR`: This error occurs when an unspecified error occurs.
- `AUTHENTICATION_ERROR`: This error occurs when authentication fails or is invalid.
- `FETCH_COUNT_ERROR`: This error occurs when there is an issue fetching the count of notifications.
- `NOTIFICATION_FETCH_ERROR`: This error occurs when there is an issue fetching notifications.
- `NOTIFICATION_READ_ERROR`: This error occurs when there is an issue marking notifications as read.
- `NOTIFICATION_DELETE_ERROR`: This error occurs when there is an issue deleting notifications.
- `UPDATE_VIEWED_ERROR`: This error occurs when there is an issue updating the viewed status of notifications.

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
  const MyHomePage({super.key, required this.title});

  final String title;

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
