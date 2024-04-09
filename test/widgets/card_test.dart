import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/card.dart';

class MockNetworkImage extends Mock implements NetworkImage {}

class MockFunction extends Mock {
  void call();
}

void main() {
  testWidgets('CardWidget renders correctly', (WidgetTester tester) async {
    // Create a mock notification data
    // ignore: unused_local_variable
    final func = MockFunction().call;
    final notification = NotificationDataType(
      id: '123',
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
      requestId: '456',
      isRead: false,
      cardColor: Colors.blue,
    );

    var deletePressed = false;
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: CardWidget(
            onTap: (notification) {},
            onDelete: (id) {
              deletePressed = true;
            },
            notification: notification,
            cardProps: CardProps(
              hideAvatar: false,
              hideDelete: false,
              onAvatarClick: (notification) {
                func();
              },
            ),
            styles: null, // Mock styles
            // deleteWidget: Image(image: mockImageProvider),
          ),
        ),
      );
    });
    expect(find.text('Test Header'), findsOneWidget);
    expect(find.text('Test SubHeader'), findsOneWidget);
    expect(find.text('Test Body'), findsOneWidget);
    await tester.tap(find.byType(GestureDetector).at(1));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    verify(func()).called(1);
    await tester.tap(find.byType(GestureDetector).at(2));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(deletePressed, true);
  });
}
