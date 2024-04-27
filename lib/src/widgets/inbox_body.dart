import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/theme/app_theme.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/empty_widget.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/error_widget.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/loader_widget.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/notification_list_view.dart';

class InboxBody extends StatelessWidget {
  const InboxBody({
    required this.isLoading,
    required this.loadingNextPage,
    required this.isError,
    required this.notifications,
    required this.deleteNotification,
    required this.markAsRead,
    required this.customCard,
    required this.onCardClick,
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
    this.cardParams,
    this.listEmptyWidget,
    this.colors,
    this.isDarkMode,
    super.key,
  });
  final CustomThemeColors? colors;
  final bool isLoading;
  final bool loadingNextPage;
  final bool isError;
  final List<NotificationType> notifications;
  final Future<void> Function(String) deleteNotification;
  final void Function(String) markAsRead;
  final Widget Function(NotificationType)? customCard;
  final void Function(NotificationType)? onCardClick;
  final String? deletingNotificationId;
  final bool disableAutoMarkAsRead;
  final int totalElements;
  final Future<void> Function() onRefresh;
  final Widget? customErrorWidget;
  final Widget? customLoader;
  final bool endReached;
  final CustomStyles? customStyles;
  final CardParams? cardParams;
  final VoidCallback onEndReached;
  final ScrollController scrollController;
  final Widget? listEmptyWidget;
  final bool? isDarkMode;

  @override
  Widget build(BuildContext context) {
    final defaultColors = SirenAppTheme.colors(isDarkMode: isDarkMode ?? false);
    if (isError) {
      return RefreshIndicator(
        color: colors?.loaderColor ?? defaultColors.loadingIndicator,
        backgroundColor: defaultColors.loadingIndicatorBackground,
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Semantics(
              label: 'siren-error-state',
              hint: 'Notification error state',
              child: SizedBox(
                key: const Key('siren-error-state'),
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: customErrorWidget ??
                      DefaultErrorWidget(
                        isDarkMode: isDarkMode,
                      ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (isLoading && !loadingNextPage) {
      return LoaderWidget(
        customLoader: customLoader,
        hideAvatar: cardParams?.hideAvatar ?? false,
        isDarkMode: isDarkMode,
      );
    } else if (notifications.isEmpty) {
      return Semantics(
        label: 'siren-empty-state',
        hint: 'Empty notification list',
        key: const Key('siren-empty-state'),
        child: listEmptyWidget ?? EmptyWidget(isDarkMode: isDarkMode),
      );
    } else {
      return Container(
        decoration: customStyles?.container?.decoration,
        padding: customStyles?.container?.padding,
        child: NotificationListView(
          notifications: notifications,
          isLoading: isLoading,
          endReached: endReached,
          onRefresh: onRefresh,
          onEndReached: onEndReached,
          loadingNextPage: loadingNextPage,
          customStyles: customStyles,
          scrollController: scrollController,
          onDelete: deleteNotification,
          markAsRead: markAsRead,
          customCard: customCard,
          onCardClick: onCardClick,
          deletingNotificationId: deletingNotificationId,
          totalElements: totalElements,
          cardParams: cardParams,
          loadingIndicator:
              colors?.loaderColor ?? defaultColors.loadingIndicator,
          isDarkMode: isDarkMode,
        ),
      );
    }
  }
}
