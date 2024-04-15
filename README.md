# Siren Flutter Inbox

## Overview

The `sirenapp_flutter_inbox` is a comprehensive and customizable Flutter UI kit for displaying and managing notifications. This documentation provides comprehensive information on how to install, configure, and use the sdk effectively.

## 1. Installation

To install the `sirenapp_flutter_inbox` package,

1. Open your `pubspec.yaml` file.
2. Add `sirenapp_flutter_inbox` to your dependencies.
3. Run `flutter pub get` in your terminal to install the package.

## 2. Configuration

### 2.1 Initialization

Initialize the sdk with user token and recipient id. Wrap the provider around your App's root.

```dart
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';

void main() {
  runApp(
    SirenProvider(
        userToken: 'your_user_token',
        recipientId: 'your_recipient_id',
        child: MyApp(),
    ),
  );
}
```

### 2.2 Configure notification icon

Once the provider is configured, next step is to configure the notification icon

This widget consists of a notification icon along with a badge to display the number of unviewed notifications.

```dart
SirenInboxIcon()
```

#### Arguments for notification icon

Below are optional arguments available for the icon widget:

| Arguments        | Description                                                | Type                      | Default value |
| ---------------- | ---------------------------------------------------------- | ------------------------- | ------------- |
| darkMode         | Toggle to enable dark mode when custom theme is not passed | boolean                   | false         |
| disabled         | Toggle to disable click on icon                            | boolean                   | false         |
| hideBadge        | Toggle to hide unviewed count badge                        | boolean                   | false         |
| notificationIcon | Option to use custom notification icon                     | Widget                    | null          |
| onError          | Callback for handling errors                               | Function(ApiErrorDetails) | null          |
| onTap            | Custom click handler for notification icon                 | VoidCallback              | null          |
| theme            | Theme properties for custom color theme                    | CustomThemeColors         | null          |
| customStyles     | Style properties for custom styling                        | SirenStyleProps           | null          |

#### Theme customization

Here are the available theme options:

```dart
theme: CustomThemeColors(
    badgeBackgroundColor: Colors.deepPurpleAccent,
    iconColor: Colors.white,
    badgeColor: Colors.white)
```

#### Style customization

Here are the custom style options for the notification icon:

```dart
customStyles: SirenStyleProps(
    iconStyle: IconStyle(size: 35),
        badgeStyle: BadgeStyle(
        fontSize: 10,
        size: 18,
        top: 2,
        right: 0,
    ))
```

### 2.3. Configure notification inbox

Inbox is a paginated list view for displaying notifications.

```dart
SirenInbox(
  theme: customTheme,
  hideHeader: false,
  darkMode: true,
  onError: (error) () {
    // Handle error
  },
);
```

#### Arguments for the notification inbox

Given below are the arguments of Siren Inbox Widget.

| Arguments               | Description                                                          | Type                           | Default value                                                                                                                                                       |
| ----------------------- | -------------------------------------------------------------------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| darkMode                | Toggle to enable dark mode when custom theme is not passed           | boolean                        | false                                                                                                                                                               |
| itemsPerFetch           | Number of notifications fetch per api request (have a max cap of 50) | int                            | 20                                                                                                                                                                  |
| listEmptyWidget         | Custom widget for empty notification list                            | Widget                         | null                                                                                                                                                                |
| customNotificationCard  | Custom widget to display the notification cards                      | Widget                         | null                                                                                                                                                                |
| customLoader            | Custom widget to display the initial loading state                   | Widget                         | null                                                                                                                                                                |
| customErrorWidget       | Custom error widget                                                  | Widget                         | null                                                                                                                                                                |
| cardProps               | Properties of notification card                                      | CardProps                      | CardProps(hideAvatar: false, disableAutoMarkAsRead: false, hideDelete: false, deleteWidget: Icon(Icons.close), onAvatarClick: Function(NotificationDataType))       |
| inboxHeaderProps        | Properties of notification window header                             | InboxHeaderProps               | InboxHeaderProps(hideHeader: false, hideClearAll: false,title: 'Notifications', customHeader: null showBackButton:false, backButton: null, onBackPress: ()=> null ) |
| onNotificationCardClick | Custom click handler for notification cards                          | Function(NotificationDataType) | null                                                                                                                                                                |
| onError                 | Callback for handling errors                                         | Function(ApiErrorDetails)      | null                                                                                                                                                                |
| theme                   | Theme properties for custom color theme                              | CustomThemeColors              | null                                                                                                                                                                |
| customStyles            | Style properties for custom styling                                  | SirenStyleProps                | null                                                                                                                                                                |

#### Theme customization

Here are the available theme options:

```dart
theme: CustomThemeColors(
    backgroundColor: const Color.fromRGBO(218, 223, 254, 1),
    highlightedCardBorderColor: const Color.fromRGBO(103, 58, 183, 1),
    highlightedCardColor: const Color.fromRGBO(171, 242, 251, 1),
    borderColor: const Color.fromRGBO(133, 146, 230, 1),
    deleteIcon: const Color.fromRGBO(103, 58, 183, 1),
    clearAllIcon: const Color.fromRGBO(103, 58, 183, 1),
    textColor: const Color.fromRGBO(0, 0, 0, 1),
    dateColor: const Color.fromRGBO(0, 0, 0, 1),
    timerIcon: const Color.fromRGBO(133, 146, 230, 1),
    inboxTitleColor: const Color.fromRGBO(0, 0, 0, 1),
    ),
```

#### Style options

Here are some of the custom style options for the notification inbox:

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

## 3. Siren Class

The `Siren Class` provides utility functions for modifying notifications.

```dart
Siren.markAsRead(id: 'notification-id');
```

| Function                         | Arguments | Type            | Description                                                          |
| -------------------------------- | --------- | --------------- | -------------------------------------------------------------------- |
| markAllNotificationsAsReadByDate | startDate | ISO date string | Sets the read status of notifications to true until the given date   |
| markAsRead                       | id        | string          | Set read status of a notification to true                            |
| deleteNotification               | id        | string          | Delete a notification by id                                          |
| deleteNotificationsByDate        | startDate | ISO date string | Delete all notifications until given date                            |
| markNotificationsAsViewed        | startDate | ISO date string | Sets the viewed status of notifications to true until the given date |

## 4. Error Codes

Given below are all possible error codes thrown by the package:

| Error code                 | Description                                                         |
| -------------------------- | ------------------------------------------------------------------- |
| GENERIC_API_ERROR          | Occurrence of an unexpected api error                               |
| AUTHENTICATION_FAILED      | Verification of the given tokens has failed                         |
| FETCH_COUNT_FAILED         | An error occurred while fetching unviewed count                     |
| NOTIFICATION_FETCH_FAILED  | An error occurred while fetching notifications                      |
| NOTIFICATION_READ_FAILED   | An error occurred while marking notifications as read               |
| NOTIFICATION_DELETE_FAILED | An error occurred while deleting notifications                      |
| UPDATE_VIEWED_FAILED       | An error occurred while updating the viewed status of notifications |

## Example

Here's a basic example to help you get started

```dart
import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';

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
