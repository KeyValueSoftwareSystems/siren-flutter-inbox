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
    // ignore: unused_local_variable
    final func = MockFunction().call;
    final notification = NotificationType(
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
            onTap: (NotificationType notification) {},
            onDelete: (id) {
              deletePressed = true;
            },
            notification: notification,
            cardParams: CardParams(
              hideAvatar: false,
              hideDelete: false,
              onAvatarClick: (notification) {
                func();
              },
            ),
            styles: null, // Mock styles
            colors: CustomThemeColors(
              cardColors: CardColors(
                borderColor: Colors.red,
                background: Colors.blue,
                titleColor: Colors.yellow,
                subtitleColor: Colors.brown,
                descriptionColor: Colors.orange,
              ),
            ),
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

    final textFinder = find.byType(Text).at(0);
    final textWidget = tester.widget<Text>(textFinder);
    final textColor = textWidget.style?.color;
    expect(textColor, equals(Colors.yellow));

    final textFinder2 = find.byType(Text).at(1);
    final textWidget2 = tester.widget<Text>(textFinder2);
    final textColor2 = textWidget2.style?.color;
    expect(textColor2, equals(Colors.brown));

    final textFinder3 = find.byType(Text).at(2);
    final textWidget3 = tester.widget<Text>(textFinder3);
    final textColor3 = textWidget3.style?.color;
    expect(textColor3, equals(Colors.orange));

    expect(deletePressed, true);
  });
}
