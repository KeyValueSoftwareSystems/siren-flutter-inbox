library siren_flutter_inbox;

import 'package:flutter/material.dart';

/// A Demo Text UI.
class CustomText extends StatelessWidget {
  const CustomText({super.key});

  @override
  Widget build(BuildContext context) {
    final sirenProvider = SirenProvider.of(context);
    final userToken = sirenProvider?.userToken;
    return Text('TOKEN $userToken');
  }
}

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
