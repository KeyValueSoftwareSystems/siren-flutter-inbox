import 'dart:async';

import 'package:sirenapp_flutter_inbox/src/api/delete_notification_by_id.dart';
import 'package:sirenapp_flutter_inbox/src/api/fetch_all_notification.dart';
import 'package:sirenapp_flutter_inbox/src/api/mark_all_notifications_as_viewed.dart';
import 'package:sirenapp_flutter_inbox/src/api/notifications_bulk_update.dart';
import 'package:sirenapp_flutter_inbox/src/api/read_notification_by_id.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/models/api_response.dart';
import 'package:sirenapp_flutter_inbox/src/models/notification_model.dart';

/// The result of a notification fetch operation.
class SirenNotificationResult {
  /// Constructs a [SirenNotificationResult].
  const SirenNotificationResult({
    required this.notifications,
    this.error,
  });

  /// The list of fetched notifications.
  final List<NotificationType> notifications;

  /// The error, if the fetch failed.
  final SirenErrorType? error;

  /// Whether the fetch was successful.
  bool get isSuccess => error == null;
}

class Siren {
  /// Fetches a list of notifications.
  ///
  /// [size] — number of notifications per page (default 20, max 50).
  /// [isRead] — filter by read status. `null` returns all.
  /// [start] — ISO 8601 date string; fetch notifications created after this.
  /// [end] — ISO 8601 date string; fetch notifications created before this.
  /// [categories] — optional list of category strings to filter by.
  ///
  /// Returns a [SirenNotificationResult] containing the list and any error.
  static Future<SirenNotificationResult> fetchNotifications({
    int? size,
    bool? isRead,
    String? start,
    String? end,
    List<String>? categories,
  }) async {
    final validatedSize = (size ?? 20).clamp(1, 50);
    final response = await FetchAllNotifications.instance.fetchAllNotifications(
      size: validatedSize,
      isRead: isRead,
      start: start,
      end: end,
      categories: categories,
    );
    if (response.isSuccess) {
      final list = response.data as Iterable<NotificationType>? ?? [];
      return SirenNotificationResult(notifications: list.toList());
    }
    return SirenNotificationResult(
      notifications: [],
      error: response.error,
    );
  }

  /// A broadcast stream of [StreamResponse] events for inbox updates.
  ///
  /// Listen to this stream to react to read, delete, and view
  /// operations performed on notifications.
  static Stream<StreamResponse> get notificationStream =>
      SirenDataProvider.instance.inboxController.stream;

  /// Marks a notification as read by its ID.
  /// [id] is the notification id to be mark as read.
  /// Returns the response from the API call.
  static Future markAsReadById({
    required String id,
  }) async {
    final response = await ReadNotificationById.instance
        .readNotificationById(notificationId: id);
    SirenDataProvider.instance.inboxController.sink
        .add(StreamResponse(response, UpdateEvents.READ_BY_ID, id));
    return response.isError ? response.error : response.rawResponse;
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
    return response.isError ? response.error : response.rawResponse;
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
    return response.isError ? response.error : response.rawResponse;
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
    return response.isError ? response.error : response.rawResponse;
  }

  /// Deletes notifications by date until a specific date.
  /// [startDate] is the date until a specific date in the format "yyyy-MM-dd'T'HH:mm:ss'Z'".
  /// Returns the response from the API call.
  static Future deleteByDate({
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
    return response.isError ? response.error : response.rawResponse;
  }
}
