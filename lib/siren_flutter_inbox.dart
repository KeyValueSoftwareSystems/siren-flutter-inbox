library siren_flutter_inbox;

import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';

export 'package:siren_flutter_inbox/src/api/mark_notifications_as_viewed.dart';
export 'package:siren_flutter_inbox/src/models/ui_models.dart';
export 'package:siren_flutter_inbox/src/widgets/siren_notification_icon.dart';
export 'package:siren_flutter_inbox/src/widgets/siren_window.dart';

/// A Demo Text UI.
class CustomText extends StatelessWidget {
  const CustomText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('USER TOKEN IS');
  }
}

// class SirenProvider extends InheritedWidget {
//   const SirenProvider({
//     required this.userToken,
//     required this.recipientId,
//     required Widget child,
//   }) : super(child: child);
//   final String userToken;
//   final String recipientId;

//   static SirenProvider? of(BuildContext context) {
//     //  SirenDataProvider.instance.updateParams(userToken: userToken, recipientId: recipientId);
//     // return context.dependOnInheritedWidgetOfExactType<SirenProvider>();
//     final sirenProvider = context.dependOnInheritedWidgetOfExactType<SirenProvider>();
//     if (sirenProvider != null) {
//       // Access the context indirectly by passing it to the updateParams method
//       SirenDataProvider.instance.updateParams(
//         userToken: sirenProvider.userToken,
//         recipientId: sirenProvider.recipientId,
//       );
//     }
//     return sirenProvider;
//   }

//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) {
//     return false;
//   }

// }

class SirenProvider extends StatelessWidget {
  SirenProvider({
    required this.userToken,
    required this.recipientId,
    required this.child,
    super.key,
  }) {
    // Perform initialization logic using the props
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
