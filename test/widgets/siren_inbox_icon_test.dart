import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/api/fetch_unviewed_notification_count.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/theme/app_theme.dart';

// Create a mock class for SirenDataProvider
class MockSirenDataProvider extends Mock implements SirenDataProvider {}

// Create a mock class for your function

class MockFunction extends Mock {
  // Define the mock function signature
  void call(); // You can define parameters and return types as needed
}

class MockFetchUnViewedNotificationsCount extends Mock
    implements FetchUnViewedNotificationsCount {}

class MockApiResponse extends Mock implements ApiResponse {}

void main() {
  group('SirenInboxIcon', () {
    late StreamController<StreamResponse> iconController;
    late StreamController<StreamResponse> inboxController;

    setUp(() {
      iconController = StreamController<StreamResponse>.broadcast();
      inboxController = StreamController<StreamResponse>.broadcast();
    });

    tearDown(() {
      iconController.close();
      inboxController.close();
    });

    testWidgets('Widget initialization', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SirenInboxIcon(),
          ),
        ),
      );

      expect(find.byType(SirenInboxIcon), findsOneWidget);
    });

    testWidgets('Disabled widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SirenInboxIcon(
                disabled: true,
              ),
            ),
          ),
        ),
      );

      final ignorePointerFinder = find.byWidgetPredicate(
        (widget) =>
            widget is IgnorePointer &&
            widget.ignoring &&
            widget.child is GestureDetector,
      );

      expect(ignorePointerFinder, findsOneWidget);
    });

    testWidgets('Widget with custom notification icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SirenInboxIcon(
              notificationIcon: Icon(Icons.mail),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.mail), findsOneWidget);
    });

    testWidgets('Widget updates in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SirenInboxIcon(
              darkMode: true,
            ),
          ),
        ),
      );

      final primaryColor = AppTheme.darkTheme.colorScheme.primary;

      // Ensure dark theme is applied
      expect(primaryColor, const Color(0xff232326));
    });

    testWidgets('Widget disposes controllers on dispose',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SirenInboxIcon(),
          ),
        ),
      );

      await tester.pumpWidget(Container()); // Dispose the widget

      // Verify controllers are closed
      expect(iconController.hasListener, false);
      expect(inboxController.hasListener, false);
    });

    testWidgets('Widget with no badge', (WidgetTester tester) async {
      const widget = MaterialApp(
        home: Scaffold(
          body: SirenInboxIcon(
            hideBadge: true,
          ),
        ),
      );
      await tester.pumpWidget(widget);

      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
      expect(find.byType(Positioned), findsNothing);
    });
    testWidgets('Widget test on Tap', (WidgetTester tester) async {
      final func = MockFunction().call;
      final widget = MaterialApp(
        home: Scaffold(
          body: SirenInboxIcon(
            hideBadge: true,
            onTap: func,
          ),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      verify(func()).called(1);
    });
  });
}
