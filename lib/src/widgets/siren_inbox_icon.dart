import 'dart:async';

import 'package:flutter/material.dart';

import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/api/fetch_unviewed_notification_count.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:siren_flutter_inbox/src/theme/app_theme.dart';

class SirenInboxIcon extends StatefulWidget {
  const SirenInboxIcon({
    super.key,
    this.customStyles,
    this.theme,
    this.darkMode = false,
    this.disabled = false,
    this.notificationIcon,
    this.onError,
    this.onTap,
  });

  final bool darkMode;
  final bool disabled;
  final CustomThemeColors? theme;
  final SirenStyleProps? customStyles;
  final void Function(ApiErrorDetails)? onError;
  final VoidCallback? onTap;
  final Widget? notificationIcon;

  @override
  State<SirenInboxIcon> createState() => _SirenInboxIconState();
}

class _SirenInboxIconState extends State<SirenInboxIcon> {
  int _notificationsCount = 0;

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
    SirenDataProvider.instance.dispose();
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
        }
      },
    );
  }

  Future<void> _reset() async {
    _notificationsCount = 0;
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
              onTap: widget.onTap ?? () {},
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
                  if (_notificationsCount > 0) _getBadge(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getBadge(BuildContext context) {
    final badgeStyle = widget.customStyles?.badgeStyle;
    final currentTheme = Theme.of(context);
    return Positioned(
      right: badgeStyle?.right ?? DefaultIconStyle.defaultRight,
      top: badgeStyle?.top ?? DefaultIconStyle.defaultTop,
      child: Container(
        width: badgeStyle?.size ?? DefaultIconStyle.defaultSize,
        height: badgeStyle?.size ?? DefaultIconStyle.defaultSize,
        padding:
            EdgeInsets.all(badgeStyle?.inset ?? DefaultIconStyle.defaultInset),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentTheme.colorScheme.tertiaryContainer,
        ),
        child: Align(
          child: Text(
            _notificationsCount > 99 ? '99+' : _notificationsCount.toString(),
            style: TextStyle(
              color: currentTheme.colorScheme.onTertiary,
              fontSize:
                  badgeStyle?.fontSize ?? DefaultIconStyle.defaultFontSize,
            ),
          ),
        ),
      ),
    );
  }
}
