import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/widgets/card.dart';

class MockNetworkImage extends Mock implements NetworkImage {}

void main() {
  testWidgets('CardWidget renders correctly', (WidgetTester tester) async {
    // Create a mock notification data
    // ignore: unused_local_variable
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
      cardColor: Colors.blue, // Mock card color
    );

    // Mock the NetworkImage provider
    // final mockImageProvider = MockNetworkImage();
    // when(mockImageProvider.resolve(any, any)).thenAnswer(
    //   (_) => Future.value(
    //     ImageStreamCompleter(
    //       completer: Completer<ImageInfo>(),
    //       // Mock image stream completer
    //     ),
    //   ),
    // );

    // Build the CardWidget with the mock data
    await tester.pumpWidget(
      MaterialApp(
        home: CardWidget(
          onTap: (notification) {}, // Mock onTap function
          onDelete: (id) {}, // Mock onDelete function
          notification: notification,
          cardProps: const CardProps(hideAvatar: true),
          styles: null, // Mock styles
          // Pass the mock image provider
          // deleteWidget: Image(image: mockImageProvider),
        ),
      ),
    );

    // Verify that the header text is rendered
    expect(find.text('Test Header'), findsOneWidget);

    // Verify that the sub-header text is rendered
    expect(find.text('Test SubHeader'), findsOneWidget);

    // Verify that the body text is rendered
    expect(find.text('Test Body'), findsOneWidget);

    // Verify that the delete button is rendered
    // expect(find.byType(Image), findsOneWidget);
  });
}
