import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/error_widget.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/loader_widget.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/notification_list_view.dart';

class InboxBody extends StatelessWidget {
  const InboxBody({
    required this.currentTheme,
    required this.isLoading,
    required this.loadingNextPage,
    required this.isError,
    required this.notifications,
    required this.deleteNotification,
    required this.markAsRead,
    required this.customNotificationCard,
    required this.onNotificationCardClick,
    required this.deletingNotificationId,
    required this.disableAutoMarkAsRead,
    required this.totalElements,
    required this.onRefresh,
    required this.endReached,
    required this.onEndReached,
    required this.scrollController,
    this.customErrorWidget,
    this.customLoader,
    this.customStyles,
    this.cardProps,
    super.key,
  });
  final ThemeData currentTheme;
  final bool isLoading;
  final bool loadingNextPage;
  final bool isError;
  final List<NotificationDataType> notifications;
  final Future<void> Function(String) deleteNotification;
  final void Function(String) markAsRead;
  final Widget Function(NotificationDataType)? customNotificationCard;
  final void Function(NotificationDataType)? onNotificationCardClick;
  final String? deletingNotificationId;
  final bool disableAutoMarkAsRead;
  final int totalElements;
  final Future<void> Function() onRefresh;
  final Widget? customErrorWidget;
  final Widget? customLoader;
  final bool endReached;
  final SirenStyleProps? customStyles;
  final CardProps? cardProps;
  final VoidCallback onEndReached;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (isError) {
      return RefreshIndicator(
        color: currentTheme.colorScheme.secondary,
        backgroundColor: currentTheme.colorScheme.primary,
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: customErrorWidget ?? const DefaultErrorWidget(),
              ),
            ),
          ],
        ),
      );
    } else if (isLoading && !loadingNextPage) {
      return LoaderWidget(customLoader: customLoader);
    } else {
      return NotificationListView(
        notifications: notifications,
        isLoading: isLoading,
        endReached: endReached,
        onRefresh: onRefresh,
        onEndReached: onEndReached,
        loadingNextPage: loadingNextPage,
        customStyles: customStyles,
        deleteWidget: cardProps?.deleteWidget,
        hideAvatar: cardProps?.hideAvatar,
        scrollController: scrollController,
        onDelete: deleteNotification,
        markAsRead: markAsRead,
        customNotificationCard: customNotificationCard,
        onNotificationCardClick: onNotificationCardClick,
        deletingNotificationId: deletingNotificationId,
        disableAutoMarkAsRead: disableAutoMarkAsRead,
        totalElements: totalElements,
      );
    }
  }
}
