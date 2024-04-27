import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/app_bar.dart';

void main() {
  testWidgets('SirenAppBar displays title', (WidgetTester tester) async {
    const title = 'Notifications';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: SirenAppBar(
            headerParams: HeaderParams(
              title: title,
              showBackButton: false,
            ),
            isNonEmptyNotifications: false,
          ),
        ),
      ),
    );

    expect(find.text(title), findsOneWidget);
  });

  testWidgets('SirenAppBar displays back button when showBackButton is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: SirenAppBar(
            headerParams: HeaderParams(
              title: 'Title',
              showBackButton: true,
            ),
            isNonEmptyNotifications: false,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
  });

  testWidgets(
      'SirenAppBar does not display clear all button when hideClearAll is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: SirenAppBar(
            headerParams: HeaderParams(
              title: 'Title',
              showBackButton: false,
              hideClearAll: true,
            ),
            isNonEmptyNotifications: true,
          ),
        ),
      ),
    );

    expect(find.text('Clear All'), findsNothing);
  });

  testWidgets(
      'SirenAppBar displays clear all button when showClearAllButton is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: SirenAppBar(
            headerParams: HeaderParams(
              title: 'Title',
              showBackButton: false,
            ),
            isNonEmptyNotifications: true,
          ),
        ),
      ),
    );

    expect(find.text('Clear All'), findsOneWidget);
  });

  testWidgets(
      'SirenAppBar calls onBackButtonPressed when back button is pressed',
      (WidgetTester tester) async {
    var backButtonPressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: SirenAppBar(
            headerParams: HeaderParams(
              title: 'Title',
              showBackButton: true,
              onBackPress: () {
                backButtonPressed = true;
              },
            ),
            isNonEmptyNotifications: false,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    expect(backButtonPressed, true);
  });

  testWidgets(
      'SirenAppBar calls onClearAllPressed when clear all button is pressed',
      (WidgetTester tester) async {
    var clearAllPressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: SirenAppBar(
            headerParams: HeaderParams(
              title: 'Title',
              showBackButton: false,
            ),
            isNonEmptyNotifications: true,
            onClearAllPressed: () {
              clearAllPressed = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Clear All'));
    expect(clearAllPressed, true);
  });
}
