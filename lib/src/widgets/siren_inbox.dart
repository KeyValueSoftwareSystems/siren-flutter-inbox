import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/api/delete_notification_by_id.dart';
import 'package:siren_flutter_inbox/src/api/fetch_all_notification.dart';
import 'package:siren_flutter_inbox/src/api/mark_all_notifications_as_viewed.dart';
import 'package:siren_flutter_inbox/src/api/notifications_bulk_update.dart';
import 'package:siren_flutter_inbox/src/api/read_notification_by_id.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:siren_flutter_inbox/src/theme/app_theme.dart';
import 'package:siren_flutter_inbox/src/utils/common_utils.dart';
import 'package:siren_flutter_inbox/src/widgets/empty_widget.dart';
import 'package:siren_flutter_inbox/src/widgets/error_widget.dart';
import 'package:siren_flutter_inbox/src/widgets/loader_widget.dart';
import 'package:siren_flutter_inbox/src/widgets/notification_list_view.dart';

/// Widget for displaying an inbox of notifications.
class SirenInbox extends StatefulWidget {
  const SirenInbox({
    super.key,
    this.customStyles,
    this.hideAvatar,
    this.deleteWidget,
    this.hideHeader,
    this.listEmptyWidget,
    this.title,
    this.showDefaultHeaderBackButton,
    this.defaultBackButton,
    this.customNotificationCard,
    this.onNotificationCardClick,
    this.onError,
    this.hideClearAll,
    this.darkMode,
    this.theme,
    this.customLoader,
    this.customErrorWidget,
    this.customHeader,
    this.handleBackNavigation,
    this.itemsPerFetch,
  });

  /// Custom styles for the card of each notification.
  final SirenStyleProps? customStyles;

  /// Flag to hide avatars in notifications.
  final bool? hideAvatar;

  /// Widget or Icon for deleting notifications.
  final Widget? deleteWidget;

  /// Flag to hide the header.
  final bool? hideHeader;

  /// Widget to display when the notification list is empty.
  final Widget? listEmptyWidget;

  /// Title of the inbox page or window.
  final String? title;

  /// Flag to show the header back button provided by the sdk.
  final bool? showDefaultHeaderBackButton;

  /// Default back button widget for the header provided by the sdk.
  final Icon? defaultBackButton;

  /// Custom builder for notification cards.
  final Widget Function(NotificationDataType)? customNotificationCard;

  /// Callback function when a notification card is clicked.
  final void Function(NotificationDataType)? onNotificationCardClick;

  /// Callback function for handling errors.
  final void Function(ApiErrorDetails)? onError;

  /// Flag to hide the "Clear All" button.
  final bool? hideClearAll;

  /// Flag for enabling dark mode.
  final bool? darkMode;

  /// Custom theme colors for the inbox, this focuses on the idea of colorSchemes in flutter theme.
  final CustomThemeColors? theme;

  /// Custom loader widget.
  final Widget? customLoader;

  /// Custom error widget.
  final Widget? customErrorWidget;

  /// Custom header or appBar widget.
  final Widget? customHeader;

  /// Callback function for handling back navigation.
  final void Function()? handleBackNavigation;

  /// Notifications to be fetched in each request
  final int? itemsPerFetch;

  @override
  State<SirenInbox> createState() => _SirenInboxState();
}

class _SirenInboxState extends State<SirenInbox> {
  late ScrollController _scrollController;
  bool isLoading = true;
  bool endReached = false;
  bool isError = false;
  bool loadingNextPage = false;
  int currentPage = 0;
  late int totalElements;
  String? deletingNotificationId;
  int pageSize = 20;

  List<NotificationDataType> notifications = [];
  late final DeleteNotificationById _deleteNotificationById;
  late final ReadNotificationById _readNotificationById;
  late Timer? _periodicUpdateRef;
  late StreamSubscription<StreamResponse> _subscription;

  @override
  void initState() {
    super.initState();
    pageSize = min(widget.itemsPerFetch ?? Generics.PAGE_SIZE, 50);
    _periodicUpdateRef = Timer(const Duration(days: 1), () {});
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _deleteNotificationById = DeleteNotificationById.instance;
    _readNotificationById = ReadNotificationById.instance;
    _subscribeToStream();
    _initialize();
  }

  @override
  void dispose() {
    markAllNotificationsAsViewed();
    _scrollController.dispose();
    _periodicUpdateRef?.cancel();
    _subscription.cancel();
    SirenDataProvider.instance.inboxDispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    if (SirenDataProvider.instance.tokenVerificationStatus == Status.SUCCESS) {
      await initialFetchNotification();
    } else if (SirenDataProvider.instance.tokenVerificationStatus ==
        Status.FAILED) {
      if (mounted) {
        setState(() {
          isError = true;
        });
      }
    }
  }

  void _subscribeToStream() {
    _subscription = SirenDataProvider.instance.inboxController.stream.listen(
      (streamResponse) {
        if (streamResponse.api == UpdateEvents.PARAMS_CHANGED) {
          _reset(cancelFetch: true);
          return;
        } else if (streamResponse.api == UpdateEvents.SHOW_ERROR) {
          setState(() {
            isError = true;
          });
        }
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
            case UpdateEvents.TOKEN_VERIFIED:
              _initialize();

            // ignore: no_default_cases
            default:
          }
        } else if (streamResponse.response?.isError ?? false) {
          widget.onError
              ?.call(streamResponse.response?.error ?? ApiErrorDetails());
        }
      },
    );
  }

  void _reset({bool cancelFetch = false}) {
    if (mounted) {
      setState(() {
        isLoading = true;
        notifications = [];
        endReached = false;
        totalElements = 0;
        currentPage = 0;
      });
    }

    if (cancelFetch) {
      _periodicUpdateRef?.cancel();
    }
  }

  PreferredSize _buildAppBar(ThemeData theme) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: widget.customHeader ?? _buildCustomAppBar(theme, kToolbarHeight),
    );
  }

  void _markNotificationAsReadById(String? notificationId) {
    if (mounted) {
      setState(() {
        notifications.firstWhere((n) => n.id == notificationId).markAsRead();
      });
    }
  }

  void _markAllNotificationsAsRead() {
    if (mounted) {
      setState(() {
        for (final notification in notifications) {
          notification.markAsRead();
        }
      });
    }
  }

  void _deleteById(String? notificationId) {
    if (mounted) {
      setState(() {
        notifications
            .removeWhere((notification) => notification.id == notificationId);
        totalElements = totalElements - 1;
      });
    }
  }

  void _deleteAllNotifications() {
    if (mounted) {
      setState(() {
        notifications = [];
        totalElements = 0;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      onEndReached();
    }
  }

  void fetchNewNotifications() {
    late var newNotifications = <NotificationDataType>[];
    _periodicUpdateRef?.cancel();
    _periodicUpdateRef = Timer.periodic(
      const Duration(seconds: Generics.DATA_FETCH_INTERVAL),
      (timer) async {
        final fetchedNotifications =
            await FetchAllNotifications.instance.fetchAllNotifications(
          size: pageSize,
          start: notifications.isNotEmpty
              ? modifyAndConvertToISOString(
                  notifications[0].createdAt ?? '',
                )
              : null,
        );
        if (fetchedNotifications.isSuccess) {
          if ((fetchedNotifications.meta?.totalElements ?? 0) > 0) {
            unawaited(markAllNotificationsAsViewed());
            newNotifications.addAll(
              fetchedNotifications.data as Iterable<NotificationDataType>,
            );
            if (mounted) {
              setState(
                () {
                  notifications.insertAll(
                    0,
                    newNotifications,
                  );
                },
              );
              if (isLoading) {
                setState(
                  () {
                    isLoading = false;
                  },
                );
              }
            }
            totalElements =
                totalElements + (fetchedNotifications.meta?.totalElements ?? 0);
            newNotifications = [];
          }
        } else if (fetchedNotifications.isError) {
          widget.onError?.call(fetchedNotifications.error ?? ApiErrorDetails());
        }
      },
    );
  }

  Future<void> markAllNotificationsAsViewed() async {
    final notificationsMarkedAsViewed = await MarkAllNotificationsAsViewed
        .instance
        .markAllNotificationsAsViewed(
      untilDate: DateTime.now().toUtc().toIso8601String(),
    );

    if (notificationsMarkedAsViewed.isError) {
      widget.onError?.call(
        notificationsMarkedAsViewed.error ?? ApiErrorDetails(),
      );
    }
  }

  Future<void> initialFetchNotification() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    final fetchedNotifications =
        await FetchAllNotifications.instance.fetchAllNotifications(
      end: DateTime.now().toUtc().toIso8601String(),
      size: pageSize,
    );

    if (fetchedNotifications.isSuccess) {
      unawaited(markAllNotificationsAsViewed());
      setState(() {
        notifications.addAll(
          fetchedNotifications.data as Iterable<NotificationDataType>,
        );
        isLoading = false;
        isError = false;
        totalElements = fetchedNotifications.meta?.totalElements ?? 0;
      });
      fetchNewNotifications();
    } else if (fetchedNotifications.isError) {
      if (mounted) {
        setState(() {
          isError = fetchedNotifications.isError;
        });
      }
      widget.onError?.call(fetchedNotifications.error ?? ApiErrorDetails());
    }
  }

  Future<void> onRefresh() async {
    if (mounted) {
      _reset();
      await initialFetchNotification();
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> onBulkDelete() async {
    final data = {
      'until': DateTime.now().toUtc().toIso8601String(),
      'operation': BulkUpdateType.MARK_AS_DELETED.name,
    };
    final deleteAllResponse =
        await NotificationsBulkUpdate.instance.notificationsBulkUpdate(
      data: data,
    );
    if (deleteAllResponse.isSuccess) {
      _deleteAllNotifications();
    } else if (deleteAllResponse.isError) {
      widget.onError?.call(deleteAllResponse.error ?? ApiErrorDetails());
    }
  }

  Future<void> deleteNotification(String id) async {
    final deletionStatus = await _deleteNotificationById.deleteNotificationById(
      notificationId: id,
    );

    if (deletionStatus.data == Status.SUCCESS && deletionStatus.isSuccess) {
      if (mounted) {
        setState(() {
          deletingNotificationId = id;
        });
      }

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          deletingNotificationId = null;
          _deleteById(id);
          totalElements = totalElements - 1;
        });
      }
      if (notifications.length < pageSize &&
          notifications.length < totalElements) {
        onEndReached();
      }
    } else if (deletionStatus.isError) {
      widget.onError?.call(deletionStatus.error ?? ApiErrorDetails());
    }
  }

  void onEndReached() {
    if (!isLoading &&
        !loadingNextPage &&
        totalElements > notifications.length) {
      if (mounted) {
        setState(() {
          loadingNextPage = true;
        });
      }

      Future.delayed(Duration.zero, () async {
        final fetchedNotifications =
            await FetchAllNotifications.instance.fetchAllNotifications(
          end: convertToISOString(
            notifications[notifications.length - 1].createdAt ?? '',
          ),
          size: pageSize,
        );
        if (fetchedNotifications.isSuccess) {
          if (mounted) {
            setState(() {
              notifications.addAll(
                fetchedNotifications.data as Iterable<NotificationDataType>,
              );
              isLoading = false;
              loadingNextPage = false;
              endReached = totalElements == notifications.length;
            });
          }
        } else if (fetchedNotifications.isError) {
          if (mounted) {
            setState(() {
              loadingNextPage = false;
            });
          }
          widget.onError?.call(fetchedNotifications.error ?? ApiErrorDetails());
        }
      });
    }
  }

  Future<void> _markNotificationAsRead(String id) async {
    final readStatus =
        await _readNotificationById.readNotificationById(notificationId: id);
    if (readStatus.isSuccess) {
      _markNotificationAsReadById(id);
    } else if (readStatus.isError) {
      widget.onError?.call(readStatus.error ?? ApiErrorDetails());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.theme != null
          ? AppTheme.customTheme(
              widget.theme!,
              isDarkMode: widget.darkMode ?? false,
            )
          : (widget.darkMode ?? false
              ? AppTheme.darkTheme
              : AppTheme.lightTheme),
      child: Builder(
        builder: (context) {
          final currentTheme = Theme.of(context);

          return Scaffold(
            backgroundColor: currentTheme.colorScheme.primary,
            appBar:
                widget.hideHeader ?? false ? null : _buildAppBar(currentTheme),
            body: isError
                ? RefreshIndicator(
                    color: currentTheme.colorScheme.secondary,
                    backgroundColor: currentTheme.colorScheme.primary,
                    onRefresh: onRefresh,
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

  Widget _buildCustomAppBar(ThemeData theme, double appBarHeight) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.surfaceTint,
          ),
        ),
      ),
      height: appBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (widget.showDefaultHeaderBackButton ?? false)
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (widget.handleBackNavigation != null) {
                      widget.handleBackNavigation?.call();
                    }
                  },
                  icon: widget.defaultBackButton ??
                      const Icon(Icons.arrow_back_ios),
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      widget.showDefaultHeaderBackButton ?? false ? 2 : 24,
                ),
                child: Text(
                  widget.title ?? 'Notifications',
                  style: widget.customStyles?.defaultHeaderTextStyle ??
                      TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onBackground,
                      ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 24,
            ),
            child: Row(
              children: [
                if (!(widget.hideClearAll ?? false) &&
                    (!isError && !isLoading && notifications.isNotEmpty))
                  GestureDetector(
                    onTap: onBulkDelete,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (notifications.isEmpty && isLoading) {
      return widget.customLoader ?? const LoaderWidget();
    } else if (notifications.isEmpty && !isLoading) {
      return widget.listEmptyWidget ?? const EmptyWidget();
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
        customNotificationCard: widget.customNotificationCard,
        onNotificationCardClick: widget.onNotificationCardClick,
        deletingNotificationId: deletingNotificationId,
        customLoader: widget.customLoader,
        disableAutoMarkAsRead: true,
        totalElements: totalElements,
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
          padding: EdgeInsets.symmetric(vertical: 8),
          child: CardLoaderWidget(),
        );
      },
    );
  }
}
