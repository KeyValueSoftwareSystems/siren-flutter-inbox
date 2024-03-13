import 'dart:async';

import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/api/delete_notification_by_id.dart';
import 'package:siren_flutter_inbox/src/api/fetch_all_notification.dart';
import 'package:siren_flutter_inbox/src/api/mark_all_notifications_as_viewed.dart';
import 'package:siren_flutter_inbox/src/api/read_notification_by_id.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:siren_flutter_inbox/src/theme/app_theme.dart';
import 'package:siren_flutter_inbox/src/widgets/card.dart';
import 'package:siren_flutter_inbox/src/widgets/empty_widget.dart';
import 'package:siren_flutter_inbox/src/widgets/error_widget.dart';
import 'package:siren_flutter_inbox/src/widgets/loader_widget.dart';

class SirenWindow extends StatefulWidget {
  const SirenWindow({
    super.key,
    this.customStyles,
    this.hideAvatar,
    this.deleteWidget,
    this.showWindowHeader,
    this.customEmptyWidget,
    this.windowHeaderText,
    this.windowHeaderTextStyle,
    this.pageSize,
    this.showHeaderBackButton,
    this.headerIconTheme,
    this.isCenterTitle,
    this.buildCardWidget,
    this.onCardClick,
    this.onFetchNotificationsError,
    this.onDeletionError,
    this.onReadError,
    this.onBulkDeletionError,
    this.onMarkAsViewedApiError,
    this.hideClearAll,
    this.customHeaderSuffixCTA,
    this.isDarkMode,
    this.customTheme,
    this.customLoader,
  });

  final SirenStyleProps? customStyles;
  final bool? hideAvatar;
  final Widget? deleteWidget;
  final bool? showWindowHeader;
  final Widget? customEmptyWidget;
  final String? windowHeaderText;
  final TextStyle? windowHeaderTextStyle;
  final int? pageSize;
  final bool? showHeaderBackButton;
  final IconThemeData? headerIconTheme;
  final bool? isCenterTitle;
  final Widget Function(NotificationDataType)? buildCardWidget;
  final void Function(NotificationDataType)? onCardClick;
  final void Function(ApiErrorDetails)? onFetchNotificationsError;
  final void Function(ApiErrorDetails)? onDeletionError;
  final void Function(ApiErrorDetails)? onReadError;
  final void Function(ApiErrorDetails)? onBulkDeletionError;
  final void Function(ApiErrorDetails)? onMarkAsViewedApiError;
  final bool? hideClearAll;
  final List<Widget>? customHeaderSuffixCTA;
  final bool? isDarkMode;
  final CustomThemeColors? customTheme;
  final Widget? customLoader;

  @override
  _SirenWindowState createState() => _SirenWindowState();
}

class _SirenWindowState extends State<SirenWindow> {
  late ScrollController _scrollController;
  bool isLoading = false;
  bool endReached = false;
  bool isError = false;
  bool loadingNextPage = false;
  int currentPage = 0;
  late int totalPages;
  late int totalElements;

  List<NotificationDataType> notifications = [];
  late final DeleteNotificationById _deleteNotificationById;
  late final ReadNotificationById _readNotificationById;
  late Timer? _periodicUpdateRef;
  late StreamSubscription<StreamResponse> _subscription;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _deleteNotificationById = DeleteNotificationById.instance;
    _readNotificationById = ReadNotificationById.instance;
    fetchNotifications();
    _subscribeToStream();
  }

  @override
  void dispose() {
    markAllNotificationsAsViewed();
    _scrollController.dispose();
    _periodicUpdateRef?.cancel();
    _subscription.cancel();
    SirenDataProvider.instance.dispose();
    super.dispose();
  }

  void _subscribeToStream() {
    _subscription = SirenDataProvider.instance.controller.stream.listen(
      (streamResponse) {
        if (streamResponse.response?.isSuccess ?? false) {
          switch (streamResponse.api) {
            case UpdateEvents.READ_BY_ID:
              _markNotificationAsReadById(streamResponse.id);
            case UpdateEvents.READ_ALL:
              _markAllNotificationsAsRead();
            case UpdateEvents.DELETE_BY_ID:
              _deleteById(streamResponse.id);
            case UpdateEvents.DELETE_ALL:
              _deleteAllNotifications();
            default:
            //handle a default case
          }
        }
      },
    );
  }

  void _markNotificationAsReadById(String? notificationId) {
    setState(() {
      notifications.firstWhere((n) => n.id == notificationId).markAsRead();
    });
  }

  void _markAllNotificationsAsRead() {
    setState(() {
      for (final notification in notifications) {
        notification.markAsRead();
      }
    });
  }

  void _deleteById(String? notificationId) {
    setState(() {
      notifications
          .removeWhere((notification) => notification.id == notificationId);
      totalElements = totalElements - 1;
    });
  }

  void _deleteAllNotifications() {
    setState(() {
      notifications = [];
      totalElements = 0;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels == 0) {
      onRefresh();
    } else if (_scrollController.position.atEdge &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      onEndReached();
    }
  }

  void updateCurrentPageState() {
    if (currentPage < totalPages - 1) {
      currentPage++;
    } else {
      endReached = true;
    }
  }

  void pollFetchNotifications() {
    late var newNotifications = <NotificationDataType>[];
    _periodicUpdateRef = Timer.periodic(
      const Duration(seconds: Generics.DATA_FETCH_INTERVAL),
      (timer) async {
        final fetchedNotifications =
            await FetchAllNotifications.instance.fetchAllNotifications(
          page: 0,
          size: widget.pageSize ?? Generics.PAGE_SIZE,
        );
        if (fetchedNotifications.isSuccess) {
          if (fetchedNotifications.meta!.totalElements! > totalElements) {
            await markAllNotificationsAsViewed();
            newNotifications.addAll(
              fetchedNotifications.data as Iterable<NotificationDataType>,
            );
            if (mounted) {
              setState(
                () {
                  notifications.insertAll(
                    0,
                    newNotifications.take(
                      fetchedNotifications.meta!.totalElements! - totalElements,
                    ),
                  );
                },
              );
            }
            totalElements = fetchedNotifications.meta!.totalElements ?? 0;
            totalPages = fetchedNotifications.meta!.totalPages ?? 0;
            newNotifications = [];
          }
        } else if (fetchedNotifications.isError) {
          setState(() {
            isError = fetchedNotifications.isError;
          });
          widget.onFetchNotificationsError
              ?.call(fetchedNotifications.error ?? ApiErrorDetails());
        }
      },
    );
  }

  Future<void> markAllNotificationsAsViewed() async {
    final notificationsMarkedAsViewed =
        await MarkAllNotificationsAsViewed.markAllNotificationsAsViewed(
      untilDate: DateTime.now().toUtc().toIso8601String(),
    );

    if (notificationsMarkedAsViewed.isError) {
      widget.onMarkAsViewedApiError?.call(
        notificationsMarkedAsViewed.error ?? ApiErrorDetails(),
      );
    }
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
    });

    if (!endReached) {
      final fetchedNotifications =
          await FetchAllNotifications.instance.fetchAllNotifications(
        page: currentPage,
        size: widget.pageSize ?? Generics.PAGE_SIZE,
      );
      if (fetchedNotifications.isSuccess) {
        await markAllNotificationsAsViewed();
        setState(() {
          notifications.addAll(
            fetchedNotifications.data as Iterable<NotificationDataType>,
          );
          isLoading = false;
          totalElements = fetchedNotifications.meta?.totalElements ?? 0;
          totalPages = fetchedNotifications.meta?.totalPages ?? 0;
          updateCurrentPageState();
        });
        pollFetchNotifications();
      } else if (fetchedNotifications.isError) {
        setState(() {
          isError = fetchedNotifications.isError;
        });
        widget.onFetchNotificationsError
            ?.call(fetchedNotifications.error ?? ApiErrorDetails());
      }
    }
  }

  Future<void> onRefresh() async {
    await fetchNotifications();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> onBulkDelete() async {
    final deleteAllResponse = await Siren.deleteNotificationByDate(
        untilDate: DateTime.now().toUtc().toIso8601String());
    if (deleteAllResponse.isSuccess) {
      _deleteAllNotifications();
    } else if (deleteAllResponse.isError) {
      widget.onBulkDeletionError
          ?.call(deleteAllResponse.error ?? ApiErrorDetails());
    }
  }

  Future<void> deleteNotification(String id) async {
    final deletionStatus = await _deleteNotificationById.deleteNotificationById(
      notificationId: id,
    );

    if (deletionStatus.data == Status.SUCCESS && deletionStatus.isSuccess) {
      _deleteById(id);
    } else if (deletionStatus.isError) {
      widget.onDeletionError?.call(deletionStatus.error ?? ApiErrorDetails());
    }
  }

  void onEndReached() {
    if (!isLoading && !loadingNextPage) {
      setState(() {
        loadingNextPage = true;
      });

      Future.delayed(const Duration(seconds: 2), () async {
        await fetchNotifications();
        setState(() {
          isLoading = false;
          loadingNextPage = false;
        });
      });
    }
  }

  Future<void> _markNotificationAsRead(String id) async {
    final readStatus =
        await _readNotificationById.readNotificationById(notificationId: id);
    if (readStatus.isSuccess) {
      _markNotificationAsReadById(id);
    } else if (readStatus.isError) {
      widget.onReadError?.call(readStatus.error ?? ApiErrorDetails());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.customTheme != null
          ? AppTheme.customTheme(widget.customTheme!)
          : (widget.isDarkMode ?? false
              ? AppTheme.darkTheme
              : AppTheme.lightTheme),
      child: Builder(
        builder: (context) {
          final currentTheme = Theme.of(context);

          return Scaffold(
            backgroundColor: currentTheme.colorScheme.primary,
            appBar: widget.showWindowHeader ?? true
                ? _buildAppBar(currentTheme)
                : null,
            body: isError
                ? RefreshIndicator(
                    color: currentTheme.colorScheme.secondary,
                    backgroundColor: currentTheme.colorScheme.primary,
                    onRefresh: () async {
                      setState(() {
                        isError = false;
                      });
                      await fetchNotifications();
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: CustomErrorWidget(),
                          ),
                        ),
                      ],
                    ),
                  )
                : (isLoading && !loadingNextPage)
                    ? const LoaderWidget()
                    : _buildBody(currentTheme),
          );
        },
      ),
    );
  }

  AppBar? _buildAppBar(ThemeData theme) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(widget.windowHeaderText ?? 'Notifications'),
      ),
      backgroundColor: theme.colorScheme.primary,
      titleTextStyle: widget.windowHeaderTextStyle ??
          TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.inversePrimary,
          ),
      centerTitle: widget.isCenterTitle ?? false,
      automaticallyImplyLeading: widget.showHeaderBackButton ?? false,
      iconTheme:
          widget.headerIconTheme ?? const IconThemeData(color: Colors.white),
      actions: [
        if (widget.customHeaderSuffixCTA != null)
          ...widget.customHeaderSuffixCTA!,
        if (!(widget.hideClearAll ?? false) && (!isError && !isLoading))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: onBulkDelete,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    child: Icon(
                      Icons.clear_all,
                      color: theme.colorScheme.outline,
                      size: 24,
                    ),
                  ),
                  Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (notifications.isEmpty && isLoading) {
      return widget.customLoader ?? const LoaderWidget();
    } else if (notifications.isEmpty && !isLoading) {
      return widget.customEmptyWidget ?? const EmptyWidget();
    } else {
      return NotificationListView(
        notifications: notifications,
        isLoading: isLoading,
        endReached: endReached,
        onRefresh: onRefresh,
        onEndReached: onEndReached,
        loadingNextPage: loadingNextPage,
        customStyles: widget.customStyles,
        deleteWidget: widget.deleteWidget,
        hideAvatar: widget.hideAvatar,
        scrollController: _scrollController,
        onDelete: deleteNotification,
        markAsRead: _markNotificationAsRead,
        buildCardWidget: widget.buildCardWidget,
        onCardClick: widget.onCardClick,
      );
    }
  }
}

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Generics.PAGE_SIZE,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: CardLoaderWidget(),
        );
      },
    );
  }
}

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
    this.buildCardWidget,
    this.onCardClick,
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
  final Widget Function(NotificationDataType)? buildCardWidget;
  final void Function(NotificationDataType)? onCardClick;

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
            final itemWidget = buildCardWidget?.call(notifications[index]) ??
                CardWidget(
                  onTap: (notification) {
                    markAsRead(notifications[index].id ?? '');
                    onCardClick?.call(notifications[index]);
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
            return itemWidget;
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
