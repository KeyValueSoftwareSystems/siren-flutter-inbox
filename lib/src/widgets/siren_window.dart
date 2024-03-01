import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/api/fetch_all_notification.dart';
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
  }) : super(key: key);

  final SirenStyleProps? customStyles;
  final bool? hideAvatar;
  final Widget? deleteWidget;
  final bool? showWindowHeader;
  final Widget? customEmptyWidget;
  final Color? windowHeaderBackgroundColor;
  final String? windowHeaderText;
  final TextStyle? windowHeaderTextStyle;

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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchNotifications();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Listener for scroll events
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

  // Fetch notifications from the API
  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedNotifications =
          await FetchAllNotifications.instance.fetchAllNotifications(
        page: currentPage,
        size: 10,
        isRead: false,
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

  // Handle pull-to-refresh
  Future<void> onRefresh() async {
    Future.delayed(const Duration(seconds: 2), () async {
      await fetchNotifications();
      setState(() {
        isLoading = false;
      });
    });
  }

  // Handle reaching the end of the list
  void onEndReached() {
    if (!isLoading && !endReached) {
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

  // Handle deletion of a notification
  void onDelete(String id) {
    setState(() {
      notifications.removeWhere((notification) => notification.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showWindowHeader ?? true ? _buildAppBar() : null,
      body: _buildBody(),
    );
  }

  // Build the app bar if showWindowHeader is true
  AppBar? _buildAppBar() {
    return AppBar(
      title: Text(widget.windowHeaderText ?? 'Notifications'),
      backgroundColor: widget.windowHeaderBackgroundColor,
      titleTextStyle: widget.windowHeaderTextStyle,
      centerTitle: false,
    );
  }

  // Build the body of the widget
  Widget _buildBody() {
    if (isError) {
      // Display error widget with retry option
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
        // Display loading indicator
        return const Center(child: CircularProgressIndicator());
      } else {
        // Display the list of notifications
        return NotificationListView(
          notifications: notifications,
          isLoading: isLoading,
          endReached: endReached,
          onRefresh: onRefresh,
          onDelete: onDelete,
          onEndReached: onEndReached,
          customStyles: widget.customStyles,
          deleteWidget: widget.deleteWidget,
          hideAvatar: widget.hideAvatar,
          customEmptyWidget: widget.customEmptyWidget,
          scrollController: _scrollController,
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
    required this.onDelete,
    required this.customStyles,
    required this.hideAvatar,
    required this.deleteWidget,
    required this.customEmptyWidget,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  final List<NotificationDataType> notifications;
  final bool isLoading;
  final bool endReached;
  final Future<void> Function() onRefresh;
  final VoidCallback onEndReached;
  final void Function(String) onDelete;
  final SirenStyleProps? customStyles;
  final bool? hideAvatar;
  final Widget? deleteWidget;
  final Widget? customEmptyWidget;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: notifications.length + (endReached ? 0 : 1),
        itemBuilder: (context, index) {
          if (notifications.isEmpty && !isLoading) {
            // Display custom empty widget if there are no notifications
            return Center(
              child: customEmptyWidget ?? const EmptyWidget(),
            );
          }
          if (index < notifications.length) {
            // Display a card for each notification
            return CardWidget(
              onCardClick: (notification) {
                // Handle card click
              },
              notification: notifications[index],
              cardProps: CardProps(
                hideAvatar: hideAvatar,
                showMedia: true,
              ),
              onDelete: () => onDelete(notifications[index].id ?? ''),
              styles: customStyles,
              deleteWidget: deleteWidget,
            );
          } else {
            // Return an empty container for the loading indicator
            return Container();
          }
        },
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
      ),
    );
  }
}
