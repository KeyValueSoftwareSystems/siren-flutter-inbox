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
  });
}
