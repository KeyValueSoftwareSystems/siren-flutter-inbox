import 'dart:async';

import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/api/delete_notification_by_id.dart';
import 'package:siren_flutter_inbox/src/api/fetch_all_notification.dart';
import 'package:siren_flutter_inbox/src/api/mark_all_notifications_as_viewed.dart';
import 'package:siren_flutter_inbox/src/api/read_notification_by_id.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/models/notification_model.dart';
import 'package:siren_flutter_inbox/src/models/ui_models.dart';
import 'package:siren_flutter_inbox/src/widgets/card.dart';
import 'package:siren_flutter_inbox/src/widgets/empty_widget.dart';
import 'package:siren_flutter_inbox/src/widgets/error_widget.dart';

class SirenWindow extends StatefulWidget {
  const SirenWindow({
    Key? key,
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
  }) : super(key: key);

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
    pollFetchNotifications();
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

  void pollFetchNotifications() {
    late var newNotifications = <NotificationDataType>[];
    _periodicUpdateRef = Timer.periodic(
      const Duration(seconds: Generics.DATA_FETCH_INTERVAL),
      (timer) async {
        try {
          final fetchedNotifications =
              await FetchAllNotifications.instance.fetchAllNotifications(
            page: 0,
            size: widget.pageSize ?? Generics.PAGE_SIZE,
          );

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
        } catch (error) {
          // Handle errors
          print('Error: $error');
        }
      },
    );
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
    });

    if (!endReached) {
      try {
        final fetchedNotifications =
            await FetchAllNotifications.instance.fetchAllNotifications(
          page: currentPage,
          size: widget.pageSize ?? Generics.PAGE_SIZE,
        );
        try {
          await MarkAllNotificationsAsViewed.markAllNotificationsAsViewed(
            untilDate: DateTime.now().toUtc().toIso8601String(),
          );
        } catch (error) {
          print('error $error');
        }
        setState(() {
          notifications.addAll(
              fetchedNotifications.data as Iterable<NotificationDataType>);
          isLoading = false;
          isError = fetchedNotifications.isError;
          totalElements = fetchedNotifications.meta?.totalElements ?? 0;
          totalPages = fetchedNotifications.meta?.totalPages ?? 0;
          if (currentPage < totalPages - 1) {
            currentPage++;
          } else {
            endReached = true;
          }
        });
      } catch (error) {
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    }
  }

  Future<void> onRefresh() async {
    Future.delayed(const Duration(seconds: 2), () async {
      await fetchNotifications();
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> deleteNotification(String id) async {
    await _deleteNotificationById.deleteNotificationById(notificationId: id);
    setState(() {
      notifications.removeWhere((notification) => notification.id == id);
    });
    totalElements = totalElements - 1;
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
    try {
      await _readNotificationById.readNotificationById(notificationId: id);
      setState(() {
        final notification = notifications.firstWhere((n) => n.id == id);
        notification.markAsRead();
      });
    } catch (error) {
      print('error: $error');
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: () async {
              try {
                await Siren.markNotificationsAsViewed(
                    untilDate: DateTime.now().toUtc().toIso8601String());
                setState(() {
                  for (final notification in notifications) {
                    notification.markAsRead();
                  }
                });
              } catch (error) {
                print('error $error');
              }
            },
            child: const Text(
              'Read All',
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
    required this.markAsRead, // Add the markAsRead callback
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
  final void Function(String) markAsRead; // Add the markAsRead callback

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: notifications.length + (endReached ? 0 : 1),
        itemBuilder: (context, index) {
          if (index < notifications.length) {
            return CardWidget(
              onCardClick: (notification) {
                markAsRead(
                  notifications[index].id ?? '',
                );
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
          } else {
            return Container();
          }
        },
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
      ),
    );
  }
}
