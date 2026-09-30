import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/src/api/delete_notification_by_id.dart';
import 'package:sirenapp_flutter_inbox/src/api/fetch_all_notification.dart';
import 'package:sirenapp_flutter_inbox/src/api/mark_all_notifications_as_viewed.dart';
import 'package:sirenapp_flutter_inbox/src/api/read_notification_by_id.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/errors/errors.dart';
import 'package:sirenapp_flutter_inbox/src/models/api_response.dart';
import 'package:sirenapp_flutter_inbox/src/models/notification_model.dart';
import 'package:sirenapp_flutter_inbox/src/utils/common_utils.dart';

/// The current state of notification data provided by [SirenNotificationBuilder].
class SirenNotificationState {
  /// Constructs a [SirenNotificationState].
  const SirenNotificationState({
    required this.notifications,
    required this.isLoading,
    required this.isError,
    required this.hasMore,
    this.error,
  });

  /// The list of notifications fetched so far.
  final List<NotificationType> notifications;

  /// Whether the initial fetch is in progress.
  final bool isLoading;

  /// Whether an error occurred during fetching.
  final bool isError;

  /// Whether more pages are available to load.
  final bool hasMore;

  /// The error details, if [isError] is true.
  final SirenErrorType? error;
}

/// Controller exposed to consumers to trigger notification actions.
class SirenNotificationController {
  SirenNotificationController._(this._state);

  final _SirenNotificationBuilderState _state;

  /// Load the next page of notifications.
  void loadMore() => _state._onEndReached();

  /// Refresh the notification list from scratch.
  Future<void> refresh() => _state._onRefresh();

  /// Mark a notification as read by its ID.
  Future<void> markAsRead(String id) => _state._markAsRead(id);

  /// Delete a notification by its ID.
  Future<void> delete(String id) => _state._delete(id);
}

/// A headless widget that fetches and manages notification data,
/// then exposes it via a builder callback.
///
/// Use this to build completely custom notification UIs (list views,
/// horizontal scroll views, etc.) while the SDK handles data fetching,
/// pagination, real-time updates, and read/delete state management.
///
/// ```dart
/// SirenNotificationBuilder(
///   itemsPerFetch: 10,
///   builder: (context, state, controller) {
///     if (state.isLoading) return CircularProgressIndicator();
///     return ListView.builder(
///       itemCount: state.notifications.length,
///       itemBuilder: (context, index) {
///         final notification = state.notifications[index];
///         return ListTile(
///           title: Text(notification.message.header ?? ''),
///           subtitle: Text(notification.message.body ?? ''),
///           onTap: () => controller.markAsRead(notification.id),
///         );
///       },
///     );
///   },
/// )
/// ```
class SirenNotificationBuilder extends StatefulWidget {
  /// Constructs a [SirenNotificationBuilder].
  const SirenNotificationBuilder({
    required this.builder,
    this.itemsPerFetch,
    this.isRead,
    this.categories,
    this.onError,
    super.key,
  });

  /// Builder that receives the current [SirenNotificationState] and a
  /// [SirenNotificationController] for triggering actions.
  final Widget Function(
    BuildContext context,
    SirenNotificationState state,
    SirenNotificationController controller,
  ) builder;

  /// Number of notifications per page (default 20, max 50).
  final int? itemsPerFetch;

  /// Filter by read status. `null` returns all, `false` for unread only.
  final bool? isRead;

  /// Filter by categories.
  final List<String>? categories;

  /// Callback for handling errors.
  final void Function(SirenErrorType)? onError;

  @override
  State<SirenNotificationBuilder> createState() =>
      _SirenNotificationBuilderState();
}

class _SirenNotificationBuilderState extends State<SirenNotificationBuilder> {
  List<NotificationType> _notifications = [];
  bool _isLoading = true;
  bool _isError = false;
  bool _hasMore = true;
  bool _loadingNextPage = false;
  SirenErrorType? _error;
  int _pageSize = 20;

  /// Incremented on every [_reset] so in-flight fetches can detect staleness.
  int _generation = 0;

  late Timer? _periodicUpdateRef;
  late StreamSubscription<StreamResponse> _subscription;
  late SirenNotificationController _controller;

  @override
  void initState() {
    super.initState();
    _pageSize = (widget.itemsPerFetch ?? Generics.PAGE_SIZE).clamp(1, 50);
    _periodicUpdateRef = Timer(const Duration(days: 1), () {});
    _controller = SirenNotificationController._(this);
    _subscribeToStream();
    _initialize();
  }

  @override
  void dispose() {
    _markAllAsViewed();
    _periodicUpdateRef?.cancel();
    _subscription.cancel();
    super.dispose();
  }

  void _safeSetState(VoidCallback callback) {
    if (mounted) setState(callback);
  }

  void _subscribeToStream() {
    _subscription = SirenDataProvider.instance.inboxController.stream.listen(
      (streamResponse) {
        if (streamResponse.api == UpdateEvents.PARAMS_CHANGED) {
          _reset(cancelFetch: true);
          _initialFetch();
          return;
        } else if (streamResponse.api == UpdateEvents.SHOW_ERROR) {
          _safeSetState(() => _isError = true);
        }
        if (streamResponse.response?.isSuccess ?? false) {
          switch (streamResponse.api) {
            case UpdateEvents.READ_BY_ID:
              _safeSetState(() {
                final match =
                    _notifications.where((n) => n.id == streamResponse.id);
                if (match.isNotEmpty) match.first.markAsRead();
              });
              break;
            case UpdateEvents.READ_ALL:
              _safeSetState(() {
                for (final n in _notifications) {
                  n.markAsRead();
                }
              });
              break;
            case UpdateEvents.DELETE_BY_ID:
              _safeSetState(() {
                _notifications.removeWhere((n) => n.id == streamResponse.id);
              });
              break;
            case UpdateEvents.DELETE_ALL:
              _safeSetState(() => _notifications = []);
              break;
            case UpdateEvents.TOKEN_VERIFIED:
              _reset(cancelFetch: true);
              _initialize();
              break;

            // ignore: no_default_cases, reason: All cases are handled above
            default:
          }
        } else if (streamResponse.response?.isError ?? false) {
          widget.onError
              ?.call(streamResponse.response?.error ?? SirenErrorType());
        }
      },
    );
  }

  Future<void> _initialize() async {
    if (SirenDataProvider.instance.tokenVerificationStatus == Status.SUCCESS) {
      await _initialFetch();
    } else if (SirenDataProvider.instance.tokenVerificationStatus ==
            Status.FAILED ||
        !SirenDataProvider.instance.isProviderInitialized) {
      widget.onError?.call(Errors.outsideSirenContextError);
      _safeSetState(() {
        _isLoading = false;
        _isError = true;
        _error = Errors.outsideSirenContextError;
      });
    }
  }

  void _reset({bool cancelFetch = false}) {
    _generation++;
    _safeSetState(() {
      _isLoading = true;
      _notifications = [];
      _hasMore = true;
    });
    if (cancelFetch) _periodicUpdateRef?.cancel();
  }

  Future<void> _initialFetch() async {
    final generation = _generation;
    _safeSetState(() => _isLoading = true);

    final response = await FetchAllNotifications.instance.fetchAllNotifications(
      end: DateTime.now().toUtc().toIso8601String(),
      size: _pageSize,
      isRead: widget.isRead,
      categories: widget.categories,
    );

    if (!mounted || generation != _generation) return;

    if (response.isSuccess) {
      unawaited(_markAllAsViewed());
      final list = response.data as Iterable<NotificationType>? ?? [];
      _safeSetState(() {
        _notifications.addAll(list);
        _isLoading = false;
        _isError = false;
        _hasMore = list.length >= _pageSize;
      });
      _startPolling();
    } else {
      _safeSetState(() {
        _isError = true;
        _isLoading = false;
        _error = response.error;
      });
      widget.onError?.call(response.error ?? SirenErrorType());
    }
  }

  void _startPolling() {
    _periodicUpdateRef?.cancel();
    _periodicUpdateRef = Timer.periodic(
      const Duration(seconds: Generics.DATA_FETCH_INTERVAL),
      (timer) async {
        if (!mounted) return;

        final generation = _generation;
        final response =
            await FetchAllNotifications.instance.fetchAllNotifications(
          size: _pageSize,
          isRead: widget.isRead,
          start: _notifications.isNotEmpty
              ? modifyAndConvertToISOString(_notifications[0].createdAt)
              : null,
          categories: widget.categories,
        );

        if (!mounted || generation != _generation) return;

        if (response.isSuccess) {
          final newNotifications = response.data as Iterable<NotificationType>;
          if (newNotifications.isNotEmpty) {
            unawaited(_markAllAsViewed());
            _safeSetState(() {
              _notifications.insertAll(0, newNotifications);
            });
          }
        } else if (response.isError) {
          widget.onError?.call(response.error ?? SirenErrorType());
        }
      },
    );
  }

  void _onEndReached() {
    if (!_isLoading &&
        !_loadingNextPage &&
        _hasMore &&
        _notifications.isNotEmpty) {
      final generation = _generation;
      _loadingNextPage = true;
      Future.delayed(Duration.zero, () async {
        final response =
            await FetchAllNotifications.instance.fetchAllNotifications(
          end: convertToISOString(_notifications.last.createdAt),
          size: _pageSize,
          isRead: widget.isRead,
          categories: widget.categories,
        );

        if (!mounted || generation != _generation) {
          _loadingNextPage = false;
          return;
        }

        if (response.isSuccess) {
          final newNotifications = response.data as Iterable<NotificationType>;
          _safeSetState(() {
            _notifications.addAll(newNotifications);
            _loadingNextPage = false;
            _hasMore = newNotifications.length >= _pageSize;
          });
        } else {
          _safeSetState(() => _loadingNextPage = false);
          widget.onError?.call(response.error ?? SirenErrorType());
        }
      });
    }
  }

  Future<void> _onRefresh() async {
    _reset(cancelFetch: true);
    await _initialFetch();
  }

  Future<void> _markAsRead(String id) async {
    final response = await ReadNotificationById.instance
        .readNotificationById(notificationId: id);
    if (response.isSuccess) {
      SirenDataProvider.instance.inboxController.sink.add(
        StreamResponse(response, UpdateEvents.READ_BY_ID, id),
      );
    } else {
      widget.onError?.call(response.error ?? SirenErrorType());
    }
  }

  Future<void> _delete(String id) async {
    final response = await DeleteNotificationById.instance
        .deleteNotificationById(notificationId: id);
    if (response.isSuccess) {
      SirenDataProvider.instance.inboxController.sink.add(
        StreamResponse(response, UpdateEvents.DELETE_BY_ID, id),
      );
    } else {
      widget.onError?.call(response.error ?? SirenErrorType());
    }
  }

  Future<void> _markAllAsViewed() async {
    await MarkAllNotificationsAsViewed.instance.markAllNotificationsAsViewed(
      untilDate: DateTime.now().toUtc().toIso8601String(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      SirenNotificationState(
        notifications: List.unmodifiable(_notifications),
        isLoading: _isLoading,
        isError: _isError,
        hasMore: _hasMore,
        error: _error,
      ),
      _controller,
    );
  }
}
