import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SirenProvider(
// Get in touch with the Siren team to obtain the necessary token and ID for integration.
      userToken: 'YOUR_USER_TOKEN',
      recipientId: 'YOUR_RECIPIENT_ID',
      child: MaterialApp(
        title: 'Siren',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEB5017)),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex == 0
            ? const Text('Siren Icon')
            : const Text('Siren Inbox'),
        actions: _selectedIndex == 0
            ? []
            : [
                IconButton(
                    onPressed: () {
                      Siren.deleteByDate(
                          startDate: DateTime.now().toUtc().toIso8601String());
                    },
                    icon: const Icon(Icons.delete_forever)),
                IconButton(
                    onPressed: () {
                      Siren.markAsReadByDate(
                          startDate: DateTime.now().toUtc().toIso8601String());
                    },
                    icon: const Icon(Icons.mark_email_read)),
              ],
      ),
      body: _selectedIndex == 0
          ? const SirenIconWidget()
          : const SirenWindowWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: 35),
            label: 'Icon',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, size: 35),
            label: 'Window',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class SirenIconWidget extends StatefulWidget {
  const SirenIconWidget({Key? key}) : super(key: key);

  @override
  State<SirenIconWidget> createState() => _SirenIconWidgetState();
}

class _SirenIconWidgetState extends State<SirenIconWidget> {
  Icon? notificationIcon;
  bool? hideBadge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: SirenInboxIcon(
              notificationIcon: notificationIcon,
              darkMode: true,
              hideBadge: hideBadge,
              onError: (error) {
                // print('This is the inApp error message ${error.message}');
              },
            ),
          ),
          Text(
            'You are viewing ${notificationIcon == null ? 'default' : 'custom'} icon',
          ),
          Text(
            'You are ${hideBadge == false ? 'viewing' : 'not viewing'} notification count',
          ),
          const Spacer(),
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
                  child: Text(
                    notificationIcon == null ? 'Custom Icon' : 'Default Icon',
                  ),
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
