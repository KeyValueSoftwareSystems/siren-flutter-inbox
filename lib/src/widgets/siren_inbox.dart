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
import 'package:sirenapp_flutter_inbox/src/theme/app_theme.dart';
import 'package:sirenapp_flutter_inbox/src/utils/common_utils.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/app_bar.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/inbox_body.dart';

/// Widget for displaying an inbox of notifications.
class SirenInbox extends StatefulWidget {
  const SirenInbox({
    super.key,
    this.darkMode,
    this.itemsPerFetch,
    this.listEmptyWidget,
    this.customCard,
    this.customLoader,
    this.customErrorWidget,
    this.cardParams,
    this.headerParams,
    this.onCardClick,
    this.onError,
    this.theme,
    this.customStyles,
  });

  /// Flag for enabling dark mode.
  final bool? darkMode;

  /// Notifications to be fetched in each request
  final int? itemsPerFetch;

  /// Widget to display when the notification list is empty.
  final Widget? listEmptyWidget;

  /// Custom builder for notification cards.
  final Widget Function(NotificationDataType)? customCard;

  /// Custom loader widget.
  final Widget? customLoader;

  /// Custom error widget.
  final Widget? customErrorWidget;

  ///Custom props for Card properties
  final CardParams? cardParams;

  /// Custom props for header properties
  final HeaderParams? headerParams;

  /// Callback function when a notification card is clicked.
  final void Function(NotificationDataType)? onCardClick;

  /// Callback function for handling errors.
  final void Function(ApiErrorDetails)? onError;

  /// Custom theme colors for the inbox, this focuses on the idea of colorSchemes in flutter theme.
  final CustomThemeColors? theme;

  /// Custom styles for the card of each notification.
  final CustomStyles? customStyles;

  @override
  State<SirenInbox> createState() => _SirenInboxState();
}

class _SirenInboxState extends State<SirenInbox> {
  bool isLoading = true;
  bool endReached = false;
  bool isError = false;
  bool loadingNextPage = false;
  int currentPage = 0;
  int totalElements = 0;
  String? deletingNotificationId;
  int pageSize = 20;

  List<NotificationDataType> notifications = [];
  late final DeleteNotificationById _deleteNotificationById;
  late final ReadNotificationById _readNotificationById;
  late Timer? _periodicUpdateRef;
  late StreamSubscription<StreamResponse> _subscription;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    pageSize = max(min(widget.itemsPerFetch ?? Generics.PAGE_SIZE, 50), 0);
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
                  notifications[0].createdAt,
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
      SirenDataProvider.instance.inboxController.sink.add(
        StreamResponse(
          deleteAllResponse,
          UpdateEvents.DELETE_ALL,
          '',
        ),
      );
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
            notifications[notifications.length - 1].createdAt,
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
      SirenDataProvider.instance.inboxController.sink.add(
        StreamResponse(
          readStatus,
          UpdateEvents.READ_BY_ID,
          id,
        ),
      );
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
            appBar: SirenAppBar(
              theme: currentTheme,
              onClearAllPressed: onBulkDelete,
              isNonEmptyNotifications: shouldShowClearAllButton(),
              headerParams: widget.headerParams,
              styles: widget.customStyles,
            ),
            body: InboxBody(
              currentTheme: currentTheme,
              isLoading: isLoading,
              loadingNextPage: loadingNextPage,
              isError: isError,
              notifications: notifications,
              deleteNotification: deleteNotification,
              markAsRead: _markNotificationAsRead,
              customCard: widget.customCard,
              onCardClick: widget.onCardClick,
              deletingNotificationId: deletingNotificationId,
              disableAutoMarkAsRead:
                  widget.cardParams?.disableAutoMarkAsRead ?? false,
              totalElements: totalElements,
              onRefresh: onRefresh,
              customErrorWidget: widget.customErrorWidget,
              customLoader: widget.customLoader,
              endReached: endReached,
              customStyles: widget.customStyles,
              cardParams: widget.cardParams,
              scrollController: _scrollController,
              onEndReached: onEndReached,
              listEmptyWidget: widget.listEmptyWidget,
            ),
          );
        },
      ),
    );
  }
}
