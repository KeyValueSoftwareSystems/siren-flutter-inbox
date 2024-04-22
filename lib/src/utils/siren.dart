import 'package:sirenapp_flutter_inbox/src/api/delete_notification_by_id.dart';
import 'package:sirenapp_flutter_inbox/src/api/mark_all_notifications_as_viewed.dart';
import 'package:sirenapp_flutter_inbox/src/api/notifications_bulk_update.dart';
import 'package:sirenapp_flutter_inbox/src/api/read_notification_by_id.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/models/api_response.dart';

class Siren {
  /// Marks a notification as read by its ID.
  /// [id] is the notification id to be mark as read.
  /// Returns the response from the API call.
  static Future markAsRead({
    required String id,
  }) async {
    final response = await ReadNotificationById.instance
        .readNotificationById(notificationId: id);
    SirenDataProvider.instance.inboxController.sink
        .add(StreamResponse(response, UpdateEvents.READ_BY_ID, id));
    return response.rawResponse;
  }

  /// Marks notifications as read by date until a specific date.
  /// [startDate] is the date until a specific date in the format "yyyy-MM-dd'T'HH:mm:ss'Z'".
  /// Returns the response from the API call.
  static Future markAsReadByDate({
    required String startDate,
  }) async {
    final data = {
      'until': startDate,
      'operation': BulkUpdateType.MARK_AS_READ.name,
    };
    final response =
        await NotificationsBulkUpdate.instance.notificationsBulkUpdate(
      data: data,
      operation: BulkUpdateType.MARK_AS_READ.name,
    );
    SirenDataProvider.instance.inboxController.sink
        .add(StreamResponse(response, UpdateEvents.READ_ALL, ''));
    return response.rawResponse;
  }

  /// Marks notifications as viewed until a specific date.
  /// [startDate] is the date until a specific date in the format "yyyy-MM-dd'T'HH:mm:ss'Z'".
  /// Returns the response from the API call.
  static Future markAllAsViewed({
    required String startDate,
  }) async {
    final response = await MarkAllNotificationsAsViewed.instance
        .markAllNotificationsAsViewed(untilDate: startDate);
    SirenDataProvider.instance.inboxController.sink
        .add(StreamResponse(response, UpdateEvents.VIEW_ALL, ''));
    return response.rawResponse;
  }

  /// Deletes a notification by its ID.
  /// [id] is the notification id to be deleted.
  /// Returns the response from the API call.
  static Future deleteById({
    required String id,
  }) async {
    final response = await DeleteNotificationById.instance
        .deleteNotificationById(notificationId: id);
    SirenDataProvider.instance.inboxController.sink
        .add(StreamResponse(response, UpdateEvents.DELETE_BY_ID, id));
    return response.rawResponse;
  }

  /// Deletes notifications by date until a specific date.
  /// [startDate] is the date until a specific date in the format "yyyy-MM-dd'T'HH:mm:ss'Z'".
  /// Returns the response from the API call.
  static Future deleteNotificationByDate({
    required String startDate,
  }) async {
    final data = {
      'until': startDate,
      'operation': BulkUpdateType.MARK_AS_DELETED.name,
    };
    final response =
        await NotificationsBulkUpdate.instance.notificationsBulkUpdate(
      data: data,
      operation: BulkUpdateType.MARK_AS_DELETED.name,
    );
    SirenDataProvider.instance.inboxController.sink
        .add(StreamResponse(response, UpdateEvents.DELETE_ALL, ''));
    return response.rawResponse;
  }
}
