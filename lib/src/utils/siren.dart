import 'package:siren_flutter_inbox/src/api/delete_notification_by_id.dart';
import 'package:siren_flutter_inbox/src/api/mark_all_notifications_as_viewed.dart';
import 'package:siren_flutter_inbox/src/api/notifications_bulk_update.dart';
import 'package:siren_flutter_inbox/src/api/read_notification_by_id.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';

class Siren {
  static Future<ApiResponse> markAsRead({
    required String id,
  }) async {
    final response = await ReadNotificationById.instance
        .readNotificationById(notificationId: id);
    SirenDataProvider.instance.controller.sink
        .add(StreamResponse(response, UpdateEvents.READ_BY_ID, id));
    return response;
  }

  static Future<ApiResponse> markNotificationsAsReadByDate({
    required String untilDate,
  }) async {
    final data = {
      'until': untilDate,
      'operation': BulkUpdateType.MARK_AS_READ.name,
    };
    final response =
        await NotificationsBulkUpdate.notificationsBulkUpdate(data: data);
    SirenDataProvider.instance.controller.sink
        .add(StreamResponse(response, UpdateEvents.READ_ALL, ''));
    return response;
  }

  static Future<ApiResponse> markNotificationsAsViewed({
    required String untilDate,
  }) async {
    final response =
        await MarkAllNotificationsAsViewed.markAllNotificationsAsViewed(
      untilDate: untilDate,
    );
    SirenDataProvider.instance.controller.sink
        .add(StreamResponse(response, UpdateEvents.VIEW_ALL, ''));
    return response;
  }

  static Future<ApiResponse> deleteNotification({
    required String id,
  }) async {
    final response = await DeleteNotificationById.instance
        .deleteNotificationById(notificationId: id);
    SirenDataProvider.instance.controller.sink
        .add(StreamResponse(response, UpdateEvents.DELETE_BY_ID, id));
    return response;
  }

  static Future<ApiResponse> deleteNotificationByDate({
    required String untilDate,
  }) async {
    final data = {
      'until': untilDate,
      'operation': BulkUpdateType.MARK_AS_DELETED.name,
    };
    final response =
        await NotificationsBulkUpdate.notificationsBulkUpdate(data: data);
    SirenDataProvider.instance.controller.sink
        .add(StreamResponse(response, UpdateEvents.DELETE_ALL, ''));
    return response;
  }
}
