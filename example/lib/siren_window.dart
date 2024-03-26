import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';

class SirenWindowWidget extends StatelessWidget {
  const SirenWindowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SirenInbox(
            onError: (error) {
              // print('This is the inApp error message ${error.message}');
            },
          ),
        ],
      ),
    );
  }
}
