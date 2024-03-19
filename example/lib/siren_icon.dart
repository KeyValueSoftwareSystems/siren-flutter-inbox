import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';

class SirenIconWidget extends StatefulWidget {
  const SirenIconWidget({Key? key}) : super(key: key);

  @override
  _SirenIconWidgetState createState() => _SirenIconWidgetState();
}

class _SirenIconWidgetState extends State<SirenIconWidget> {
  Icon? notificationIcon;
  bool? hideBadge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Center(
            child: SirenInboxIcon(
              notificationIcon: notificationIcon,
              darkMode: true,
              hideBadge: hideBadge,
              onError: (error) {
                print('This is the inApp error message ${error.message}');
              },
            ),
          ),
          Text(
            'You are viewing ${notificationIcon == null ? 'default' : 'custom'} icon',
          ),
          Text(
            'You are ${hideBadge == false ? 'viewing' : 'not viewing'} notification count',
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      notificationIcon = notificationIcon == null
                          ? const Icon(
                              Icons.notification_add,
                              color: Colors.black,
                            )
                          : null;
                    });
                  },
                  child: Text(notificationIcon == null
                      ? 'Custom Notification'
                      : 'Default Notification'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      hideBadge = hideBadge == false ? true : false;
                    });
                  },
                  child: Text(
                    hideBadge == true ? 'Show Count Badge' : 'Hide Count Badge',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
