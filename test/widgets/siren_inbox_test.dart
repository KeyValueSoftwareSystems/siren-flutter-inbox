import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/utils/common_utils.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/error_widget.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/loader_widget.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/notification_list_view.dart';

class MockFunction extends Mock {
  // Define the mock function signature
  void call(); // You can define parameters and return types as needed
}

void main() {
  group('SirenInbox Widget Test', () {
    late StreamController<StreamResponse> iconController;
    late StreamController<StreamResponse> inboxController;
    final notification = <NotificationDataType>[
      NotificationDataType(
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

    setUp(() {
      iconController = StreamController<StreamResponse>.broadcast();
      inboxController = StreamController<StreamResponse>.broadcast();
    });

    tearDown(() {
      iconController.close();
      inboxController.close();
    });
    testWidgets('Initial loading state', (WidgetTester tester) async {
      // Mock SirenDataProvider

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SirenInbox(),
          ),
        ),
      );

      // Loading state widget should be displayed
      expect(find.byType(LoaderWidget), findsOneWidget);
    });

    // testWidgets('Error state', (WidgetTester tester) async {
    //   // Mock SirenDataProvider

    //   await tester.pumpWidget(
    //     const MaterialApp(
    //       home: Scaffold(
    //         body: SirenInbox(),
    //       ),
    //     ),
    //   );

    //   // Error state widget should be displayed
    //   expect(find.byType(DefaultErrorWidget), findsOneWidget);
    // });

    testWidgets('Test Title', (WidgetTester tester) async {
      // Mock SirenDataProvider

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SirenInbox(
              title: 'Notifications Header',
            ),
          ),
        ),
      );

      // Loading state widget should be displayed
      expect(find.byType(LoaderWidget), findsOneWidget);

      // Simulate a successful fetch
      await tester.pump();

      // Verify that notification list is displayed
      expect(find.text('Notifications Header'), findsOneWidget);
    });

    testWidgets('Custom Header', (WidgetTester tester) async {
      // Mock SirenDataProvider

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SirenInbox(
              customHeader: Text('Custom Header'),
            ),
          ),
        ),
      );

      // Loading state widget should be displayed
      expect(find.byType(LoaderWidget), findsOneWidget);

      // Simulate a successful fetch
      await tester.pump();

      // Verify that notification list is displayed
      expect(find.text('Custom Header'), findsOneWidget);
    });

    testWidgets('Widget Handle back navigation', (WidgetTester tester) async {
      final func = MockFunction().call;
      final widget = MaterialApp(
        home: Scaffold(
          body: SirenInbox(
            showDefaultBackButton: true,
            handleBackNavigation: func,
          ),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      verify(func()).called(1);
    });

    testWidgets('Show default back button', (WidgetTester tester) async {
      const widget = MaterialApp(
        home: Scaffold(
          body: SirenInbox(
            showDefaultBackButton: true,
            // defaultBackButton: Icon(Icons.back_hand),
          ),
        ),
      );
      await tester.pumpWidget(widget);
      // await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
    });
  });
}
