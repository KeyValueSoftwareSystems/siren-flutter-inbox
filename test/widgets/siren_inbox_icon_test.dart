// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/api/fetch_unviewed_notification_count.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/theme/app_colors.dart';

import 'siren_inbox_test.mocks.dart';

class MockFunction extends Mock {
  void call();
}

@GenerateMocks([SirenDataProvider, FetchUnViewedNotificationsCount])
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
      final mockSirenDataProvider = MockSirenDataProvider();
      final mockFetchUnViewedNotificationsCount =
          MockFetchUnViewedNotificationsCount();
      final result = ApiResponse()..isLoading = true;
      result.data = 5;
      result.isSuccess = true;

      when(mockSirenDataProvider.tokenVerificationStatus)
          .thenReturn(Status.SUCCESS);
      when(
        mockFetchUnViewedNotificationsCount.fetchUnViewedNotificationsCount(),
      ).thenAnswer((_) async => result);

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

      final primaryColor = AppColors.darkColorTheme().primary;

      expect(primaryColor, const Color(0xfffa9874));
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

      await tester.pumpWidget(Container());

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

    testWidgets('Stream', (WidgetTester tester) async {
      final result = ApiResponse()..isSuccess = true;
      const widget = MaterialApp(
        home: Scaffold(
          body: SirenInboxIcon(),
        ),
      );
      await tester.pumpWidget(widget);
      SirenDataProvider.instance.iconController.sink
          .add(StreamResponse(null, UpdateEvents.PARAMS_CHANGED, ''));
      SirenDataProvider.instance.iconController.sink
          .add(StreamResponse(result, UpdateEvents.VIEW_ALL, ''));
      SirenDataProvider.instance.iconController.sink
          .add(StreamResponse(result, UpdateEvents.TOKEN_VERIFIED, ''));
    });

    testWidgets('Stream error', (WidgetTester tester) async {
      final result = ApiResponse()..isError = true;
      final errorFunc = MockFunction().call;
      final widget = MaterialApp(
        home: Scaffold(
          body: SirenInboxIcon(
            onError: (e) {
              errorFunc();
            },
          ),
        ),
      );
      await tester.pumpWidget(widget);

      SirenDataProvider.instance.iconController.sink
          .add(StreamResponse(result, UpdateEvents.VIEW_ALL, ''));
    });

    testWidgets('Theme', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: SirenInboxIcon(
            darkMode: true,
            theme: CustomThemeColors(notificationIconColor: Colors.amber),
          ),
        ),
      );
      await tester.pumpWidget(widget);

      final iconFinder = find.byWidgetPredicate(
        (widget) => widget is Icon && widget.color == Colors.amber,
      );

      expect(iconFinder, findsOneWidget);
    });
  });
}
