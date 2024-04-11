import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/card.dart';

class NotificationListView extends StatefulWidget {
  const NotificationListView({
    required this.notifications,
    required this.isLoading,
    required this.endReached,
    required this.onRefresh,
    required this.onEndReached,
    required this.loadingNextPage,
    required this.customStyles,
    required this.scrollController,
    required this.onDelete,
    required this.markAsRead,
    this.customNotificationCard,
    this.onNotificationCardClick,
    this.deletingNotificationId,
    this.totalElements,
    this.cardProps,
    super.key,
  });

  final List<NotificationDataType> notifications;
  final bool isLoading;
  final bool endReached;
  final bool loadingNextPage;
  final Future<void> Function() onRefresh;
  final VoidCallback onEndReached;
  final SirenStyleProps? customStyles;
  final ScrollController scrollController;
  final Future<void> Function(String) onDelete;
  final void Function(String) markAsRead;
  final Widget Function(NotificationDataType)? customNotificationCard;
  final void Function(NotificationDataType)? onNotificationCardClick;
  final String? deletingNotificationId;
  final int? totalElements;
  final CardProps? cardProps;

  @override
  State<NotificationListView> createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView> {
  final GlobalKey _listViewKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  void _afterLayout(_) {
    _getPositions();
  }

  void _getPositions() {
    final renderObject = _listViewKey.currentContext?.findRenderObject();
    final deviceHeight = MediaQuery.of(context).size.height;
    if (renderObject is RenderBox) {
      final renderBox = renderObject;
      final position = renderBox.localToGlobal(Offset.zero);
      if (position.dy < deviceHeight) {
        widget.onEndReached();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.secondary,
      backgroundColor: Theme.of(context).colorScheme.primary,
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        itemCount: widget.notifications.length + (widget.endReached ? 0 : 1),
        itemBuilder: (context, index) {
          if (index < widget.notifications.length) {
            final isLastIndex = index == widget.notifications.length - 1;
            final currentNotification = widget.notifications[index];
            final itemWidget = widget.customNotificationCard
                    ?.call(currentNotification) ??
                CardWidget(
                  onTap: (notification) {
                    if (!(widget.cardProps?.disableAutoMarkAsRead ?? false)) {
                      widget.markAsRead(currentNotification.id);
                    }
                    widget.onNotificationCardClick?.call(currentNotification);
                  },
                  notification: currentNotification,
                  cardProps: widget.cardProps ?? const CardProps(),
                  styles: widget.customStyles,
                  onDelete: widget.onDelete,
                );
            return AnimatedOpacity(
              key:
                  isLastIndex ? _listViewKey : ValueKey(currentNotification.id),
              duration: const Duration(milliseconds: 500),
              opacity: widget.deletingNotificationId == currentNotification.id
                  ? 0.0
                  : 1.0,
              child: itemWidget,
            );
          } else {
            return widget.loadingNextPage
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
        controller: widget.scrollController,
      ),
    );
  }
}
