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
        userToken: 'YOUR_USER_TOKEN',
        recipientId: 'YOUR_RECIPIENT_ID',
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

| Arguments        | Description                                                | Type                     | Default value |
| ---------------- | ---------------------------------------------------------- | ------------------------ | ------------- |
| darkMode         | Toggle to enable dark mode when custom theme is not passed | bool                     | false         |
| disabled         | Toggle to disable click on icon                            | bool                     | false         |
| hideBadge        | Toggle to hide unviewed count badge                        | bool                     | false         |
| notificationIcon | Option to use custom notification icon                     | Widget                   | null          |
| onError          | Callback for handling errors                               | Function(SirenErrorType) | null          |
| onTap            | Custom click handler for notification icon                 | VoidCallback             | null          |
| theme            | Theme properties for custom color theme                    | CustomThemeColors        | null          |
| customStyles     | Style properties for custom styling                        | CustomStyles             | null          |

#### Theme customization

Here are the available theme options:

```dart
 theme: CustomThemeColors(
    notificationIconColor: Colors.purple,
    badgeColors: BadgeColors(
    color: Colors.greenAccent, textColor: Colors.black),
 )
```

#### Style customization

Here are the custom style options for the notification icon:

```dart
 customStyles: CustomStyles(
    notificationIconStyle: NotificationIconStyle(size: 20),
    badgeStyle: BadgeStyle(fontSize: 9, size: 5),
 )
```

### 2.3. Configure notification inbox

Inbox is a paginated list view for displaying notifications.

```dart
 SirenInbox(
    headerParams: HeaderParams(showBackButton: true),
    cardParams: CardParams(hideAvatar: false),
    onError: (error) {
        // Handle Error
    },
 )
```

#### Arguments for the notification inbox

Given below are the arguments of Siren Inbox Widget.

| Arguments         | Description                                                          | Type                       | Default value                                                                                                                                                                                                                          |
| ----------------- | -------------------------------------------------------------------- | -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| darkMode          | Toggle to enable dark mode when custom theme is not passed           | bool                       | false                                                                                                                                                                                                                                  |
| itemsPerFetch     | Number of notifications fetch per api request (have a max cap of 50) | int                        | 20                                                                                                                                                                                                                                     |
| listEmptyWidget   | Custom widget for empty notification list                            | Widget                     | null                                                                                                                                                                                                                                   |
| customCard        | Custom widget to display the notification cards                      | Widget                     | null                                                                                                                                                                                                                                   |
| customLoader      | Custom widget to display the initial loading state                   | Widget                     | null                                                                                                                                                                                                                                   |
| customErrorWidget | Custom error widget                                                  | Widget                     | null                                                                                                                                                                                                                                   |
| cardParams        | Properties of notification card                                      | CardParams                 | CardParams(hideAvatar: false, disableAutoMarkAsRead: false, hideDelete: false, deleteIcon: Icon(Icons.close), onAvatarClick: Function(NotificationType), hideMediaThumbnail: false, onMediaThumbnailClick: Function(NotificationType)) |
| headerParams      | Properties of notification window header                             | HeaderParams               | HeaderParams(hideHeader: false, hideClearAll: false,title: 'Notifications', customHeader: null showBackButton:false, backButton: null, onBackPress: ()=> null )                                                                        |
| onCardClick       | Custom click handler for notification cards                          | Function(NotificationType) | null                                                                                                                                                                                                                                   |
| onError           | Callback for handling errors                                         | Function(SirenErrorType)   | null                                                                                                                                                                                                                                   |
| theme             | Theme properties for custom color theme                              | CustomThemeColors          | null                                                                                                                                                                                                                                   |
| customStyles      | Style properties for custom styling                                  | CustomStyles               | null                                                                                                                                                                                                                                   |

#### Theme customization

Here are some of the available theme options:

```dart
theme: CustomThemeColors(
            primary: Colors.blue,
            highlightedCardColor: Colors.blueAccent,
            textColor: Colors.green,
            cardColors: CardColors(
                titleColor: Colors.grey,
                subtitleColor: Colors.grey,
            ),
            inboxHeaderColors: InboxHeaderColors(
                titleColor:  Colors.redAccent,
                headerActionColor: Colors.purpleAccent,
                borderColor: Colors.cyanAccent
            ),
        ),
```

#### Style options

Here are some of the custom style options for the notification inbox:

```dart
customStyles: CustomStyles(
    container: ContainerStyle(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.yellow)),
    cardStyle: CardStyle(
        cardContainer: ContainerStyle(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.yellow,
                border: Border.all(color: Colors.red))),
            cardTitle: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            cardSubtitle:
                TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            cardDescription:
                TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            dateStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                avatarSize: 30,
        ),
    appBarStyle: InboxHeaderStyle(
        headerTextStyle:
        TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                titlePadding: EdgeInsets.symmetric(horizontal: 30),
        borderWidth: 5),
    timerIconStyle: TimerIconStyle(size: 30),
    deleteIconStyle: DeleteIconStyle(size: 30),
    clearAllIconStyle: ClearAllIconStyle(size: 30),
),
```

## 3. Siren Class

The `Siren Class` provides utility functions for modifying notifications.

```dart
Siren.markAsRead(id: 'notification-id');
```

| Function         | Arguments | Type            | Description                                                          |
| ---------------- | --------- | --------------- | -------------------------------------------------------------------- |
| markAsReadByDate | startDate | ISO date string | Sets the read status of notifications to true until the given date   |
| markAsReadById   | id        | string          | Set read status of a notification to true                            |
| deleteById       | id        | string          | Delete a notification by id                                          |
| deleteByDate     | startDate | ISO date string | Delete all notifications until given date                            |
| markAllAsViewed  | startDate | ISO date string | Sets the viewed status of notifications to true until the given date |

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
        userToken: 'YOUR_USER_TOKEN',
        recipientId: 'YOUR_RECIPIENT_ID',
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
