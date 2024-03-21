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

/// Provides access to the Siren SDK functionalities.
class SirenProvider extends StatefulWidget {
  /// Constructs SirenProvider widget.
  const SirenProvider({
    required this.userToken,
    required this.recipientId,
    required this.child,
    super.key,
  });

  /// User token used for authentication.
  final String userToken;

  /// Recipient identifier.
  final String recipientId;

  /// Child widget to be wrapped by the provider.
  final Widget child;

  @override
  State<SirenProvider> createState() => _SirenProviderState();
}

class _SirenProviderState extends State<SirenProvider> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    super.dispose();
    SirenDataProvider.instance.inboxDispose();
    SirenDataProvider.instance.iconDispose();
  }

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
      SirenDataProvider.instance.inboxController.sink
          .add(StreamResponse(null, UpdateEvents.PARAMS_CHANGED, ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  /// Initializes the Siren provider.
  Future<void> initialize() async {
    await SirenDataProvider.instance.initialize();
    SirenDataProvider.instance.updateParams(
      userToken: widget.userToken,
      recipientId: widget.recipientId,
    );
  }
}
