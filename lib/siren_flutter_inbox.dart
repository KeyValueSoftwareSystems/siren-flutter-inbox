import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';

export 'package:siren_flutter_inbox/src/models/api_response.dart';
export 'package:siren_flutter_inbox/src/models/notification_model.dart';
export 'package:siren_flutter_inbox/src/models/ui_models.dart';
export 'package:siren_flutter_inbox/src/utils/siren.dart';
export 'package:siren_flutter_inbox/src/widgets/siren_inbox.dart';
export 'package:siren_flutter_inbox/src/widgets/siren_inbox_icon.dart';

class SirenProvider extends StatefulWidget {
  SirenProvider({
    required this.userToken,
    required this.recipientId,
    required this.child,
    super.key,
  }) {
    SirenDataProvider.instance
        .updateParams(userToken: userToken, recipientId: recipientId);
  }
  final String userToken;
  final String recipientId;
  final Widget child;

  @override
  State<SirenProvider> createState() => _SirenProviderState();
}

class _SirenProviderState extends State<SirenProvider> {
  @override
  void didUpdateWidget(SirenProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userToken != widget.userToken ||
        oldWidget.recipientId != widget.recipientId) {
      SirenDataProvider.instance.updateParams(
        userToken: widget.userToken,
        recipientId: widget.recipientId,
      );
      SirenDataProvider.instance.iconController.sink
          .add(StreamResponse(null, UpdateEvents.PARAMS_CHANGED, ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
