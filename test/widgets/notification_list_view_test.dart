import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/notification_list_view.dart';

class MockFunction extends Mock {
  void call();
}

void main() {
  final notificationsList = <NotificationType>[
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
  testWidgets('NotificationListView renders correctly',
      (WidgetTester tester) async {
    const isLoading = false;
    const endReached = false;
    const loadingNextPage = false;

    await mockNetworkImagesFor(() async {
      final func = MockFunction().call;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationListView(
              notifications: notificationsList,
              isLoading: isLoading,
              endReached: endReached,
              loadingNextPage: loadingNextPage,
              onRefresh: () async {},
              onEndReached: () {},
              customStyles: null,
              scrollController: ScrollController(),
              onDelete: (id) async {},
              markAsRead: (id) {},
              onCardClick: (n) {
                func();
              },
            ),
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      verify(func()).called(1);
      expect(find.byElementType(CircularProgressIndicator), findsNothing);
    });
  });

  testWidgets('NotificationListView with custom notification card',
      (WidgetTester tester) async {
    const isLoading = false;
    const endReached = false;
    const loadingNextPage = false;

    await mockNetworkImagesFor(() async {
      final func = MockFunction().call;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationListView(
              notifications: notificationsList,
              isLoading: isLoading,
              endReached: endReached,
              loadingNextPage: loadingNextPage,
              onRefresh: () async {},
              onEndReached: () {},
              customStyles: null,
              scrollController: ScrollController(),
              customCard: (n) {
                return Text(n.message.subHeader.toString());
              },
              onDelete: (id) async {},
              markAsRead: (id) {},
              onCardClick: (n) {
                func();
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Test SubHeader'), findsOne);
    });
  });
}
