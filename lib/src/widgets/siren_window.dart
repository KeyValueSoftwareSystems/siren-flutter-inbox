import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/api/delete_notification_by_id.dart';
import 'package:siren_flutter_inbox/src/api/fetch_all_notification.dart';
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

  List<NotificationDataType> notifications = [];
  late final DeleteNotificationById _deleteNotificationById;
  late final ReadNotificationById _readNotificationById;

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
        setState(() {
          notifications.addAll(
              fetchedNotifications.data as Iterable<NotificationDataType>);
          isLoading = false;
          isError = fetchedNotifications.isError;
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
      backgroundColor: widget.windowHeaderBackgroundColor,
      titleTextStyle: widget.windowHeaderTextStyle,
      centerTitle: false,
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
          markAsRead: _markNotificationAsRead, // Pass the markAsRead function
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
