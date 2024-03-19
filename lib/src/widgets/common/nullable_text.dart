import 'package:flutter/material.dart';

class NullableText extends StatelessWidget {
  const NullableText({
    required this.style,
    super.key,
    this.text,
  });
  final String? text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (text != null && text!.isNotEmpty) {
      return Text(
        text!,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
