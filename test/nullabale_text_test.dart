import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/common/nullable_text.dart';

void main() {
  testWidgets('NullableText displays text when not null or empty',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: NullableText(
          text: 'Hello',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );

    // Find the Text widget
    final textFinder = find.text('Hello');

    // Verify that the Text widget is present
    expect(textFinder, findsOneWidget);
  });

  testWidgets('NullableText displays nothing when text is null',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: NullableText(
          style: TextStyle(color: Colors.black),
        ),
      ),
    );

    // Find the Text widget
    final textFinder = find.byType(Text);

    // Verify that the Text widget is not present
    expect(textFinder, findsNothing);
  });

  testWidgets('NullableText displays nothing when text is empty',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: NullableText(
          text: '',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );

    // Find the Text widget
    final textFinder = find.byType(Text);

    // Verify that the Text widget is not present
    expect(textFinder, findsNothing);
  });
}
