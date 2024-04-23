import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/error_widget.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/inbox_body.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/loader_widget.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/notification_list_view.dart';

void main() {
  testWidgets('InboxBody displays loader when isLoading is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: InboxBody(
          currentTheme: ThemeData(),
          isLoading: true,
          loadingNextPage: false,
          isError: false,
          notifications: const [],
          deleteNotification: (id) async {},
          markAsRead: (id) {},
          customCard: null,
          onCardClick: null,
          deletingNotificationId: null,
          disableAutoMarkAsRead: false,
          totalElements: 0,
          onRefresh: () async {},
          endReached: false,
          onEndReached: () {},
          scrollController: ScrollController(),
        ),
      ),
    );

    expect(find.byType(LoaderWidget), findsOneWidget);
  });

  testWidgets('InboxBody displays error widget when isError is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: InboxBody(
          currentTheme: ThemeData(),
          isLoading: false,
          loadingNextPage: false,
          isError: true,
          notifications: const [],
          deleteNotification: (id) async {},
          markAsRead: (id) {},
          customCard: null,
          onCardClick: null,
          deletingNotificationId: null,
          disableAutoMarkAsRead: false,
          totalElements: 0,
          onRefresh: () async {},
          endReached: false,
          onEndReached: () {},
          scrollController: ScrollController(),
        ),
      ),
    );

    expect(find.byType(DefaultErrorWidget), findsOneWidget);
  });

  testWidgets('InboxBody displays notifications', (WidgetTester tester) async {
    final notifications = <NotificationType>[
      NotificationType(
        id: '1',
        createdAt: '2024-03-15T04:07:14.577928Z',
        message: MessageData(
          header: 'Test Header',
          subHeader: 'Test SubHeader',
          body: 'Test Body',
          channel: 'Test Channel',
          actionUrl: 'Test Action Url',
          avatar: AvatarData(
            altText: 'Test alt text',
            url: 'https://picsum.photos/200/300',
          ),
          additionalData: 'Test Additional Data',
        ),
        requestId: 'request-id',
        isRead: false,
        cardColor: Colors.black,
      ),
    ];
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: InboxBody(
            currentTheme: ThemeData(),
            isLoading: false,
            loadingNextPage: false,
            isError: false,
            notifications: notifications,
            deleteNotification: (id) async {},
            markAsRead: (id) {},
            customCard: null,
            onCardClick: null,
            deletingNotificationId: null,
            disableAutoMarkAsRead: false,
            totalElements: 1,
            onRefresh: () async {},
            endReached: false,
            onEndReached: () {},
            scrollController: ScrollController(),
          ),
        ),
      );

      expect(find.byType(NotificationListView), findsOneWidget);
    });
  });
}
