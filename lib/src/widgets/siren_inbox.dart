import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/api/delete_notification_by_id.dart';
import 'package:sirenapp_flutter_inbox/src/api/fetch_all_notification.dart';
import 'package:sirenapp_flutter_inbox/src/api/mark_all_notifications_as_viewed.dart';
import 'package:sirenapp_flutter_inbox/src/api/notifications_bulk_update.dart';
import 'package:sirenapp_flutter_inbox/src/api/read_notification_by_id.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/errors/errors.dart';
import 'package:sirenapp_flutter_inbox/src/theme/app_theme.dart';
import 'package:sirenapp_flutter_inbox/src/utils/common_utils.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/app_bar.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/inbox_body.dart';

/// Widget for displaying an inbox of notifications.
class SirenInbox extends StatefulWidget {
  const SirenInbox({
    super.key,
    this.darkMode,
    this.hideTab,
    this.itemsPerFetch,
    this.listEmptyWidget,
    this.customCard,
    this.customLoader,
    this.customErrorWidget,
    this.cardParams,
    this.headerParams,
    this.tabParams,
    this.onCardClick,
    this.onError,
    this.theme,
    this.customStyles,
  });

  /// Flag for enabling dark mode.
  final bool? darkMode;

  /// Flag to hide the tab bar.
  final bool? hideTab;

  /// Notifications to be fetched in each request
  final int? itemsPerFetch;

  /// Widget to display when the notification list is empty.
  final Widget? listEmptyWidget;

  /// Custom builder for notification cards.
  final Widget Function(NotificationType)? customCard;

  /// Custom loader widget.
  final Widget? customLoader;

  /// Custom error widget.
  final Widget? customErrorWidget;

  /// Custom properties for Card
  final CardParams? cardParams;

  /// Custom properties for inbox header.
  final HeaderParams? headerParams;

  // Properties for the tab bar.
  final TabParams? tabParams;

  /// Callback function when a notification card is clicked.
  final void Function(NotificationType)? onCardClick;

  /// Callback function for handling errors.
  final void Function(SirenErrorType)? onError;

  /// Custom theme colors for the inbox.
  final CustomThemeColors? theme;

  /// Custom styles for the card of each notification.
  final CustomStyles? customStyles;

  @override
  State<SirenInbox> createState() => _SirenInboxState();
}

class _SirenInboxState extends State<SirenInbox>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  bool isEndReached = false;
  bool isError = false;
  bool loadingNextPage = false;
  int currentPage = 0;
  String? deletingNotificationId;
  int pageSize = 20;
  int _activeTabIndex = 0;

  List<NotificationType> notifications = [];
  late final DeleteNotificationById _deleteNotificationById;
  late final ReadNotificationById _readNotificationById;
  late Timer? _periodicUpdateRef;
  late StreamSubscription<StreamResponse> _subscription;
  late ScrollController _inboxScrollController;
  late List<ScrollController> _tabScrollControllers;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initializeVariables();
    _subscribeToStream();
    _initialize();
  }

  @override
  void dispose() {
    markAllNotificationsAsViewed();
    _inboxScrollController.dispose();
    for (final controller in _tabScrollControllers) {
      controller.dispose();
    }
    _tabController.dispose();
    _periodicUpdateRef?.cancel();
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    if (SirenDataProvider.instance.tokenVerificationStatus == Status.SUCCESS) {
      await initialFetchNotification();
    } else if (SirenDataProvider.instance.tokenVerificationStatus ==
            Status.FAILED ||
        !SirenDataProvider.instance.isProviderInitialized) {
      widget.onError?.call(Errors.outsideSirenContextError);
      if (mounted) {
        setState(() {
          isError = true;
        });
      }
    }
  }

  void _initializeVariables() {
    pageSize = max(min(widget.itemsPerFetch ?? Generics.PAGE_SIZE, 50), 0);
    _periodicUpdateRef = Timer(const Duration(days: 1), () {});
    _activeTabIndex = _activeTabIndex = (widget.tabParams?.activeTabIndex ?? 0)
        .clamp(0, InboxTabs.values.length - 1);
    _inboxScrollController = ScrollController();
    _inboxScrollController.addListener(_scrollListener);
    _tabScrollControllers = List.generate(
      InboxTabs.values.length,
      (index) => ScrollController()
        ..addListener(() {
          _tabScrollListeners(index);
        }),
    );

    _deleteNotificationById = DeleteNotificationById.instance;
    _readNotificationById = ReadNotificationById.instance;
    _tabController = TabController(
      length: InboxTabs.values.length,
      vsync: this,
      initialIndex: _activeTabIndex,
    );
    _tabController.addListener(_tabListener);
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
              break;
            case UpdateEvents.READ_ALL:
              _markAllNotificationsAsRead();
              break;
            case UpdateEvents.DELETE_BY_ID:
              _deleteById(streamResponse.id);
              break;
            case UpdateEvents.DELETE_ALL:
              _deleteAllNotifications();
              break;
            case UpdateEvents.TOKEN_VERIFIED:
              _initialize();
              break;

            // ignore: no_default_cases
            default:
          }
        } else if (streamResponse.response?.isError ?? false) {
          widget.onError
              ?.call(streamResponse.response?.error ?? SirenErrorType());
        }
      },
    );
  }

  void _reset({bool cancelFetch = false}) {
    if (mounted) {
      setState(() {
        isLoading = true;
        notifications = [];
        isEndReached = false;
        currentPage = 0;
      });
    }

    if (cancelFetch) {
      _periodicUpdateRef?.cancel();
    }
  }

  bool shouldShowClearAllButton() {
    return !isError && !isLoading && notifications.isNotEmpty;
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
      });
    }
  }

  void _deleteAllNotifications() {
    if (mounted) {
      setState(() {
        notifications = [];
      });
    }
  }

  void _scrollListener() {
    if (_inboxScrollController.position.atEdge &&
        _inboxScrollController.position.pixels ==
            _inboxScrollController.position.maxScrollExtent) {
      onEndReached();
    }
  }

  void _tabScrollListeners(int index) {
    if (_tabScrollControllers[index].position.atEdge &&
        _tabScrollControllers[index].position.pixels ==
            _tabScrollControllers[index].position.maxScrollExtent) {}
  }

  void _tabListener() {
    if (_tabController.index != _tabController.previousIndex) {
      onTabChanged(_tabController.index);
    }
  }

  void fetchNewNotifications() {
    late var newNotifications = <NotificationType>[];
    _periodicUpdateRef?.cancel();
    _periodicUpdateRef = Timer.periodic(
      const Duration(seconds: Generics.DATA_FETCH_INTERVAL),
      (timer) async {
        final fetchedNotifications =
            await FetchAllNotifications.instance.fetchAllNotifications(
          size: pageSize,
          isRead: _activeTabIndex == 1 ? false : null,
          start: notifications.isNotEmpty
              ? modifyAndConvertToISOString(
                  notifications[0].createdAt,
                )
              : null,
        );
        if (fetchedNotifications.isSuccess) {
          final count =
              (fetchedNotifications.data as Iterable<NotificationType>).length;
          if (count > 0) {
            unawaited(markAllNotificationsAsViewed());
            newNotifications.addAll(
              fetchedNotifications.data as Iterable<NotificationType>,
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
            newNotifications = [];
          }
        } else if (fetchedNotifications.isError) {
          widget.onError?.call(fetchedNotifications.error ?? SirenErrorType());
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
        notificationsMarkedAsViewed.error ?? SirenErrorType(),
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
      isRead: _activeTabIndex == 1 ? false : null,
    );

    if (fetchedNotifications.isSuccess) {
      unawaited(markAllNotificationsAsViewed());
      setState(() {
        notifications.addAll(
          fetchedNotifications.data as Iterable<NotificationType>,
        );
        isLoading = false;
        isError = false;
      });
      fetchNewNotifications();
    } else if (fetchedNotifications.isError) {
      if (mounted) {
        setState(() {
          isError = fetchedNotifications.isError;
        });
      }
      widget.onError?.call(fetchedNotifications.error ?? SirenErrorType());
    }
  }

  Future<void> onRefresh() async {
    if (mounted) {
      _reset(cancelFetch: true);
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
      operation: BulkUpdateType.MARK_AS_DELETED.name,
    );
    if (deleteAllResponse.isSuccess) {
      SirenDataProvider.instance.inboxController.sink.add(
        StreamResponse(
          deleteAllResponse,
          UpdateEvents.DELETE_ALL,
          '',
        ),
      );
      _deleteAllNotifications();
    } else if (deleteAllResponse.isError) {
      widget.onError?.call(deleteAllResponse.error ?? SirenErrorType());
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

      await Future<void>.delayed(const Duration(milliseconds: 500));
      SirenDataProvider.instance.inboxController.sink.add(
        StreamResponse(
          deletionStatus,
          UpdateEvents.DELETE_BY_ID,
          id,
        ),
      );
      if (mounted) {
        setState(() {
          deletingNotificationId = null;
          _deleteById(id);
        });
      }
      if (notifications.length < pageSize &&
          notifications.length < Generics.AVERAGE_ITEMS_ON_SCREEN) {
        onEndReached();
      }
    } else if (deletionStatus.isError) {
      widget.onError?.call(deletionStatus.error ?? SirenErrorType());
    }
  }

  void onEndReached() {
    if (!isLoading && !loadingNextPage && !isEndReached) {
      if (mounted) {
        setState(() {
          loadingNextPage = true;
        });
      }

      Future.delayed(Duration.zero, () async {
        final fetchedNotifications =
            await FetchAllNotifications.instance.fetchAllNotifications(
          end: convertToISOString(
            notifications[notifications.length - 1].createdAt,
          ),
          size: pageSize,
          isRead: _activeTabIndex == 1 ? false : null,
        );
        if (fetchedNotifications.isSuccess) {
          final count =
              (fetchedNotifications.data as Iterable<NotificationType>).length;
          if (mounted) {
            setState(() {
              notifications.addAll(
                fetchedNotifications.data as Iterable<NotificationType>,
              );
              isLoading = false;
              loadingNextPage = false;
              isEndReached = count < pageSize;
            });
          }
        } else if (fetchedNotifications.isError) {
          if (mounted) {
            setState(() {
              loadingNextPage = false;
            });
          }
          widget.onError?.call(fetchedNotifications.error ?? SirenErrorType());
        }
      });
    }
  }

  Future<void> _markNotificationAsRead(String id) async {
    final readStatus =
        await _readNotificationById.readNotificationById(notificationId: id);
    if (readStatus.isSuccess) {
      SirenDataProvider.instance.inboxController.sink.add(
        StreamResponse(
          readStatus,
          UpdateEvents.READ_BY_ID,
          id,
        ),
      );
      _markNotificationAsReadById(id);
    } else if (readStatus.isError) {
      widget.onError?.call(readStatus.error ?? SirenErrorType());
    }
  }

  void onTabChanged(int index) {
    if (_activeTabIndex != index) {
      if (mounted) {
        setState(() {
          _activeTabIndex = index;
          _reset();
        });
      }
    }
  }

  Widget _buildInboxBody(ScrollController _controller) {
    return InboxBody(
      cardParams: widget.cardParams,
      colors: widget.theme,
      customCard: widget.customCard,
      customErrorWidget: widget.customErrorWidget,
      customLoader: widget.customLoader,
      customStyles: widget.customStyles,
      deleteNotification: deleteNotification,
      deletingNotificationId: deletingNotificationId,
      disableAutoMarkAsRead: widget.cardParams?.disableAutoMarkAsRead ?? false,
      endReached: isEndReached,
      isDarkMode: widget.darkMode,
      isError: isError,
      isLoading: isLoading,
      listEmptyWidget: widget.listEmptyWidget,
      loadingNextPage: loadingNextPage,
      markAsRead: _markNotificationAsRead,
      notifications: notifications,
      onCardClick: widget.onCardClick,
      onEndReached: onEndReached,
      onRefresh: onRefresh,
      scrollController: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = SirenAppTheme.colors(isDarkMode: widget.darkMode ?? false);
    final tabs = widget.tabParams?.tabs ?? Generics.inboxTabs;

    if ((widget.hideTab ?? false) == false) {
      return Scaffold(
        backgroundColor:
            widget.theme?.backgroundColor ?? colors.scaffoldBackgroundColor,
        appBar: SirenAppBar(
          colors: widget.theme,
          isDarkMode: widget.darkMode,
          onClearAllPressed: onBulkDelete,
          isNonEmptyNotifications: shouldShowClearAllButton(),
          headerParams: widget.headerParams,
          styles: widget.customStyles,
        ),
        body: Column(
          children: [
            Container(
              color: widget.theme?.tabColors?.containerBackgroundColor ??
                  Colors.transparent,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                indicatorSize: TabBarIndicatorSize.tab,
                tabAlignment: TabAlignment.start,
                indicatorColor: widget.theme?.tabColors?.indicatorColor ??
                    colors.tabBarActiveColor,
                indicatorWeight:
                    widget.customStyles?.tabStyles?.indicatorSize ?? 4,
                labelColor: widget.theme?.tabColors?.activeTabTextColor ??
                    colors.tabBarActiveColor,
                unselectedLabelColor:
                    widget.theme?.tabColors?.inactiveTabTextColor ??
                        colors.tabBarInActiveColor,
                labelPadding: EdgeInsets.zero,
                labelStyle:
                    widget.customStyles?.tabStyles?.activeTabTextStyle ??
                        const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                unselectedLabelStyle:
                    widget.customStyles?.tabStyles?.inActiveTabTextStyle ??
                        const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                onTap: onTabChanged,
                tabs: tabs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final tabItem = entry.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: _activeTabIndex == index
                        ? widget.theme?.tabColors?.activeTabBackgroundColor ??
                            Colors.transparent
                        : widget.theme?.tabColors?.inactiveTabBackgroundColor ??
                            Colors.transparent,
                    child: Tab(
                      child: Text(tabItem.title),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildInboxBody(_tabScrollControllers[0]),
                  _buildInboxBody(_tabScrollControllers[1]),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        backgroundColor:
            widget.theme?.backgroundColor ?? colors.scaffoldBackgroundColor,
        appBar: SirenAppBar(
          colors: widget.theme,
          isDarkMode: widget.darkMode,
          onClearAllPressed: onBulkDelete,
          isNonEmptyNotifications: shouldShowClearAllButton(),
          headerParams: widget.headerParams,
          styles: widget.customStyles,
        ),
        body: _buildInboxBody(_inboxScrollController),
      );
    }
  }
}
