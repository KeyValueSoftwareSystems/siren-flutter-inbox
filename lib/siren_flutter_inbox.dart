library siren_flutter_inbox;

import 'package:flutter/material.dart';

export 'package:siren_flutter_inbox/src/models/ui_models.dart';
export 'package:siren_flutter_inbox/src/widgets/siren_notification_icon.dart';
export 'package:siren_flutter_inbox/src/widgets/siren_window.dart';

class SirenProvider extends InheritedWidget {
  const SirenProvider({
    required this.userToken,
    required this.recipientId,
    required Widget child,
  }) : super(child: child);
  final String userToken;
  final String recipientId;

  static SirenProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SirenProvider>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
