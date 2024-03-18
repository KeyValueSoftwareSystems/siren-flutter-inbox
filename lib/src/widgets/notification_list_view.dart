import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/widgets/card.dart';

class NotificationListView extends StatelessWidget {
  const NotificationListView({
    required this.notifications,
    required this.isLoading,
    required this.endReached,
    required this.onRefresh,
    required this.onEndReached,
    required this.loadingNextPage,
    required this.customStyles,
    required this.hideAvatar,
    required this.deleteWidget,
    required this.scrollController,
    required this.onDelete,
    required this.markAsRead,
    this.customNotificationCard,
    this.onNotificationCardClick,
    this.deletingNotificationId,
    this.customLoader,
    this.disableAutoMarkAsRead,
    super.key,
  });

  final List<NotificationDataType> notifications;
  final bool isLoading;
  final bool endReached;
  final bool loadingNextPage;
  final Future<void> Function() onRefresh;
  final VoidCallback onEndReached;
  final SirenStyleProps? customStyles;
  final bool? hideAvatar;
  final Widget? deleteWidget;
  final ScrollController scrollController;
  final Future<void> Function(String) onDelete;
  final void Function(String) markAsRead;
  final Widget Function(NotificationDataType)? customNotificationCard;
  final void Function(NotificationDataType)? onNotificationCardClick;
  final String? deletingNotificationId;
  final Widget? customLoader;
  final bool? disableAutoMarkAsRead;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.secondary,
      backgroundColor: Theme.of(context).colorScheme.primary,
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: notifications.length + (endReached ? 0 : 1),
        itemBuilder: (context, index) {
          if (index < notifications.length) {
            final itemWidget =
                customNotificationCard?.call(notifications[index]) ??
                    CardWidget(
                      onTap: (notification) {
                        if (!(disableAutoMarkAsRead ?? false)) {
                          markAsRead(notifications[index].id ?? '');
                        }
                        onNotificationCardClick?.call(notifications[index]);
                      },
                      notification: notifications[index],
                      cardProps: CardProps(
                        hideAvatar: hideAvatar,
                        showMedia: true,
                      ),
                      styles: customStyles,
                      deleteWidget: deleteWidget,
                      onDelete: onDelete,
                    );
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity:
                  deletingNotificationId == notifications[index].id ? 0.0 : 1.0,
              child: itemWidget,
            );
          } else {
            return loadingNextPage
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
                : const SizedBox();
          }
        },
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
      ),
    );
  }
}
