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
| hideTab           | Toggle to enable all and unread tabs                                 | bool                       | false                                                                                                                                                                                                                                  |
| itemsPerFetch     | Number of notifications fetch per api request (max 50)               | int                        | 20                                                                                                                                                                                                                                     |
| listEmptyWidget   | Custom widget for empty notification list                            | Widget                     | null                                                                                                                                                                                                                                   |
| customCard        | Custom builder for notification cards                                | Widget Function(NotificationType) | null                                                                                                                                                                                                                                   |
| customLoader      | Custom widget to display the initial loading state                   | Widget                     | null                                                                                                                                                                                                                                   |
| customErrorWidget | Custom error widget                                                  | Widget                     | null                                                                                                                                                                                                                                   |
| cardParams        | Properties of notification card                                      | CardParams                 | CardParams(hideAvatar: false, disableAutoMarkAsRead: false, hideDelete: false, deleteIcon: Icon(Icons.close), onAvatarClick: Function(NotificationType), hideMediaThumbnail: false, onMediaThumbnailClick: Function(NotificationType)) |
| headerParams      | Properties of notification window header                             | HeaderParams               | HeaderParams(hideHeader: false, hideClearAll: false, title: 'Notifications', customHeader: null, showBackButton: false, backButton: null, onBackPress: null)                                                                          |
| tabParams         | Properties of tab bar                                                | TabParams                  | TabParams(tabs: [TabItem(key: 'ALL', title: 'All'), TabItem(key: 'UNREAD', title: 'Unread')], activeTabIndex: 0)                                                                                                                       |
| onCardClick       | Custom click handler for notification cards                          | Function(NotificationType) | null                                                                                                                                                                                                                                   |
| onError           | Callback for handling errors                                         | Function(SirenErrorType)   | null                                                                                                                                                                                                                                   |
| theme             | Theme properties for custom color theme                              | CustomThemeColors          | null                                                                                                                                                                                                                                   |
| customStyles      | Style properties for custom styling                                  | CustomStyles               | null                                                                                                                                                                                                                                   |
| customTabIndicator| Custom decoration for tab indicator                                  | BoxDecoration             | null                                                                                                                                                                                                                                   |
| filterParams      | Properties for configuring the filter dropdown                     | FilterParams               | FilterParams(categoryFilterParams: CategoryFilterParams(showFilters: true, filterIconWidget: null, hideBadge: false, categoryFilterStyles: CategoryFilterStyles(dropdownTextStyle: null)))                                                                                                                                                 |

#### Theme customization

Here are the available theme options:

```dart
theme: CustomThemeColors(
    backgroundColor: Colors.blue,
    primary: Colors.blueAccent,
    highlightedCardColor: Colors.blue.shade100,
    borderColor: Colors.grey.shade300,
    deleteIcon: Colors.red,
    clearAllIcon: Colors.grey,
    textColor: Colors.black87,
    dateColor: Colors.grey,
    timerIcon: Colors.blue,
    notificationIconColor: Colors.blue,
    loaderColor: Colors.blue,
    inboxHeaderColors: InboxHeaderColors(
        background: Colors.white,
        titleColor: Colors.black87,
        headerActionColor: Colors.blue,
        borderColor: Colors.grey.shade300
    ),
    badgeColors: BadgeColors(
        backgroundColor: Colors.red,
        color: Colors.white
    ),
    cardColors: CardColors(
        borderColor: Colors.grey.shade300,
        background: Colors.white,
        titleColor: Colors.black87,
        subtitleColor: Colors.grey,
        descriptionColor: Colors.black54
    ),
    tabColors: TabColors(
        containerBackgroundColor: Colors.white,
        activeTabBackgroundColor: Colors.blue.shade50,
        activeTabTextColor: Colors.blue,
        inactiveTabTextColor: Colors.grey,
        indicatorColor: Colors.blue
    ),
    filterColors: FilterColors(
        categoryFilterColors: CategoryFilterColors(
            filterIconBorderColor: Colors.grey.shade300,
            filterBadgeColor: Colors.blue,
            filterDropdownBackgroundColor: Colors.white,
            filterCheckboxCheckedColor: Colors.blue,
            filterCheckboxUncheckedColor: Colors.grey.shade300,
            filterActionTextColor: Colors.black87,
            filterIconColor: Colors.blue,
            checkIconColor: Colors.white
        )
    )
)
```

#### Style customization

Here are the custom style options for the notification inbox:

```dart
customStyles: CustomStyles(
    container: ContainerStyle(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)
        ),
        margin: EdgeInsets.all(8)
    ),
    cardStyle: CardStyle(
        cardContainer: ContainerStyle(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8)
            )
        ),
        cardTitle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87
        ),
        cardSubtitle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey
        ),
        cardDescription: TextStyle(
            fontSize: 14,
            color: Colors.black54
        ),
        dateStyle: TextStyle(
            fontSize: 12,
            color: Colors.grey
        ),
        avatarSize: 40
    ),
    appBarStyle: InboxHeaderStyle(
        headerTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87
        ),
        titlePadding: EdgeInsets.symmetric(horizontal: 16),
        borderWidth: 1
    ),
    notificationIconStyle: NotificationIconStyle(
        size: 24
    ),
    badgeStyle: BadgeStyle(
        fontSize: 12,
        size: 20,
        top: 0,
        right: 2
    ),
    timerIconStyle: TimerIconStyle(
        size: 20
    ),
    deleteIconStyle: DeleteIconStyle(
        size: 20
    ),
    clearAllIconStyle: ClearAllIconStyle(
        size: 20
    ),
    tabStyles: TabStyles(
        containerStyle: ContainerStyle(
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.only(bottom: 8)
        ),
        activeTabTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.blue
        ),
        inActiveTabTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey
        ),
        indicatorSize: 2,
        indicatorPadding: EdgeInsets.symmetric(horizontal: 16)
    ),
    hideTabMargin: HideTabMargin(
        upper: false,
        lower: false
    ),
    filterStyles: FilterStyles(
        categoryFilterStyles: CategoryFilterStyles(
            dropdownTextStyle: TextStyle(
                fontSize: 14,
                color: Colors.black87
            )
        )
    )
)
```

### 2.4. Filter Configuration

The filter functionality allows users to filter notifications by categories. Here's how to configure it:

```dart
SirenInbox(
    filterParams: FilterParams(
        categoryFilterParams: CategoryFilterParams(
            showFilters: true,
            filterIconWidget: Icon(Icons.filter_list), // Optional custom filter icon
            hideBadge: false, // Optional hide badge showing number of selected filters
            categoryFilterStyles: CategoryFilterStyles( // Optional custom styles for category filter
                dropdownTextStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black87
                )
            )
        )
    )
)
```

#### Filter Features:
- Custom filter icon support
- Badge showing number of selected filters (99+ for more than 99 selections)
- Dropdown with checkbox selection
- Customizable colors and styles for all filter components

#### Category Filter Styles
You can customize the appearance of the category filter dropdown using `CategoryFilterStyles`:

```dart
CategoryFilterStyles(
    dropdownTextStyle: TextStyle(
        fontSize: 14,
        color: Colors.black87,
        fontWeight: FontWeight.w500
    )
)
```

| Style Property    | Description                                    | Type      | Default Value                    |
|------------------|------------------------------------------------|-----------|----------------------------------|
| dropdownTextStyle| Style for the category text in dropdown        | TextStyle | fontSize: 14, color: Colors.black87 |

### 2.5 Configure notification builder

`SirenNotificationBuilder` is a headless widget that manages notification data (fetching, pagination, polling, and state) and exposes it through a builder callback. Use it to build fully custom notification UIs while the SDK handles the data layer.

```dart
SirenNotificationBuilder(
  itemsPerFetch: 10,
  builder: (context, state, controller) {
    if (state.isLoading) return CircularProgressIndicator();
    if (state.isError) return Text('Error: ${state.error?.message}');
    return ListView.builder(
      itemCount: state.notifications.length,
      itemBuilder: (context, index) {
        final notification = state.notifications[index];
        return ListTile(
          title: Text(notification.message.header ?? ''),
          subtitle: Text(notification.message.body ?? ''),
          onTap: () => controller.markAsRead(notification.id),
        );
      },
    );
  },
)
```

#### Arguments for notification builder

| Arguments     | Description                                               | Type                                                                           | Default value |
| ------------- | --------------------------------------------------------- | ------------------------------------------------------------------------------ | ------------- |
| builder       | Builder that receives state and controller                | Widget Function(BuildContext, SirenNotificationState, SirenNotificationController) | required      |
| itemsPerFetch | Number of notifications per page (max 50)                 | int?                                                                           | 20            |
| isRead        | Filter by read status. `null` returns all                 | bool?                                                                          | null          |
| categories    | Filter by notification categories                         | List\<String\>?                                                                | null          |
| onError       | Callback for handling errors                              | Function(SirenErrorType)?                                                      | null          |

#### SirenNotificationState

The state object provided to the builder:

| Property      | Type                    | Description                             |
| ------------- | ----------------------- | --------------------------------------- |
| notifications | List\<NotificationType\>| The list of notifications fetched so far|
| isLoading     | bool                    | Whether the initial fetch is in progress|
| isError       | bool                    | Whether an error occurred               |
| hasMore       | bool                    | Whether more pages are available        |
| error         | SirenErrorType?         | The error details, if any               |

#### SirenNotificationController

The controller object provided to the builder:

| Method     | Return type    | Description                            |
| ---------- | -------------- | -------------------------------------- |
| loadMore() | void           | Load the next page of notifications    |
| refresh()  | Future\<void\> | Refresh the notification list          |
| markAsRead(id) | Future\<void\> | Mark a notification as read by ID  |
| delete(id) | Future\<void\> | Delete a notification by ID            |

## 3. Siren Class

The `Siren` class provides static utility functions for fetching and modifying notifications.

```dart
Siren.markAsReadById(id: 'notification-id');
```

| Function           | Arguments  | Type                       | Description                                                          |
| ------------------ | ---------- | -------------------------- | -------------------------------------------------------------------- |
| fetchNotifications | size, isRead, start, end, categories | SirenNotificationResult | Fetch a list of notifications with optional filters |
| notificationStream | —          | Stream\<StreamResponse\>   | Broadcast stream of inbox update events                              |
| markAsReadById     | id         | string                     | Set read status of a notification to true                            |
| markAsReadByDate   | startDate  | ISO date string            | Sets the read status of notifications to true until the given date   |
| deleteById         | id         | string                     | Delete a notification by id                                          |
| deleteByDate       | startDate  | ISO date string            | Delete all notifications until given date                            |
| markAllAsViewed    | startDate  | ISO date string            | Sets the viewed status of notifications to true until the given date |

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
