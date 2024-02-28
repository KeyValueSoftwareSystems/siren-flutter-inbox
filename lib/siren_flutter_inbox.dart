library siren_flutter_inbox;

import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/src/models/ui_models.dart';

export 'package:siren_flutter_inbox/src/models/ui_models.dart';
export 'package:siren_flutter_inbox/src/widgets/siren_window.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key, this.customStyles, this.hideAvatar, this.deleteWidget});
  final SirenStyleProps? customStyles;
  final bool? hideAvatar;
  final Widget? deleteWidget;

  @override
  Widget build(BuildContext context) {
    return const Text('HYE THIS IS SIREN DUMMY TEXT');
  }
}
