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
    this.customTabIndicator,
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

  /// Custom properties for card.
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

  final BoxDecoration? customTabIndicator;

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
  bool _enableClearAll = true;

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

  void safeSetState(VoidCallback callback) {
    if (mounted) {
      setState(callback);
    }
  }

  Future<void> _initialize() async {
    if (SirenDataProvider.instance.tokenVerificationStatus == Status.SUCCESS) {
      await initialFetchNotification();
    } else if (SirenDataProvider.instance.tokenVerificationStatus ==
            Status.FAILED ||
        !SirenDataProvider.instance.isProviderInitialized) {
      widget.onError?.call(Errors.outsideSirenContextError);
      safeSetState(() {
        isError = true;
      });
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
          safeSetState(() {
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
    safeSetState(() {
      isLoading = true;
      notifications = [];
      isEndReached = false;
      currentPage = 0;
    });

    if (cancelFetch) {
      _periodicUpdateRef?.cancel();
    }
  }

  void _markNotificationAsReadById(String? notificationId) {
    safeSetState(() {
      notifications.firstWhere((n) => n.id == notificationId).markAsRead();
    });
  }

  void _markAllNotificationsAsRead() {
    safeSetState(() {
      for (final notification in notifications) {
        notification.markAsRead();
      }
    });
  }

  void _deleteById(String? notificationId) {
    safeSetState(() {
      notifications
          .removeWhere((notification) => notification.id == notificationId);
    });
  }

  void _deleteAllNotifications() {
    safeSetState(() {
      notifications = [];
      _enableClearAll = false;
    });
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
            _tabScrollControllers[index].position.maxScrollExtent) {
      onEndReached();
    }
  }

  void _tabListener() {
    if (_tabController.index != _tabController.previousIndex) {
      onTabChanged(_tabController.index);
    }
  }

  bool? getIsRead() {
    if ((widget.hideTab ?? false) == false && _activeTabIndex == 1) {
      return false;
    }
    return null;
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

  void fetchNewNotifications() {
    _periodicUpdateRef?.cancel();
    _periodicUpdateRef = Timer.periodic(
      const Duration(seconds: Generics.DATA_FETCH_INTERVAL),
      (timer) async {
        final fetchedNotifications =
            await FetchAllNotifications.instance.fetchAllNotifications(
          size: pageSize,
          isRead: getIsRead(),
          start: notifications.isNotEmpty
              ? modifyAndConvertToISOString(
                  notifications[0].createdAt,
                )
              : null,
        );
        if (fetchedNotifications.isSuccess) {
          final newNotifications =
              fetchedNotifications.data as Iterable<NotificationType>;
          final count = newNotifications.length;
          if (count > 0) {
            unawaited(markAllNotificationsAsViewed());
            safeSetState(
              () {
                notifications.insertAll(0, newNotifications);
                _enableClearAll = notifications.isNotEmpty;
                if (isLoading) {
                  isLoading = false;
                }
              },
            );
          }
        } else if (fetchedNotifications.isError) {
          widget.onError?.call(fetchedNotifications.error ?? SirenErrorType());
        }
      },
    );
  }

  Future<void> initialFetchNotification() async {
    safeSetState(() {
      isLoading = true;
    });

    final fetchedNotifications =
        await FetchAllNotifications.instance.fetchAllNotifications(
      end: DateTime.now().toUtc().toIso8601String(),
      size: pageSize,
      isRead: getIsRead(),
    );

    if (fetchedNotifications.isSuccess) {
      unawaited(markAllNotificationsAsViewed());
      safeSetState(() {
        notifications
            .addAll(fetchedNotifications.data as Iterable<NotificationType>);
        isLoading = false;
        isError = false;
        _enableClearAll = notifications.isNotEmpty;
      });
      fetchNewNotifications();
    } else if (fetchedNotifications.isError) {
      safeSetState(() {
        isError = fetchedNotifications.isError;
      });

      widget.onError?.call(fetchedNotifications.error ?? SirenErrorType());
    }
  }

  Future<void> onRefresh() async {
    if (mounted) {
      _reset(cancelFetch: true);
      await initialFetchNotification();
      safeSetState(() {
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
      isRead: getIsRead(),
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
      safeSetState(() {
        deletingNotificationId = id;
      });

      await Future<void>.delayed(const Duration(milliseconds: 500));
      SirenDataProvider.instance.inboxController.sink.add(
        StreamResponse(
          deletionStatus,
          UpdateEvents.DELETE_BY_ID,
          id,
        ),
      );

      _deleteById(id);
      safeSetState(() {
        _enableClearAll = notifications.isNotEmpty;
        deletingNotificationId = null;
      });

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
      safeSetState(() {
        loadingNextPage = true;
      });

      Future.delayed(Duration.zero, () async {
        final fetchedNotifications =
            await FetchAllNotifications.instance.fetchAllNotifications(
          end: convertToISOString(
            notifications.last.createdAt,
          ),
          size: pageSize,
          isRead: getIsRead(),
        );
        if (fetchedNotifications.isSuccess) {
          final newNotifications =
              fetchedNotifications.data as Iterable<NotificationType>;
          final count = newNotifications.length;

          safeSetState(() {
            notifications.addAll(
              newNotifications,
            );
            isLoading = false;
            loadingNextPage = false;
            isEndReached = count < pageSize;
            _enableClearAll = notifications.isNotEmpty;
          });
        } else if (fetchedNotifications.isError) {
          safeSetState(() {
            loadingNextPage = false;
          });

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
      safeSetState(() {
        _activeTabIndex = index;
        _reset(cancelFetch: true);
        _initialize();
      });
    }
  }

  Widget _buildInboxBody(
    ScrollController _controller,
    List<NotificationType> data,
    bool isTabInactive,
  ) {
    return InboxBody(
      activeTabIndex: _activeTabIndex,
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
      isLoading: ((!(widget.hideTab ?? false)) && isTabInactive) || isLoading,
      listEmptyWidget: widget.listEmptyWidget,
      loadingNextPage: loadingNextPage,
      markAsRead: _markNotificationAsRead,
      notifications: data,
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
          isNonEmptyNotifications: _enableClearAll,
          headerParams: widget.headerParams,
          styles: widget.customStyles,
        ),
        body: Column(
          children: [
            Container(
              margin: widget.customStyles?.tabStyles?.containerStyle?.margin ??
                  EdgeInsets.zero,
              color: widget.theme?.tabColors?.containerBackgroundColor ??
                  Colors.transparent,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                padding:
                    widget.customStyles?.tabStyles?.containerStyle?.padding ??
                        const EdgeInsets.symmetric(horizontal: 24),
                indicator: widget.customTabIndicator ??
                    UnderlineTabIndicator(
                      borderSide: BorderSide(
                        color: widget.theme?.tabColors?.activeTabTextColor ??
                            colors.tabBarActiveColor,
                        width: 4,
                      ),
                    ),
                indicatorPadding: widget.customStyles?.tabStyles?.indicatorPadding ?? EdgeInsets.all(0),
                indicatorSize: TabBarIndicatorSize.tab,
                tabAlignment: TabAlignment.start,
                dividerColor:
                    widget.theme?.tabColors?.containerBackgroundColor ??
                        colors.scaffoldBackgroundColor,
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
                        : Colors.transparent,
                    child: Tab(
                      child: Text(tabItem.title),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (widget.customStyles?.hideTabMargin?.lower != true)
              Container(
                height: 1,
                margin:
                    widget.customStyles?.tabStyles?.containerStyle?.margin ??
                        EdgeInsets.zero,
                color: widget.theme?.cardColors?.borderColor ??
                    widget.theme?.borderColor ??
                    colors.cardBorderColor,
              ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ...List.generate(
                    tabs.length,
                    (index) => _buildInboxBody(
                      _tabScrollControllers[index],
                      index == _activeTabIndex ? notifications : [],
                      index != _activeTabIndex,
                    ),
                  ),
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
          isNonEmptyNotifications: _enableClearAll,
          headerParams: widget.headerParams,
          styles: widget.customStyles,
        ),
        body: _buildInboxBody(_inboxScrollController, notifications, false),
      );
    }
  }
}
