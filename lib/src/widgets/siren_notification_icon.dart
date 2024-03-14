// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/api/fetch_unviewed_notification_count.dart';
import 'package:siren_flutter_inbox/src/api/verify_token.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:siren_flutter_inbox/src/theme/app_theme.dart';

class SirenNotificationIconWidget extends StatefulWidget {
  const SirenNotificationIconWidget({
    super.key,
    this.darkMode = false,
    this.onError,
    this.notificationIcon,
    this.onTap,
    this.customStyles,
    this.customTheme,
  });

  final bool? darkMode;
  final void Function(ApiErrorDetails)? onError;
  final Widget? notificationIcon;
  final VoidCallback? onTap;
  final SirenStyleProps? customStyles;
  final CustomThemeColors? customTheme;

  @override
  State<SirenNotificationIconWidget> createState() =>
      _SirenNotificationIconWidgetState();
}

class _SirenNotificationIconWidgetState
    extends State<SirenNotificationIconWidget> {
  int _notificationsCount = 0;

  ApiResponse _tokenVerificationResponse = ApiResponse()..isLoading;
  Status _tokenVerificationStatus = Status.PENDING;

  late Timer _periodicUpdateRef;

  late StreamSubscription<StreamResponse> _subscription;

  @override
  void initState() {
    super.initState();
    _initialize();
    _subscribeToStream();
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
        if (streamResponse.response?.isSuccess ?? false) {
          if (streamResponse.api == UpdateEvents.VIEW_ALL) {
            final response = await FetchUnviewedNotificationsCount.instance
                .fetchUnviewedNotificationsCount();
            setState(() {
              updateNotificationsCount(response.data);
            });
          }
        }
      },
    );
  }

  void updateNotificationsCount(dynamic responseData) {
    if (responseData != null && responseData is int) {
      _notificationsCount = responseData;
    }
  }

  void _startRealTimeUnviewedCountFetch() {
    _periodicUpdateRef = Timer.periodic(
        const Duration(seconds: Generics.DATA_FETCH_INTERVAL), (timer) async {
      final response = await FetchUnviewedNotificationsCount.instance
          .fetchUnviewedNotificationsCount();
      setState(() {
        updateNotificationsCount(response.data);
      });
    });
  }

  Future<void> _initialize() async {
    await _verifyToken();
    if (_tokenVerificationResponse.isSuccess) {
      if (_tokenVerificationStatus == Status.SUCCESS) {
        final response = await FetchUnviewedNotificationsCount.instance
            .fetchUnviewedNotificationsCount();
        if (response.isSuccess) {
          _startRealTimeUnviewedCountFetch();
          setState(
            () {
              updateNotificationsCount(response.data);
            },
          );
        } else if (response.isError) {
          widget.onError?.call(response.error ?? ApiErrorDetails());
        }
      }
    } else if (_tokenVerificationResponse.isError) {
      widget.onError
          ?.call(_tokenVerificationResponse.error ?? ApiErrorDetails());
    }
  }

  Future<void> _verifyToken() async {
    _tokenVerificationResponse = await VerifyToken.instance.verifyToken();
    _tokenVerificationStatus = _tokenVerificationResponse.data as Status;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.customTheme != null
          ? AppTheme.customTheme(widget.customTheme!, isDarkMode: widget.darkMode ?? false)
          : (widget.darkMode ?? false
              ? AppTheme.darkTheme
              : AppTheme.lightTheme),
      child: Builder(
        builder: (context) {
          final size = widget.customStyles?.iconStyle?.size ?? 35;
          final currentTheme = Theme.of(context);
          return GestureDetector(
            onTap: widget.onTap ?? () {},
            child: Stack(
              children: [
                SizedBox(
                  width: size,
                  height: size,
                  child: widget.notificationIcon ??
                      // TODO can remove this png later
                      // Image.asset(
                      //   Generics.BELL_ICON_PATH,
                      //   fit: BoxFit.contain,
                      // ),
                      Icon(
                        Icons.notifications_none_outlined,
                        size: size,
                        color: currentTheme.colorScheme.onPrimary,
                      ),
                ),
                if (_notificationsCount > 0) _getBadge(context),
              ],
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
      right: badgeStyle?.right ?? 2,
      top: badgeStyle?.top ?? 0,
      child: Container(
        width: badgeStyle?.size ?? 18,
        height: badgeStyle?.size ?? 18,
        padding: EdgeInsets.all(badgeStyle?.inset ?? 1),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentTheme.colorScheme.tertiaryContainer,
        ),
        child: Align(
          child: Text(
            _notificationsCount > 99 ? '99+' : _notificationsCount.toString(),
            style: TextStyle(
              color: currentTheme.colorScheme.onTertiary,
              fontSize: badgeStyle?.fontSize ?? 10,
            ),
          ),
        ),
      ),
    );
  }
}
