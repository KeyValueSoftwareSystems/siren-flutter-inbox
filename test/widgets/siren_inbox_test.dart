import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/api/fetch_unviewed_notification_count.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/models/ui_models.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/loader_widget.dart';

import 'siren_inbox_test.mocks.dart';

class MockFunction extends Mock {
  // Define the mock function signature
  void call(); // You can define parameters and return types as needed
}

@GenerateNiceMocks([
  MockSpec<SirenDataProvider>(),
  MockSpec<FetchUnViewedNotificationsCount>(),
])
void main() {
  group('SirenInbox Widget Test', () {
    late StreamController<StreamResponse> iconController;
    late StreamController<StreamResponse> inboxController;
    late MockSirenDataProvider mockSirenDataProvider;

    setUp(() {
      iconController = StreamController<StreamResponse>.broadcast();
      inboxController = StreamController<StreamResponse>.broadcast();
      mockSirenDataProvider = MockSirenDataProvider();
      when(mockSirenDataProvider.tokenVerificationStatus)
          .thenReturn(Status.SUCCESS);
    });

    tearDown(() {
      iconController.close();
      inboxController.close();
    });
    testWidgets('Initial loading state', (WidgetTester tester) async {
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

    testWidgets('Test Title', (WidgetTester tester) async {
      // Mock SirenDataProvider

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenInbox(
              inboxHeaderProps: InboxHeaderProps(
                title: 'Notifications Header',
              ),
              darkMode: true,
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

    testWidgets('Back navigation', (WidgetTester tester) async {
      var backButtonPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenInbox(
              inboxHeaderProps: InboxHeaderProps(
                showBackButton: true,
                handleBackNavigation: () {
                  backButtonPressed = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      expect(backButtonPressed, true);
    });

    testWidgets('Test theme', (WidgetTester tester) async {
      // Mock SirenDataProvider

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenInbox(
              theme: CustomThemeColors(backgroundColor: Colors.amber),
            ),
          ),
        ),
      );

      final scaffoldFinder = find.byType(Scaffold).at(1);

      final scaffoldWidget = tester.widget<Scaffold>(scaffoldFinder);
      final scaffoldBackgroundColor = scaffoldWidget.backgroundColor;
      expect(scaffoldBackgroundColor, equals(Colors.amber));

      await tester.pump();
    });

    testWidgets('Stream', (WidgetTester tester) async {
      final result = ApiResponse()..isSuccess = true;
      const widget = MaterialApp(
        home: Scaffold(
          body: SirenInbox(),
        ),
      );
      await tester.pumpWidget(widget);
      SirenDataProvider.instance.inboxController.sink
          .add(StreamResponse(null, UpdateEvents.PARAMS_CHANGED, ''));
      SirenDataProvider.instance.inboxController.sink
          .add(StreamResponse(null, UpdateEvents.SHOW_ERROR, ''));
      SirenDataProvider.instance.inboxController.sink
          .add(StreamResponse(result, UpdateEvents.DELETE_ALL, ''));
      SirenDataProvider.instance.inboxController.sink
          .add(StreamResponse(result, UpdateEvents.TOKEN_VERIFIED, ''));
      SirenDataProvider.instance.inboxController.sink
          .add(StreamResponse(result, UpdateEvents.READ_ALL, ''));
    });

    testWidgets('Stream error', (WidgetTester tester) async {
      final result = ApiResponse()..isError = true;
      final errorFunc = MockFunction().call;
      final widget = MaterialApp(
        home: Scaffold(
          body: SirenInbox(
            onError: (e) {
              errorFunc();
            },
          ),
        ),
      );
      await tester.pumpWidget(widget);

      SirenDataProvider.instance.inboxController.sink
          .add(StreamResponse(result, UpdateEvents.READ_ALL, ''));
    });
  });
}
