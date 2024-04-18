import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import './siren_icon.dart';
import './siren_window.dart';
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
                      Siren.deleteNotificationByDate(
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
