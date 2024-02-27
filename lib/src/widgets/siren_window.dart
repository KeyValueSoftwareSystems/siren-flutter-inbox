import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/models/ui_models.dart';
import 'package:siren_flutter_inbox/src/widgets/card.dart';
import 'package:siren_flutter_inbox/src/widgets/empty_widget.dart';

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
  });

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
  late List<NotificationDataType> notifications;
  bool isLoading = false;
  bool endReached = false;

  @override
  void initState() {
    super.initState();
    //dummy data
    notifications = List.generate(
      30,
      (index) => NotificationDataType(
        id: '${index + 1}',
        createdAt: '2024-01-01T00:00:00Z',
        message: MessageData(
          channel: '',
          header: 'Title of the notification ${index + 1}',
          subHeader: 'Subheader of the notification ${index + 1}',
          body:
              'You have a new message from notification ${index + 1}. This is the body. this is a longer text, lets see what happens',
          actionUrl: '',
          avatar: AvatarData(
            imageUrl: 'https://picsum.photos/200',
            actionUrl: null,
          ),
          additionalData: '',
        ),
        requestId: '',
        isRead: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showWindowHeader ?? true
          ? AppBar(
              title: Text(widget.windowHeaderText ?? 'Notifications'),
              backgroundColor: widget.windowHeaderBackgroundColor,
              titleTextStyle: widget.windowHeaderTextStyle,
              centerTitle: false,
            )
          : null,
      body: NotificationListView(
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
      ),
    );
  }

  Future<void> onRefresh() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  void onEndReached() {
    if (!isLoading && !endReached) {
      setState(() {
        isLoading = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
          endReached = true;
        });
      });
    }
  }

  void onDelete(String id) {
    setState(() {
      notifications.removeWhere((notification) => notification.id == id);
    });
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
    super.key,
    this.customStyles,
    this.hideAvatar,
    this.deleteWidget,
    this.customEmptyWidget,
  });

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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: notifications.length + (endReached ? 0 : 1),
        itemBuilder: (context, index) {
          if (notifications.isEmpty) {
            return Center(
              child: customEmptyWidget ?? const EmptyWidget(),
            );
          }
          if (index < notifications.length) {
            return CardWidget(
              onCardClick: (notification) {
                // Handle card click
              },
              notification: notifications[index],
              cardProps: CardProps(
                hideAvatar: hideAvatar,
                showMedia: true,
              ),
              onDelete: () => onDelete(notifications[index].id),
              styles: customStyles,
              deleteWidget: deleteWidget,
            );
          } else {
            return _buildLoader();
          }
        },
        physics: const AlwaysScrollableScrollPhysics(),
        controller: ScrollController(),
      ),
    );
  }

  Widget _buildLoader() {
    return isLoading
        ? const Padding(
            padding: EdgeInsets.all(8),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container();
  }
}
