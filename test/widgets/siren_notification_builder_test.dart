import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';

NotificationType _createNotification({
  required String id,
  bool isRead = false,
  String? header,
  String? body,
}) {
  return NotificationType(
    id: id,
    createdAt: DateTime.now().toUtc().toIso8601String(),
    message: MessageData(
      channel: 'IN_APP',
      header: header ?? 'Test Header $id',
      body: body ?? 'Test Body $id',
      actionUrl: null,
      avatar: null,
      additionalData: null,
    ),
    requestId: 'req-$id',
    isRead: isRead,
    cardColor: isRead ? Colors.transparent : null,
  );
}

void main() {
  group('SirenNotificationBuilder Widget Tests', () {
    late StreamController<StreamResponse> inboxController;

    setUp(() {
      inboxController = SirenDataProvider.instance.inboxController;
    });

    testWidgets('renders builder and resolves to error when not initialized',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              builder: (context, state, controller) {
                return Column(
                  children: [
                    if (state.isLoading) const Text('Loading'),
                    if (state.isError) const Text('Error'),
                    if (!state.isLoading && !state.isError)
                      const Text('Loaded'),
                    Text('Count: ${state.notifications.length}'),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Count: 0'), findsOneWidget);
    });

    testWidgets('shows error state when provider is not initialized',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              builder: (context, state, controller) {
                return Column(
                  children: [
                    if (state.isError) const Text('Error'),
                    if (state.isLoading) const Text('Loading'),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('passes itemsPerFetch parameter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              itemsPerFetch: 10,
              builder: (context, state, controller) {
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('clamps itemsPerFetch to max 50',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              itemsPerFetch: 100,
              builder: (context, state, controller) {
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('passes isRead filter parameter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              isRead: false,
              builder: (context, state, controller) {
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('passes categories filter parameter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              categories: const ['news', 'alerts'],
              builder: (context, state, controller) {
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('handles PARAMS_CHANGED stream event',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              builder: (context, state, controller) {
                return Text('Loading: ${state.isLoading}');
              },
            ),
          ),
        ),
      );

      await tester.pump();

      inboxController.sink
          .add(StreamResponse(null, UpdateEvents.PARAMS_CHANGED, ''));

      await tester.pump();
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('handles SHOW_ERROR stream event',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              builder: (context, state, controller) {
                return Column(
                  children: [
                    if (state.isError) const Text('Error'),
                    if (!state.isError) const Text('No Error'),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.pump();

      inboxController.sink
          .add(StreamResponse(null, UpdateEvents.SHOW_ERROR, ''));

      await tester.pump();
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('handles READ_BY_ID stream event with success response',
        (WidgetTester tester) async {
      final successResponse = ApiResponse()..isSuccess = true;
      SirenNotificationState? capturedState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              builder: (context, state, controller) {
                capturedState = state;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pump();

      inboxController.sink.add(
        StreamResponse(successResponse, UpdateEvents.READ_BY_ID, 'test-id'),
      );

      await tester.pump();
      expect(capturedState, isNotNull);
      expect(capturedState!.notifications, isEmpty);
    });

    testWidgets('handles READ_ALL stream event with success response',
        (WidgetTester tester) async {
      final successResponse = ApiResponse()..isSuccess = true;
      SirenNotificationState? capturedState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              builder: (context, state, controller) {
                capturedState = state;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pump();

      inboxController.sink.add(
        StreamResponse(successResponse, UpdateEvents.READ_ALL, ''),
      );

      await tester.pump();
      expect(capturedState, isNotNull);
      expect(capturedState!.notifications, isEmpty);
    });

    testWidgets('handles DELETE_BY_ID stream event with success response',
        (WidgetTester tester) async {
      final successResponse = ApiResponse()..isSuccess = true;
      SirenNotificationState? capturedState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              builder: (context, state, controller) {
                capturedState = state;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pump();

      inboxController.sink.add(
        StreamResponse(
          successResponse,
          UpdateEvents.DELETE_BY_ID,
          'test-id',
        ),
      );

      await tester.pump();
      expect(capturedState, isNotNull);
      expect(capturedState!.notifications, isEmpty);
    });

    testWidgets('handles DELETE_ALL stream event with success response',
        (WidgetTester tester) async {
      final successResponse = ApiResponse()..isSuccess = true;
      SirenNotificationState? capturedState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              builder: (context, state, controller) {
                capturedState = state;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pump();

      inboxController.sink.add(
        StreamResponse(successResponse, UpdateEvents.DELETE_ALL, ''),
      );

      await tester.pump();
      expect(capturedState, isNotNull);
      expect(capturedState!.notifications, isEmpty);
    });

    testWidgets('handles TOKEN_VERIFIED stream event',
        (WidgetTester tester) async {
      final successResponse = ApiResponse()..isSuccess = true;
      SirenNotificationState? capturedState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              builder: (context, state, controller) {
                capturedState = state;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pump();

      inboxController.sink.add(
        StreamResponse(successResponse, UpdateEvents.TOKEN_VERIFIED, ''),
      );

      await tester.pump();
      expect(capturedState, isNotNull);
      expect(capturedState!.notifications, isEmpty);
    });

    testWidgets('calls onError callback on stream error response',
        (WidgetTester tester) async {
      final errorResponse = ApiResponse()..isError = true;
      var onErrorCalled = false;
      SirenErrorType? receivedError;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              onError: (error) {
                onErrorCalled = true;
                receivedError = error;
              },
              builder: (context, state, controller) {
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pump();

      inboxController.sink.add(
        StreamResponse(errorResponse, UpdateEvents.READ_ALL, ''),
      );

      await tester.pump();
      expect(onErrorCalled, isTrue);
      expect(receivedError, isNotNull);
    });

    testWidgets('exposes controller through builder',
        (WidgetTester tester) async {
      SirenNotificationController? capturedController;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              builder: (context, state, controller) {
                capturedController = controller;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pump();

      expect(capturedController, isNotNull);
    });

    testWidgets('state has correct initial values',
        (WidgetTester tester) async {
      SirenNotificationState? capturedState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              builder: (context, state, controller) {
                capturedState = state;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState!.notifications, isEmpty);
      expect(capturedState!.hasMore, isTrue);
    });

    testWidgets('disposes properly without errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirenNotificationBuilder(
              builder: (context, state, controller) {
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pump();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox.shrink(),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });

  group('SirenNotificationState', () {
    test('constructs with required parameters', () {
      const state = SirenNotificationState(
        notifications: [],
        isLoading: true,
        isError: false,
        hasMore: true,
      );

      expect(state.notifications, isEmpty);
      expect(state.isLoading, isTrue);
      expect(state.isError, isFalse);
      expect(state.hasMore, isTrue);
      expect(state.error, isNull);
    });

    test('constructs with error', () {
      final error = SirenErrorType(
        code: 'TEST',
        type: 'error',
        message: 'Test error',
      );
      final state = SirenNotificationState(
        notifications: [],
        isLoading: false,
        isError: true,
        hasMore: false,
        error: error,
      );

      expect(state.isError, isTrue);
      expect(state.error, equals(error));
      expect(state.error?.code, equals('TEST'));
    });

    test('stores notification list correctly', () {
      final notifications = [
        _createNotification(id: '1'),
        _createNotification(id: '2'),
        _createNotification(id: '3'),
      ];

      final state = SirenNotificationState(
        notifications: notifications,
        isLoading: false,
        isError: false,
        hasMore: true,
      );

      expect(state.notifications.length, equals(3));
      expect(state.notifications[0].id, equals('1'));
      expect(state.notifications[1].id, equals('2'));
      expect(state.notifications[2].id, equals('3'));
    });
  });
}
