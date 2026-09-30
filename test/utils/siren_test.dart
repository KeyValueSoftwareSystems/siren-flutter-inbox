import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/models/api_response.dart';
import 'package:sirenapp_flutter_inbox/src/utils/siren.dart';

void main() {
  group('Siren', () {
    test('markAsReadById should mark a notification as read', () async {
      const id = 'notification_id';

      final result = await Siren.markAsReadById(id: id);

      expect(result, isNotNull);
    });

    test(
        'markAsReadByDate should mark notifications as read until a specific date',
        () async {
      const startDate = '2022-01-01T00:00:00Z';

      final result = await Siren.markAsReadByDate(startDate: startDate);

      expect(result, isNotNull);
    });

    test(
        'markAllAsViewed should mark all notifications as viewed until a specific date',
        () async {
      const startDate = '2022-01-01T00:00:00Z';

      final result = await Siren.markAllAsViewed(startDate: startDate);

      expect(result, isNotNull);
    });

    test('deleteById should delete a notification by its ID', () async {
      const id = 'notification_id';

      final result = await Siren.deleteById(id: id);

      expect(result, isNotNull);
    });

    test('deleteByDate should delete notifications until a specific date',
        () async {
      const startDate = '2022-01-01T00:00:00Z';

      final result = await Siren.deleteByDate(startDate: startDate);

      expect(result, isNotNull);
    });
  });

  group('SirenNotificationResult', () {
    test('isSuccess returns true when error is null', () {
      const result = SirenNotificationResult(notifications: []);

      expect(result.isSuccess, isTrue);
      expect(result.error, isNull);
      expect(result.notifications, isEmpty);
    });

    test('isSuccess returns false when error is present', () {
      final error = SirenErrorType(
        code: 'TEST_ERROR',
        type: 'error',
        message: 'Test error message',
      );
      final result = SirenNotificationResult(
        notifications: [],
        error: error,
      );

      expect(result.isSuccess, isFalse);
      expect(result.error, equals(error));
      expect(result.error?.code, equals('TEST_ERROR'));
      expect(result.error?.message, equals('Test error message'));
    });

    test('notifications list is correctly stored', () {
      const result = SirenNotificationResult(notifications: []);

      expect(result.notifications, isA<List>());
      expect(result.notifications, isEmpty);
    });
  });

  group('Siren.fetchNotifications', () {
    test('returns result with empty list when token is not verified', () async {
      final result = await Siren.fetchNotifications();

      expect(result, isA<SirenNotificationResult>());
      expect(result.notifications, isEmpty);
    });

    test('accepts optional parameters', () async {
      final result = await Siren.fetchNotifications(
        size: 10,
        isRead: false,
        start: '2022-01-01T00:00:00Z',
        end: '2022-12-31T23:59:59Z',
        categories: ['category1', 'category2'],
      );

      expect(result, isA<SirenNotificationResult>());
      expect(result.notifications, isEmpty);
    });
  });

  group('Siren.notificationStream', () {
    test('returns a stream from the inbox controller', () {
      final stream = Siren.notificationStream;

      expect(stream, isA<Stream<StreamResponse>>());
    });

    test('stream receives events added to the inbox controller', () async {
      final response = ApiResponse()..isSuccess = true;
      final streamResponse =
          StreamResponse(response, UpdateEvents.READ_BY_ID, 'test-id');

      final future = expectLater(
        Siren.notificationStream,
        emits(isA<StreamResponse>()),
      );

      SirenDataProvider.instance.inboxController.sink.add(streamResponse);

      await future;
    });
  });
}
