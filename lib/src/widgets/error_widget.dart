import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Oops something happened'),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Retry'),
        )
      ],
    );
  }
}
