import 'dart:async';

import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/api/delete_notification_by_id.dart';
import 'package:siren_flutter_inbox/src/api/fetch_all_notification.dart';
import 'package:siren_flutter_inbox/src/api/mark_all_notifications_as_viewed.dart';
import 'package:siren_flutter_inbox/src/api/read_notification_by_id.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/widgets/card.dart';
import 'package:siren_flutter_inbox/src/widgets/empty_widget.dart';
import 'package:siren_flutter_inbox/src/widgets/error_widget.dart';

class SirenWindow extends StatefulWidget {
  const SirenWindow({
    super.key,
    this.customStyles,
    this.hideAvatar,
    this.deleteWidget,
    this.showWindowHeader,
    this.customEmptyWidget,
    this.windowHeaderBackgroundColor,
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
  });

  final SirenStyleProps? customStyles;
  final bool? hideAvatar;
  final Widget? deleteWidget;
  final bool? showWindowHeader;
  final Widget? customEmptyWidget;
  final Color? windowHeaderBackgroundColor;
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

  @override
  _SirenWindowState createState() => _SirenWindowState();
}

class _SirenWindowState extends State<SirenWindow> {
  late ScrollController _scrollController;
  bool isLoading = false;
  bool endReached = false;
  bool isError = false;
  int currentPage = 0;
  late int totalPages;
  late int totalElements;

  List<NotificationDataType> notifications = [];
  late final DeleteNotificationById _deleteNotificationById;
  late final ReadNotificationById _readNotificationById;
  late Timer _periodicUpdateRef;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _deleteNotificationById = DeleteNotificationById.instance;
    _readNotificationById = ReadNotificationById.instance;
    fetchNotifications();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _periodicUpdateRef.cancel();
    super.dispose();
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
            newNotifications.addAll(
              fetchedNotifications.data as Iterable<NotificationDataType>,
            );
            setState(() {
              notifications.insertAll(
                0,
                newNotifications.take(
                  fetchedNotifications.meta!.totalElements! - totalElements,
                ),
              );
            });
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
        try {
          await MarkAllNotificationsAsViewed.markAllNotificationsAsViewed(
            untilDate: DateTime.now().toUtc().toIso8601String(),
          );
        } catch (error) {
          print('error $error');
        }
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

  Future<void> deleteNotification(String id) async {
    final deletionStatus = await _deleteNotificationById.deleteNotificationById(
        notificationId: id);

    if (deletionStatus.data == Status.SUCCESS && deletionStatus.isSuccess) {
      setState(() {
        notifications.removeWhere((notification) => notification.id == id);
      });
      totalElements = totalElements - 1;
    } else if (deletionStatus.isError) {
      widget.onDeletionError?.call(deletionStatus.error ?? ApiErrorDetails());
    }
  }

  void onEndReached() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      Future.delayed(const Duration(seconds: 2), () async {
        await fetchNotifications();
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future<void> _markNotificationAsRead(String id) async {
    final readStatus =
        await _readNotificationById.readNotificationById(notificationId: id);
    if (readStatus.isSuccess) {
      setState(
        () {
          final notification = notifications.firstWhere((n) => n.id == id);
          notification.markAsRead();
        },
      );
    } else if (readStatus.isError) {
      widget.onReadError?.call(readStatus.error ?? ApiErrorDetails());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showWindowHeader ?? true ? _buildAppBar() : null,
      body: _buildBody(),
    );
  }

  AppBar? _buildAppBar() {
    return AppBar(
      title: Text(widget.windowHeaderText ?? 'Notifications'),
      backgroundColor:
          widget.windowHeaderBackgroundColor ?? const Color(0xFFEB5017),
      titleTextStyle: widget.windowHeaderTextStyle ??
          const TextStyle(color: Colors.white, fontSize: 24),
      centerTitle: widget.isCenterTitle ?? false,
      automaticallyImplyLeading: widget.showHeaderBackButton ?? true,
      iconTheme:
          widget.headerIconTheme ?? const IconThemeData(color: Colors.white),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: () async {
              try {
                await Siren.deleteNotificationByDate(
                    untilDate: DateTime.now().toUtc().toIso8601String());
                setState(() {
                  notifications = [];
                });
                totalElements = 0;
              } catch (error) {
                print('error $error');
              }
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (isError) {
      return CustomErrorWidget(
        onRetry: () {
          Future.delayed(const Duration(seconds: 2), () async {
            await fetchNotifications();
            setState(() {
              isLoading = false;
            });
          });
        },
      );
    } else {
      if (notifications.isEmpty && isLoading) {
        return widget.customEmptyWidget ??
            const Center(child: CircularProgressIndicator());
      } else if (notifications.isEmpty && !isLoading) {
        return const EmptyWidget();
      } else {
        return NotificationListView(
          notifications: notifications,
          isLoading: isLoading,
          endReached: endReached,
          onRefresh: onRefresh,
          onEndReached: onEndReached,
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
}

class NotificationListView extends StatelessWidget {
  const NotificationListView({
    required this.notifications,
    required this.isLoading,
    required this.endReached,
    required this.onRefresh,
    required this.onEndReached,
    required this.customStyles,
    required this.hideAvatar,
    required this.deleteWidget,
    required this.scrollController,
    required this.onDelete,
    required this.markAsRead,
    this.buildCardWidget,
    this.onCardClick,
    Key? key,
  }) : super(key: key);

  final List<NotificationDataType> notifications;
  final bool isLoading;
  final bool endReached;
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
            return const SizedBox();
          }
        },
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
      ),
    );
  }
}
