import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/icon_badge.dart';

void main() {
  group('IconBadge Widget Test', () {
    testWidgets('Testing with valid parameters', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: const [
                IconBadge(
                  badgeStyle: BadgeStyle(),
                  notificationsCount: 5,
                  hideBadge: false,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(Positioned), findsOneWidget);

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('Testing with hideBadge true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: const [
                IconBadge(
                  badgeStyle: BadgeStyle(),
                  notificationsCount: 5,
                  hideBadge: true,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(Positioned), findsNothing);
    });

    testWidgets('Testing with notificationsCount > 99',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: const [
                IconBadge(
                  badgeStyle: BadgeStyle(),
                  notificationsCount: 100,
                  hideBadge: false,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('99+'), findsOneWidget);
    });
  });
}
