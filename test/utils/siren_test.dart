// ignore_for_file: cascade_invocations

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/api/notifications_bulk_update.dart';
import 'package:sirenapp_flutter_inbox/src/api/read_notification_by_id.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';

class MockReadNotificationById extends Mock implements ReadNotificationById {
  @override
  Future<ApiResponse> readNotificationById({
    required String notificationId,
  }) {
    final result = ApiResponse()..data = 'SUCCESS';
    result.error = null;
    return Future(() => result);
  }
}

class MockNotificationsBulkUpdate extends Mock
    implements NotificationsBulkUpdate {
  @override
  Future<ApiResponse> notificationsBulkUpdate(
      {required Map<String, dynamic> data, required String operation,}) {
    final result = ApiResponse()..data = 'SUCCESS';
    result.error = null;
    return Future(() => result);
  }
}

class MockSirenDataProvider extends Mock implements SirenDataProvider {}

void main() {
  late MockReadNotificationById mockReadNotificationById;
  late MockNotificationsBulkUpdate mockMockNotificationsBulkUpdate;

  setUp(() {
    mockReadNotificationById = MockReadNotificationById();
    mockMockNotificationsBulkUpdate = MockNotificationsBulkUpdate();
  });

  test(
      'markAsRead method should call ReadNotificationById and update inboxController',
      () async {
    const notificationId = 'notification_id';
    final mockResponse = ApiResponse(data: 'SUCCESS');
    final response = await mockReadNotificationById.readNotificationById(
      notificationId: notificationId,
    );

    expect(mockResponse.data, response.data);
  });

  test(
      'mark notifications as read by a specific date and  update inboxController',
      () async {
    const startDate = '2024-03-15T04:07:14.577928Z';
    final mockData = {
      'until': startDate,
      'operation': BulkUpdateType.MARK_AS_READ.name,
    };
    final mockResponse = ApiResponse(data: 'SUCCESS');
    final response =
        await mockMockNotificationsBulkUpdate.notificationsBulkUpdate(
            data: mockData, operation: BulkUpdateType.MARK_AS_READ.name,);

    expect(mockResponse.data, response.data);
  });
}
