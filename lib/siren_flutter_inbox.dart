library siren_flutter_inbox;

import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';

export 'package:siren_flutter_inbox/src/models/api_response.dart';
export 'package:siren_flutter_inbox/src/models/notification_model.dart';
export 'package:siren_flutter_inbox/src/models/ui_models.dart';
export 'package:siren_flutter_inbox/src/utils/siren.dart';
export 'package:siren_flutter_inbox/src/widgets/siren_notification_icon.dart';
export 'package:siren_flutter_inbox/src/widgets/siren_window.dart';

class SirenProvider extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return child;
  }
}
