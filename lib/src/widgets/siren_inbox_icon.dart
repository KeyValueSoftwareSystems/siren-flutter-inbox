import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/api/fetch_unviewed_notification_count.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/theme/app_theme.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/icon_badge.dart';

/// Widget representing the inbox icon.
class SirenInboxIcon extends StatefulWidget {
  /// Constructs SirenInboxIcon widget.
  const SirenInboxIcon({
    super.key,
    this.darkMode = false,
    this.disabled = false,
    this.hideBadge = false,
    this.notificationIcon,
    this.onError,
    this.onTap,
    this.theme,
    this.customStyles,
  });

  /// Whether to use dark mode or not.
  final bool darkMode;

  /// Whether the inbox icon is disabled or not.
  final bool disabled;

  /// Custom theme colors.
  final CustomThemeColors? theme;

  /// Custom styles for the inbox icon.
  final SirenStyleProps? customStyles;

  /// Callback function to handle errors.
  final void Function(ApiErrorDetails)? onError;

  /// Callback function when the inbox icon is tapped.
  final VoidCallback? onTap;

  /// Widget representing the notification icon.
  final Widget? notificationIcon;

  /// Whether to hide the badge or not.
  final bool? hideBadge;

  @override
  State<SirenInboxIcon> createState() => _SirenInboxIconState();
}

class _SirenInboxIconState extends State<SirenInboxIcon> {
  int _notificationsCount = 0;

  bool _processingGesture = false;

  late Timer _periodicUpdateRef;

  late StreamSubscription<StreamResponse> _subscription;

  @override
  void initState() {
    super.initState();
    _subscribeToStream();
    _periodicUpdateRef = Timer(const Duration(days: 1), () {});
    _initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _periodicUpdateRef.cancel();
    _subscription.cancel();
  }

  void _subscribeToStream() {
    _subscription = SirenDataProvider.instance.iconController.stream.listen(
      (streamResponse) async {
        if (streamResponse.api == UpdateEvents.PARAMS_CHANGED) {
          await _reset();
          return;
        }
        if (streamResponse.response?.isSuccess ?? false) {
          switch (streamResponse.api) {
            case UpdateEvents.VIEW_ALL:
              {
                await _markAllNotificationsAsViewed();
                break;
              }
            case UpdateEvents.TOKEN_VERIFIED:
              {
                await _initialize();
                break;
              }
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

  Future<void> _reset() async {
    if (mounted) {
      setState(() {
        _notificationsCount = 0;
      });
    }
    _periodicUpdateRef.cancel();
  }

  Future<void> _markAllNotificationsAsViewed() async {
    final response = await FetchUnViewedNotificationsCount.instance
        .fetchUnViewedNotificationsCount();
    if (mounted) {
      setState(() {
        _updateNotificationsCount(response.data);
      });
    }
  }

  void _updateNotificationsCount(dynamic responseData) {
    if (responseData != null && responseData is int) {
      _notificationsCount = responseData;
    }
  }

  void _startRealTimeUnViewedCountFetch() {
    _periodicUpdateRef.cancel();
    _periodicUpdateRef = Timer.periodic(
        const Duration(seconds: Generics.DATA_FETCH_INTERVAL), (timer) async {
      final response = await FetchUnViewedNotificationsCount.instance
          .fetchUnViewedNotificationsCount();
      if (mounted) {
        setState(() {
          _updateNotificationsCount(response.data);
        });
      }
    });
  }

  Future<void> _initialize() async {
    if (SirenDataProvider.instance.tokenVerificationStatus == Status.SUCCESS) {
      final response = await FetchUnViewedNotificationsCount.instance
          .fetchUnViewedNotificationsCount();
      if (response.isSuccess) {
        _startRealTimeUnViewedCountFetch();
        if (mounted) {
          setState(
            () {
              _updateNotificationsCount(response.data);
            },
          );
        }
      } else if (response.isError) {
        widget.onError?.call(response.error ?? ApiErrorDetails());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.theme != null
          ? AppTheme.customTheme(
              widget.theme!,
              isDarkMode: widget.darkMode,
            )
          : (widget.darkMode ? AppTheme.darkTheme : AppTheme.lightTheme),
      child: Builder(
        builder: (context) {
          final size =
              widget.customStyles?.iconStyle?.size ?? DefaultIconStyle.iconSize;
          final currentTheme = Theme.of(context);
          return IgnorePointer(
            ignoring: widget.disabled,
            child: GestureDetector(
              onTap: () {
                if (!_processingGesture && mounted) {
                  setState(() {
                    _processingGesture = true;
                  });
                  if (widget.onTap != null) {
                    widget.onTap?.call();
                  }
                }
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    _processingGesture = false;
                  });
                });
              },
              child: Stack(
                children: [
                  SizedBox(
                    width: size,
                    height: size,
                    child: widget.notificationIcon ??
                        Icon(
                          Icons.notifications_none_outlined,
                          size: size,
                          color: currentTheme.colorScheme.onPrimary,
                        ),
                  ),
                  IconBadge(
                    hideBadge:
                        _notificationsCount == 0 || (widget.hideBadge ?? false),
                    badgeStyle: widget.customStyles?.badgeStyle,
                    notificationsCount: _notificationsCount,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
