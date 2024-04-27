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
    this.customCard,
    this.onCardClick,
    this.deletingNotificationId,
    this.totalElements,
    this.cardParams,
    this.loadingIndicator,
    this.isDarkMode,
    this.colors,
    super.key,
  });

  final List<NotificationType> notifications;
  final bool isLoading;
  final bool endReached;
  final bool loadingNextPage;
  final Future<void> Function() onRefresh;
  final VoidCallback onEndReached;
  final CustomStyles? customStyles;
  final ScrollController scrollController;
  final Future<void> Function(String) onDelete;
  final void Function(String) markAsRead;
  final Widget Function(NotificationType)? customCard;
  final void Function(NotificationType)? onCardClick;
  final String? deletingNotificationId;
  final int? totalElements;
  final CardParams? cardParams;
  final Color? loadingIndicator;
  final bool? isDarkMode;
  final CustomThemeColors? colors;

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

  void _afterLayout(dynamic _) {
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
      color: widget.loadingIndicator ?? Theme.of(context).colorScheme.secondary,
      backgroundColor: Theme.of(context).colorScheme.primary,
      onRefresh: widget.onRefresh,
      child: Semantics(
        label: 'siren-notification-list',
        hint: 'Swipe up or down to view notifications',
        child: ListView.builder(
          key: const Key('siren-notification-list'),
          itemCount: widget.notifications.length + (widget.endReached ? 0 : 1),
          itemBuilder: (context, index) {
            if (index < widget.notifications.length) {
              final isLastIndex = index == widget.notifications.length - 1;
              final currentNotification = widget.notifications[index];
              final itemWidget = widget.customCard?.call(currentNotification) ??
                  CardWidget(
                    onTap: (NotificationType notification) {
                      if (!(widget.cardParams?.disableAutoMarkAsRead ??
                          false)) {
                        widget.markAsRead(currentNotification.id);
                      }
                      widget.onCardClick?.call(currentNotification);
                    },
                    notification: currentNotification,
                    cardParams: widget.cardParams ?? const CardParams(),
                    styles: widget.customStyles,
                    onDelete: widget.onDelete,
                    isDarkMode: widget.isDarkMode,
                    colors: widget.colors,
                  );
              return AnimatedOpacity(
                key: isLastIndex
                    ? _listViewKey
                    : ValueKey(currentNotification.id),
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
                          color: widget.loadingIndicator ??
                              Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    )
                  : const SizedBox();
            }
          },
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.scrollController,
        ),
      ),
    );
  }
}
