import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/models/notification_model.dart';
import 'package:siren_flutter_inbox/src/models/ui_models.dart';
import 'package:siren_flutter_inbox/src/utils/common_utils.dart';
import 'package:siren_flutter_inbox/src/widgets/common/nullable_text.dart';

class CardWidget extends StatefulWidget {
  final Function onCardClick;
  final NotificationDataType notification;
  final CardProps cardProps;
  final SirenStyleProps? styles;
  final void Function(String) onDelete;
  final Widget? deleteWidget;

  CardWidget(
      {required this.onCardClick,
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
        widget.onCardClick(widget.notification);
      },
      child: Container(
        decoration:
            widget.styles?.container ?? _getDefaultContainerDecoration(),
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDefaultContainerDecoration() {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.blueGrey.withOpacity(0.2),
        ),
      ),
      color: widget.notification.cardColor ??
          (widget.notification.isRead ?? true ? null : const Color(0xFFFDEDE7)),
    );
  }

  Container _buildDefaultAvatarContainer() {
    return Container(
      decoration: widget.styles?.cardIconContainer,
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
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

  Text _buildHeaderText() {
    return Text(
      (widget.notification.message?.header ?? '').toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: widget.styles?.cardTitle ??
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildSubHeaderText() {
    return NullableText(
      text: widget.notification.message?.subHeader,
      style: widget.styles?.subHeaderText ??
          const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
    );
  }

  Widget _buildBodyText() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.notification.message?.body ?? '',
          style: widget.styles?.cardDescription ??
              const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Container _buildFooterRow() {
    return Container(
      decoration: widget.styles?.cardFooterRow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimestampText(),
          GestureDetector(
            onTap: () => widget.onDelete(widget.notification.id ?? ''),
            child: widget.deleteWidget ?? _buildDefaultDeleteButton(),
          ),
        ],
      ),
    );
  }

  Text _buildTimestampText() {
    return Text(
      generateElapsedTimeText(
          DateTime.parse(widget.notification.createdAt ?? '')),
      style: widget.styles?.dateStyle ?? const TextStyle(fontSize: 12),
    );
  }

  Widget _buildDefaultDeleteButton() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Icon(
        Icons.delete_outline,
        color: Colors.red,
        size: 25,
      ),
    );
  }
}
