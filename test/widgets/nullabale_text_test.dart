import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/common/nullable_text.dart';

void main() {
  testWidgets('NullableText displays text when not null or empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NullableText(
          text: 'Hello',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
    final textFinder = find.text('Hello');

    expect(textFinder, findsOneWidget);
  });

  testWidgets('NullableText displays nothing when text is null',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NullableText(
          style: TextStyle(color: Colors.black),
        ),
      ),
    );

    final textFinder = find.byType(Text);

    expect(textFinder, findsNothing);
  });

  testWidgets('NullableText displays nothing when text is empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NullableText(
          text: '',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );

    final textFinder = find.byType(Text);

    expect(textFinder, findsNothing);
  });
}
