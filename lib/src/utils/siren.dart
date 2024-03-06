import 'package:siren_flutter_inbox/src/api/mark_all_notifications_as_viewed.dart';
import 'package:siren_flutter_inbox/src/api/notifications_bulk_update.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';

class Siren {
  static Future<dynamic> markAsRead({
    required String id,
  }) async {
    // TODO
  }

  static Future<dynamic> markNotificationsAsReadByDate({
    required String untilDate,
  }) async {
    final data = {
      'until': untilDate,
      'operation': BulkUpdateType.MARK_AS_READ.name,
    };
    return NotificationsBulkUpdate.notificationsBulkUpdate(data: data);
  }

  static Future<dynamic> markNotificationsAsViewed({
    required String untilDate,
  }) async {
    return MarkAllNotificationsAsViewed.markAllNotificationsAsViewed(
      untilDate: untilDate,
    );
  }

  static Future<dynamic> deleteNotification({
    required String id,
  }) async {
    // TODO
  }

  static Future<ApiResponse> deleteNotificationByDate({
    required String untilDate,
  }) async {
    final data = {
      'until': untilDate,
      'operation': BulkUpdateType.MARK_AS_DELETED.name,
    };
    return NotificationsBulkUpdate.notificationsBulkUpdate(data: data);
  }
}
