import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/constants/colors.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/models/notification_model.dart';
import 'package:siren_flutter_inbox/src/models/ui_models.dart';
import 'package:siren_flutter_inbox/src/utils/common_utils.dart';
import 'package:siren_flutter_inbox/src/widgets/common/nullable_text.dart';

class CardWidget extends StatefulWidget {
  final Function onTap;
  final NotificationDataType notification;
  final CardProps cardProps;
  final SirenStyleProps? styles;
  final void Function(String) onDelete;
  final Widget? deleteWidget;

  CardWidget(
      {required this.onTap,
      required this.notification,
      required this.cardProps,
      required this.styles,
      required this.onDelete,
      Key? key,
      this.deleteWidget})
      : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.notification);
      },
      child: Container(
        decoration:
            widget.styles?.container ?? _getDefaultContainerDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: widget.styles?.contentContainer,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!(widget.cardProps.hideAvatar ?? false))
                    _buildDefaultAvatarContainer(),
                  Expanded(
                    child: Container(
                      decoration: widget.styles?.cardContentContainer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeaderText(),
                            _buildSubHeaderText(),
                            _buildBodyText(),
                            _buildFooterRow(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.onDelete(widget.notification.id ?? ''),
                    child: widget.deleteWidget ?? _buildDefaultDeleteButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BorderSide _getDefaultBorderDecoration() {
    return BorderSide(
      color: widget.notification.isRead ?? true
          ? Colors.transparent
          : AppColors.lightGrey,
      width: 0.5,
    );
  }

  BoxDecoration _getDefaultContainerDecoration() {
    return BoxDecoration(
      border: Border(
        left: BorderSide(
          color: widget.notification.isRead ?? true
              ? Colors.transparent
              : AppColors.secondaryColor,
          width: 4,
        ),
        right: _getDefaultBorderDecoration(),
        top: _getDefaultBorderDecoration(),
      ),
      color: widget.notification.cardColor ??
          (widget.notification.isRead ?? true
              ? null
              : widget.styles?.cardUnreadColor ??
                  AppColors.secondaryLightColor),
    );
  }

  Widget _buildDefaultAvatarContainer() {
    return Container(
      decoration: widget.styles?.cardAvatarContainer,
      child: CircleAvatar(
        radius: 21,
        backgroundImage: widget.notification.message?.avatar?.url != null
            ? NetworkImage(
                widget.notification.message!.avatar!.url!,
              )
            : const NetworkImage(
                Generics.PLACEHOLDER_IMAGE_URL,
              ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Text(
      capitalizeString(widget.notification.message?.header ?? ''),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: widget.styles?.cardTitle ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
    );
  }

  Widget _buildSubHeaderText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: NullableText(
        text: widget.notification.message?.subHeader,
        style: widget.styles?.subHeaderText ??
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryText,
            ),
      ),
    );
  }

  Widget _buildBodyText() {
    return Text(
      widget.notification.message?.body ?? '',
      style: widget.styles?.cardDescription ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.primaryText,
          ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Container(
        decoration: widget.styles?.cardFooterRow,
        child: _buildTimestampText(),
      ),
    );
  }

  Widget _buildTimestampText() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 2),
          child: Icon(
            Icons.access_time_sharp,
            color: AppColors.primaryText,
            size: 14,
          ),
        ),
        Text(
          generateElapsedTimeText(
              DateTime.parse(widget.notification.createdAt ?? '')),
          style: widget.styles?.dateStyle ??
              const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryText,
              ),
        ),
      ],
    );
  }

  Widget _buildDefaultDeleteButton() {
    return const Icon(
      Icons.close,
      color: AppColors.primaryGrey,
      size: 16,
    );
  }
}
