import 'package:flutter/material.dart';

class NullableText extends StatelessWidget {
  final String? text;
  final TextStyle? style;

  const NullableText({
    Key? key,
    this.text,
    required this.style,
  }) : super(key: key);

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
